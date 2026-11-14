import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'printer_companion.dart';

class LocalWebCompanionController extends ChangeNotifier {
  static const _workspacePreferenceKey = 'local_web_companion_workspace_v1';
  static const _apiPort = 8080;
  static const _webPort = 24339;

  final PrinterCompanionController printerController;
  final List<String> _logs = [];

  String workspacePath = '';
  String status = 'اختر مجلد Codes_System ثم ابدأ التشغيل.';
  bool isBusy = false;
  bool isRunning = false;
  bool _stopping = false;
  bool _disposed = false;

  Process? _buildProcess;
  Process? _apiProcess;
  Process? _webProcess;
  int? _apiExitCode;
  int? _webExitCode;
  Map<String, String> _environment = {};
  final Set<String> _redactValues = {};

  LocalWebCompanionController({PrinterCompanionController? printerController})
    : printerController = printerController ?? PrinterCompanionController();

  List<String> get logs => List.unmodifiable(_logs);
  String get webUrl => 'http://127.0.0.1:$_webPort';

  Future<void> restoreLastWorkspace() async {
    final preferences = await SharedPreferences.getInstance();
    workspacePath = preferences.getString(_workspacePreferenceKey) ?? '';
    _notify();
  }

  Future<void> chooseWorkspace() async {
    final selected = await FilePicker.getDirectoryPath(
      dialogTitle: 'اختر مجلد Codes_System الكامل',
    );
    if (selected == null || selected.trim().isEmpty) return;
    workspacePath = selected;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_workspacePreferenceKey, selected);
    status = 'تم اختيار مجلد المشروع. اضغط تشغيل لبدء الخدمات.';
    _notify();
  }

  Future<void> start() async {
    if (isBusy || isRunning) return;
    _stopping = false;
    isBusy = true;
    status = 'جارٍ فحص الإعدادات المحلية...';
    _logs.clear();
    _notify();

    try {
      final root = Directory(workspacePath);
      await _validateWorkspace(root);
      _environment = await _loadEnvironment(root);
      final databaseUrl = _environment['DATABASE_URL']?.trim();
      if (databaseUrl == null || databaseUrl.isEmpty) {
        throw StateError(
          'لم يُعثر على DATABASE_URL. أضف اتصال قاعدة PostgreSQL محلية '
          'إلى ملف .env في مجلد المشروع.',
        );
      }
      if ((_environment['SESSION_SECRET'] ?? '').trim().isEmpty) {
        _environment['SESSION_SECRET'] = _createSessionSecret();
      }
      _redactValues
        ..clear()
        ..addAll(
          [
            databaseUrl,
            _environment['SESSION_SECRET'] ?? '',
            _environment['ACCOUNTING_ROLE_PASSWORDS'] ?? '',
          ].where((value) => value.isNotEmpty),
        );

      await _checkTool('node', const ['--version'], root.path);
      await _checkTool('pnpm', const ['--version'], root.path);
      await _checkTool('flutter', const ['--version'], root.path);
      await _ensurePortsAvailable();
      _ensureNotStopping();

      final buildEnvironment = Map<String, String>.from(_environment)
        ..['NODE_ENV'] = 'development';
      await _runBuild(
        root.path,
        const ['--filter', '@workspace/api-server', 'run', 'build'],
        buildEnvironment,
        'بناء خادم API',
      );
      await _runBuild(
        root.path,
        const ['--filter', '@workspace/accounting', 'run', 'build'],
        buildEnvironment,
        'بناء واجهة المحاسبة',
      );
      _ensureNotStopping();

      await printerController.start();
      _log('خدمة الطباعة: ${printerController.status}');

      final apiEnvironment = Map<String, String>.from(buildEnvironment)
        ..['HOST'] = '127.0.0.1'
        ..['PORT'] = '$_apiPort';
      _apiExitCode = null;
      _apiProcess = await Process.start(
        'node',
        const ['--enable-source-maps', 'artifacts/api-server/dist/index.mjs'],
        workingDirectory: root.path,
        environment: apiEnvironment,
        runInShell: Platform.isWindows,
      );
      _watchProcess(_apiProcess!, 'خادم API', (code) => _apiExitCode = code);
      await _waitForHttp(
        'http://127.0.0.1:$_apiPort/api/healthz',
        const Duration(seconds: 75),
        'خادم API',
      );

      final webEnvironment = Map<String, String>.from(buildEnvironment)
        ..['HOST'] = '127.0.0.1'
        ..['PORT'] = '$_webPort'
        ..['API_PORT'] = '$_apiPort';
      _webExitCode = null;
      _webProcess = await Process.start(
        'node',
        const ['artifacts/accounting/serve.mjs'],
        workingDirectory: root.path,
        environment: webEnvironment,
        runInShell: Platform.isWindows,
      );
      _watchProcess(_webProcess!, 'واجهة الويب', (code) => _webExitCode = code);
      await _waitForHttp(webUrl, const Duration(minutes: 3), 'واجهة الويب');

      _ensureNotStopping();
      isRunning = true;
      status = 'النظام يعمل. واجهة الويب متاحة على $webUrl';
      _log(
        'اكتمل التشغيل؛ خدمة الطباعة ${printerController.isReady ? 'جاهزة' : 'غير جاهزة'}.',
      );
      await _openBrowser();
    } catch (error) {
      await _stopProcesses();
      await printerController.stop();
      isRunning = false;
      status = _stopping
          ? 'تم إيقاف التشغيل.'
          : 'تعذر التشغيل: ${_redact(error.toString())}';
      if (!_stopping) _log(status);
    } finally {
      isBusy = false;
      _notify();
    }
  }

  Future<void> stop() async {
    _stopping = true;
    status = 'جارٍ إيقاف النظام المحلي...';
    _notify();
    await _stopProcesses();
    await printerController.stop();
    isRunning = false;
    isBusy = false;
    status = 'تم إيقاف واجهة الويب وخادم API وخدمة الطباعة.';
    _notify();
  }

  Future<void> openInBrowser() => _openBrowser();

  Future<void> _validateWorkspace(Directory root) async {
    if (workspacePath.trim().isEmpty || !await root.exists()) {
      throw StateError('اختر مجلد Codes_System موجوداً على هذا الجهاز.');
    }
    final requiredFiles = [
      'pnpm-workspace.yaml',
      'node_modules/.modules.yaml',
      'artifacts/api-server/package.json',
      'artifacts/accounting/package.json',
      'artifacts/accounting/flutter_app/pubspec.yaml',
    ];
    for (final relativePath in requiredFiles) {
      if (!await File('${root.path}/$relativePath').exists()) {
        throw StateError(
          'المجلد المحدد ليس نسخة Codes_System جاهزة. '
          'يفقد الملف: $relativePath. شغّل pnpm install أولاً لتثبيت التبعيات.',
        );
      }
    }
  }

  Future<Map<String, String>> _loadEnvironment(Directory root) async {
    final envFile = File('${root.path}/.env');
    final fileEnvironment = await envFile.exists()
        ? parseDotEnv(await envFile.readAsString())
        : <String, String>{};
    return {...Platform.environment, ...fileEnvironment};
  }

  static Map<String, String> parseDotEnv(String contents) {
    final values = <String, String>{};
    final assignment = RegExp(
      r'^\s*(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*?)\s*$',
    );
    for (final line in const LineSplitter().convert(contents)) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final match = assignment.firstMatch(line);
      if (match == null) continue;
      var value = match.group(2) ?? '';
      if (value.length >= 2 &&
          ((value.startsWith('"') && value.endsWith('"')) ||
              (value.startsWith("'") && value.endsWith("'")))) {
        value = value.substring(1, value.length - 1);
      } else {
        final commentIndex = value.indexOf(RegExp(r'\s+#'));
        if (commentIndex >= 0) value = value.substring(0, commentIndex).trim();
      }
      values[match.group(1)!] = value;
    }
    return values;
  }

  Future<void> _checkTool(
    String executable,
    List<String> args,
    String workingDirectory,
  ) async {
    try {
      final result = await Process.run(
        executable,
        args,
        workingDirectory: workingDirectory,
        runInShell: Platform.isWindows,
      ).timeout(const Duration(seconds: 12));
      if (result.exitCode != 0) throw StateError('exit ${result.exitCode}');
    } catch (_) {
      throw StateError(
        'تعذر العثور على $executable. ثبّته وأعد فتح الرفيق من الطرفية '
        'إذا كان مسار Node.js غير متاح للتطبيقات المكتبية.',
      );
    }
  }

  Future<void> _ensurePortsAvailable() async {
    for (final port in [_apiPort, _webPort]) {
      Socket? socket;
      try {
        socket = await Socket.connect(
          InternetAddress.loopbackIPv4,
          port,
          timeout: const Duration(milliseconds: 450),
        );
        throw StateError(
          'المنفذ $port مستخدم بالفعل. أوقف جلسة الويب المحلية الأخرى ثم أعد المحاولة.',
        );
      } on SocketException {
        // No listener is using this port.
      } finally {
        socket?.destroy();
      }
    }
  }

  Future<void> _runBuild(
    String root,
    List<String> args,
    Map<String, String> environment,
    String label,
  ) async {
    _ensureNotStopping();
    status = '$label...';
    _notify();
    _log('بدء $label');
    final process = await Process.start(
      'pnpm',
      args,
      workingDirectory: root,
      environment: environment,
      runInShell: Platform.isWindows,
    );
    _buildProcess = process;
    final stdoutDone = _capture(process.stdout, label);
    final stderrDone = _capture(process.stderr, label);
    final code = await process.exitCode;
    await Future.wait([stdoutDone, stderrDone]);
    _buildProcess = null;
    _ensureNotStopping();
    if (code != 0) {
      throw StateError('$label فشل برمز خروج $code. راجع السجل في الأسفل.');
    }
    _log('اكتمل $label');
  }

  Future<void> _waitForHttp(String url, Duration timeout, String label) async {
    status = 'انتظار جاهزية $label...';
    _notify();
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      _ensureNotStopping();
      if (_apiExitCode != null && label == 'خادم API') {
        throw StateError('توقف خادم API برمز خروج $_apiExitCode.');
      }
      if (_webExitCode != null && label == 'واجهة الويب') {
        throw StateError('توقفت واجهة الويب برمز خروج $_webExitCode.');
      }
      if (await _respondsWithSuccess(url)) return;
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    throw StateError('انتهت مهلة انتظار $label على $url.');
  }

  Future<bool> _respondsWithSuccess(String url) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 1);
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close().timeout(
        const Duration(seconds: 2),
      );
      await response.drain<void>();
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
    }
  }

  void _watchProcess(
    Process process,
    String label,
    void Function(int) saveExitCode,
  ) {
    unawaited(_capture(process.stdout, label));
    unawaited(_capture(process.stderr, label));
    unawaited(
      process.exitCode.then((code) {
        saveExitCode(code);
        if (!_stopping && !_disposed) {
          status = '$label توقف بشكل غير متوقع (رمز $code).';
          _log(status);
          _notify();
        }
      }),
    );
  }

  Future<void> _capture(Stream<List<int>> stream, String source) async {
    await for (final line
        in stream
            .transform(const Utf8Decoder(allowMalformed: true))
            .transform(const LineSplitter())) {
      _log('$source: $line');
    }
  }

  Future<void> _openBrowser() async {
    try {
      if (Platform.isMacOS) {
        await Process.run('open', [webUrl]).timeout(const Duration(seconds: 8));
      } else if (Platform.isWindows) {
        await Process.run('cmd.exe', [
          '/c',
          'start',
          '',
          webUrl,
        ]).timeout(const Duration(seconds: 8));
      } else {
        await Process.run('xdg-open', [
          webUrl,
        ]).timeout(const Duration(seconds: 8));
      }
    } catch (_) {
      _log('تعذر فتح المتصفح تلقائياً؛ افتح $webUrl يدوياً.');
    }
  }

  Future<void> _stopProcesses() async {
    final build = _buildProcess;
    _buildProcess = null;
    if (build != null) {
      build.kill();
      await build.exitCode.timeout(
        const Duration(seconds: 4),
        onTimeout: () => -1,
      );
    }
    final processes = [_webProcess, _apiProcess].whereType<Process>().toList();
    _webProcess = null;
    _apiProcess = null;
    for (final process in processes) {
      process.kill();
    }
    for (final process in processes) {
      await process.exitCode.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          process.kill();
          return -1;
        },
      );
    }
    _apiExitCode = null;
    _webExitCode = null;
  }

  String _createSessionSecret() {
    final random = Random.secure();
    return List.generate(
      32,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  String _redact(String value) {
    var result = value;
    for (final secret in _redactValues) {
      result = result.replaceAll(secret, '[محجوب]');
    }
    return result;
  }

  void _ensureNotStopping() {
    if (_stopping) throw StateError('تم إيقاف التشغيل.');
  }

  void _log(String value) {
    _logs.add(_redact(value));
    if (_logs.length > 120) _logs.removeRange(0, _logs.length - 120);
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(stop());
    super.dispose();
  }
}

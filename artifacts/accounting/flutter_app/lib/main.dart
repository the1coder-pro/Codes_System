import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'shell.dart';
import 'theme.dart';

void main() {
  runApp(const AccountingApp());
}

class AccountingApp extends StatelessWidget {
  const AccountingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return fluent.FluentApp(
      title: 'المحاسبة المالية العامة',
      debugShowCheckedModeBanner: false,
      theme: buildFluentTheme(),
      locale: const Locale('ar'),
      builder: (context, child) => ScaffoldMessenger(
        child: Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
      home: const AppShell(),
    );
  }
}

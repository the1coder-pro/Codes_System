import 'auth_service.dart';

class LocalAuthService implements AccountingAuthService {
  Future<void> initialize() async {
    throw UnsupportedError(
      'Local authentication is only available on desktop.',
    );
  }

  @override
  Future<bool> authorize(UserSession session, String permission) async => false;

  @override
  Future<UserSession> login(String username, String password) async =>
      throw UnsupportedError(
        'Local authentication is only available on desktop.',
      );
}

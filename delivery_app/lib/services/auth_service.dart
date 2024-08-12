/*import 'package:your_app/utils/secure_storage.dart';
import 'package:your_app/services/api_service.dart';

class AuthService {
  static Future<bool> login(String username, String password) async {
    try {
      final token = await ApiService.login(username, password);
      await SecureStorage.writeToken(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    await SecureStorage.deleteToken();
  }
}*/
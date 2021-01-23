import 'package:agricultores_app/services/authService.dart';
import 'package:agricultores_app/services/helloWorldService.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TokenType { access, refresh }

class Token {
  static Future<String> getToken(TokenType type) async {
    final prefs = await SharedPreferences.getInstance();
    if (type == TokenType.access) {
      var temp = prefs.getString('access');
      return temp.toString();
    } else {
      var temp = prefs.getString('refresh');
      return temp.toString();
    }
  }

  static Future<String> setToken(TokenType type, String token) async {
    final prefs = await SharedPreferences.getInstance();
    if (type == TokenType.access) {
      await prefs.setString('access', token);
    } else {
      await prefs.setString('refresh', token);
    }
  }

  static void logout() {
    setToken(TokenType.access, '');
    setToken(TokenType.refresh, '');
  }

  static generateOrRefreshToken(phoneNumber, password) async {
    try {
      final refreshToken = await Token.getToken(TokenType.refresh);
      final tokenGenerator = await AuthenticateService.refresh(refreshToken);

      await Token.setToken(TokenType.access, tokenGenerator.access);
      await Token.setToken(TokenType.refresh, tokenGenerator.refresh);

      final hw = await HelloWorldService.getHelloWorld();
      print(hw.toString());
    } catch (e) {
      print(e.toString());
      final tokenGenerator =
          await AuthenticateService.authenticate(phoneNumber, password);
      await Token.setToken(TokenType.access, tokenGenerator.access);
      await Token.setToken(TokenType.refresh, tokenGenerator.refresh);

      final access = await Token.getToken(TokenType.access);
      final refresh = await Token.getToken(TokenType.refresh);

      print(access);
      print(refresh);

      final hw = await HelloWorldService.getHelloWorld();
      print(hw.toString());
    }
  }
}

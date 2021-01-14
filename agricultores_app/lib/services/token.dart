import 'package:shared_preferences/shared_preferences.dart';

enum TokenType { access, refresh }

class Token {
  static Future<String> getToken(TokenType type) async {
    final prefs = await SharedPreferences.getInstance();
    if (type == TokenType.access) {
      var temp = prefs.getString('access');
      return temp.toString();
    } else if (type == TokenType.refresh) {
      var temp = prefs.getString('refresh');
      return temp.toString();
    }
  }

  static Future<String> setToken(TokenType type, String token) async {
    final prefs = await SharedPreferences.getInstance();
    if (type == TokenType.access) {
      await prefs.setString('access', token);
    } else if (type == TokenType.refresh) {
      await prefs.setString('refresh', token);
    }
  }
}

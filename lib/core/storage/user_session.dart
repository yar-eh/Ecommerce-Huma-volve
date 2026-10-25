import 'package:shared_preferences/shared_preferences.dart';

/// Remembers which user is logged in, so the cart, wishlist, orders and
/// profile are saved separately for each user.
class UserSession {
  UserSession._();

  static const String _key = 'current_user_email';

  static String normalize(String email) => email.trim().toLowerCase();

  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> setCurrentUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, normalize(email));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// "cart_items" becomes "cart_items_bob@mail.com" for the logged in user.
  /// Without a logged in user the plain key is used (data saved before users
  /// were separated).
  static Future<String> scopedKey(String baseKey) async {
    final user = await getCurrentUser();
    return user == null ? baseKey : '${baseKey}_$user';
  }
}

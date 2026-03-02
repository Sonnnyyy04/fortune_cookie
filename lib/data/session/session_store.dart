import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  static const _kUserId = 'current_user_id';

  Future<int?> getUserId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_kUserId);
  }

  Future<void> setUserId(int userId) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kUserId, userId);
  }

  Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kUserId);
  }
}
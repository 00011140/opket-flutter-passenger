import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  Future<void> savePhone(int phone) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('phone', phone);
  }

  Future<int?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getInt('phone');
    return phone;
  }

  Future<bool> isPhoneShared() async {
    final phone = await getPhone();

    return phone != null;
  }

  Future<void> deletePhone() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = await prefs.remove('phone');
  }
}

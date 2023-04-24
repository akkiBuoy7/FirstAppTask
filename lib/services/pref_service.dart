import 'package:first_app/model/user_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utility/project_util.dart';

class PrefService {
  Future saveUser(User user) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool(ProjectUtil.PREF_REMEBER_ME, user.isRemember!);
    _preferences.setString(ProjectUtil.PREF_USER_NAME, user.name!);
    _preferences.setString(ProjectUtil.PREF_PASSWORD, user.password!);
  }

  Future<User> getUser() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var isRemember = _preferences.getBool(ProjectUtil.PREF_REMEBER_ME);
    var name = _preferences.getString(ProjectUtil.PREF_USER_NAME);
    var password = _preferences.getString(ProjectUtil.PREF_PASSWORD);
    return User(name, password,isRemember);
  }

  Future clearUser() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove(ProjectUtil.PREF_REMEBER_ME);
    _preferences.remove(ProjectUtil.PREF_USER_NAME);
    _preferences.remove(ProjectUtil.PREF_PASSWORD);
  }
}

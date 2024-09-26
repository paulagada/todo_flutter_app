import 'package:shared_preferences/shared_preferences.dart';

mixin AppStorage {
  final Future<SharedPreferences> prefs =  SharedPreferences.getInstance();



  Future<String?> getStorageItem(String key) async {
    var pref = await prefs;
    return pref.getString(key);
  }

  storeItems (String key, String token) async {
    var pref = await prefs;
    await pref.setString(key, token);
  }

  Future<String?> getToken() async {
    var pref = await prefs;
    return pref.getString("token");
  }

  Future<void> removeStorageItem(String key) async {
    var pref = await prefs;
     pref.remove(key);
  }

}

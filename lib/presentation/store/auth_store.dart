import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/data/models/credentials_model.dart';
import 'package:tawasool/data/models/notifications_model.dart';
import 'package:tawasool/data/models/setting_model.dart';
import 'package:tawasool/data/repository/auth_repo.dart';

class AuthStore {
  //} extends StatesRebuilder {
  final authRepo = AuthRepo();
  bool get isAuth => credentials != null;
  CredentialModel credentials;
  CredentialModel tempCredentials;
  UserNotificationModel notifications;
  SharedPreferences pref;

  SettingModel settingModel;
  AuthStore() {
    SharedPreferences.getInstance().then((p) {
      pref = p;
      if (p.getString('credentials') == null) {
        print('Is not Authenticated!');
        // isAuth = false;
      } else {
        credentials = CredentialModel();
        credentials.data =
            Credentials.fromJson(json.decode(p.getString('credentials')));
        print('Is Authenticated! with ${credentials.data.toJson()}');
        // isAuth = true;
      }
    });
  }
  Future<SettingModel> getSettings() async {
    settingModel = await authRepo.getSettings();
    if (settingModel != null) return settingModel;
    throw 'حدث خطأ';
  }

  Future<CredentialModel> login(Credentials loginInfo) async {
    print(loginInfo.login());
    credentials = await authRepo.login(loginInfo.login());
    if (credentials != null) {
      credentials.data..password = loginInfo.password;
      // ..confirmPassword = loginInfo.password;
      pref.setString('credentials', json.encode(credentials.data));
      // isAuth = true;
      return credentials;
    } else
      throw Exception('تأكد من صحة البيانات');
  }

  Future<CredentialModel> register(
      Credentials loginInfo, String imagePath) async {
    print(loginInfo.register());
    tempCredentials = await authRepo.register(loginInfo.register(), imagePath);
    if (tempCredentials != null) {
      tempCredentials.data
        ..password = loginInfo.password
        ..confirmPassword = loginInfo.confirmPassword;

      // isAuth = true;

      return tempCredentials;
    } else
      throw Exception('تأكد من صحة البيانات');
  }

  Future verify(String code) async {
    if (await authRepo.verify(code) != null) {
      credentials = tempCredentials;
      pref.setString('credentials', json.encode(credentials.data));
      return true;
    } else
      return false;
  }

  Future<CredentialModel> editProfile(
      Credentials profileInfo, String imagePath) async {
    print(profileInfo.register());
    // credentials = null;
    credentials = await authRepo.editProfile(profileInfo.register(), imagePath);
    if (credentials != null) {
      credentials.data.password = profileInfo.password;
      pref.setString('credentials', json.encode(credentials.data));
      // isAuth = true;

      return credentials;
    } else {
      credentials = CredentialModel();
      credentials.data =
          Credentials.fromJson(json.decode(pref.getString('credentials')));
      throw Exception('تأكد من صحة البيانات');
    }
  }

  Future contactUs(String name, String msg) async {
    final temp = await authRepo.contactUs(name, msg);
    if (temp != null)
      return true;
    else
      return false;
  }

  Future deleteNotification(int id) async {
    final temp = await authRepo.deleteNotification(id);
    if (temp != null)
      return true;
    else
      return false;
  }

  Future<UserNotificationModel> getNotification() async {
    notifications = await authRepo.getNotifications();
    if (notifications != null) return notifications;
    throw 'تعذر إظهار الإشعارات';
  }
}

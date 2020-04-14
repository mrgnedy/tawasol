import 'package:tawasool/core/api_utils.dart';
import 'package:tawasool/data/models/credentials_model.dart';
import 'package:tawasool/data/models/notifications_model.dart';
import 'package:tawasool/data/models/setting_model.dart';
import 'package:tawasool/domain/repos/auth_repo_inter.dart';

class AuthRepo {
  Future<SettingModel> getSettings() async {
    String url = APIs.settingEP;
    return SettingModel.fromJson(await APIs.getRequest(url));
  }

  Future<CredentialModel> login(Map<String, dynamic> loginInfo) async {
    String url = APIs.loginEP;
    return CredentialModel.fromJson(await APIs.postRequest(
      url,
      loginInfo,
    ));
  }

  Future<CredentialModel> register(
      Map<String, dynamic> registerInfo, String imagePath) async {
    String url = APIs.registerEP;
    return CredentialModel.fromJson(await APIs.postWithFile(
        url, (registerInfo as Map<String, String>), imagePath));
  }

  Future<CredentialModel> editProfile(
      Map<String, dynamic> profileInfo, String imagePath) async {
    String url = APIs.editUserEP;
    return CredentialModel.fromJson(await APIs.postWithFile(
        url, (profileInfo as Map<String, String>), imagePath));
  }

  Future verify(String code) async {
    String url = APIs.activcodeuserEP;
    Map<String, dynamic> body = {'code': '$code'};
    return await APIs.postRequest(url, body);
  }

  Future contactUs(String name, String msg) async {
    String url = APIs.contactUsEP;
    Map<String, dynamic> body = {'name': '$name', 'message': '$msg'};
    return await APIs.postRequest(url, body);
  }

  Future<UserNotificationModel> getNotifications() async {
    final String url = APIs.getAuthNotificationEP;
    return UserNotificationModel.fromJson(await APIs.getRequest(url));
  }

  Future deleteNotification(int id) async {
    final String url = APIs.destroyNotfyEP;
    Map<String, dynamic> body = {'id': id.toString()};
    return await APIs.postRequest(url, body);
  }
}

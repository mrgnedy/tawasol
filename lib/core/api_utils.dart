import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';
import 'package:tawasool/presentation/store/auth_store.dart';

class APIs {
  static String baseUrl = 'http://tawasol.site/api/';
  static String imageBaseUrl = 'http://tawasol.site/public/pictures/';
  static String token;
//AIzaSyDyZS1lXwrSQfLucsqjh2_XrTlm-ZkHjNU
  static final String registerEP = '${baseUrl}register';
  static final String loginEP = '${baseUrl}login';
  static final String editUserEP = '${baseUrl}editUser';
  static final String activcodeuserEP = '${baseUrl}activcodeuser';
  static final String searchEP = '${baseUrl}search';
  static final String getOccasionsEP = '${baseUrl}getOccasions';
  static final String sendCommentEP = '${baseUrl}sendComment';
  static final String getCommentsEP = '${baseUrl}getComments';
  static final String headDecisionEP = '${baseUrl}headDecision';
  static final String getAllSectionEP = '${baseUrl}getAllSection';
  static final String saveOccasionsEP = '${baseUrl}saveOccasions';
  static final String destroyNotfyEP = '${baseUrl}destroyNotfy';
  static final String ocidEP = '${baseUrl}ocid';
  static final String updateOccasionsEP = '${baseUrl}updateOccasions';
  static final String deleteOccasionsEP = '${baseUrl}deleteOccasions';
  static final String getAuthOccasionsEP = '${baseUrl}getAuthOccasions';
  static final String getPublicOcassionsEP = '${baseUrl}getPublicOcassions';
  static final String getAuthNotificationEP = '${baseUrl}getAuthNotification';
  static final String getPrivtOcassionsSectionEP =
      '${baseUrl}getPrivtOcassionsSection';
  static final String getPrivtOcassionsOfficerEP =
      '${baseUrl}getPrivtOcassionsOfficer';
  static final String getRejectedOcassionsEP = '${baseUrl}getRejectedOcassions';
  static final String profileUserEP = '${baseUrl}profileUser';
  static final String profileAdminEP = '${baseUrl}profileAdmin';
  static final String settingEP = '${baseUrl}setting';
  static final String contactUsEP = '${baseUrl}contactUS';

  static Future getRequest(url,
      {String token = '', BuildContext context}) async {
    final reactiveModel = Injector.getAsReactive<AuthStore>();
    String _token;
    if (reactiveModel.state.credentials != null)
      _token = reactiveModel.state.credentials.data.apiToken;
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $_token'});
      return checkResponse(response);
    } on SocketException catch (e) {
      print(e);
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      print(e);
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      print(e);
      throw 'Bad response';
    } catch (e) {
      print(e);
      throw '$e';
    }
  }

  static Future postRequest(String url, Map<String, dynamic> body,
      {BuildContext context}) async {
    final reactiveModel = Injector.getAsReactive<AuthStore>();
    String _token = reactiveModel.state.tempCredentials?.data?.apiToken;
    if(_token == null)
     _token = reactiveModel.state.credentials?.data?.apiToken;
    print('Posting request');
    print(body);

    try {
      final response = await http
          .post(url, body: body, headers: {'Authorization': 'Bearer $_token'});
      return checkResponse(response);
    } on SocketException catch (e) {
      print(e);
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      print(e);
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      print(e);
      throw 'Bad response';
    } catch (e) {
      print(e);
      throw '$e';
    }
  }

  static postWithFile(
      String urlString, Map<String, String> body, String filePath,
      {List additionalData, String additionalDataField}) async {
    final reactiveModel = Injector.getAsReactive<AuthStore>();
    String _token = reactiveModel.state.credentials?.data?.apiToken;
    Uri url = Uri.parse(urlString);
    // String image = savedOccasion['image'];
    // Map<String, String> body = (savedOccasion); //.toJson();
    Map<String, String> header = {'Authorization': 'Bearer $_token'};
    http.MultipartRequest request = http.MultipartRequest('post', url);
    request.fields.addAll(body);
    if (filePath != null)
      request.files.add(await http.MultipartFile.fromPath('image', filePath));
    if (additionalData != null && additionalData.isNotEmpty)
      for (int i = 0; i < additionalData.length; i++) {
        request.fields['$additionalDataField[$i]'] =
            additionalData[i].toString();
      }
    request.headers.addAll(header);
    print(body);
    try {
      final response = await request.send();
      final responseData =
          json.decode(utf8.decode(await response.stream.first));

      print('Response from post with image $responseData}');
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        // final responseData = (json.decode(utf8.decode(onData)));

        print(responseData);
        if (responseData['msg'].toString().toLowerCase() == 'success') {
          print(responseData);
          return (responseData);
        } else {
          if (responseData['msg'].toString().contains('unauth'))
            throw 'من فضلك تأكد من تسجيل الدخول';
          else
            throw responseData['data'];
        }
      } else
        throw 'تعذر الإتصال';

      // return SaveOccasionModel.fromJson(
      //     APIs.checkResponse(json.decode(utf8.decode(onData))));

    } on SocketException catch (e) {
      print(e);
      throw 'تحقق من اتصالك بالانترنت';
    } on HttpException catch (e) {
      print(e);
      throw 'تعذر الاتصال بالخادم';
    } on FormatException catch (e) {
      print(e);
      throw 'Bad response';
    } catch (e) {
      print(e);
      throw '$e';
    }
  }

  static checkResponse(http.Response response) {
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      final responseData = json.decode(response.body);

      print(responseData);
      if (responseData['msg'].toString().toLowerCase() == 'success' || responseData['msg'].toString().toLowerCase() =='deleted' )
        return responseData;
      else {
        if (responseData['msg'].toString().contains('unauth'))
          throw 'من فضلك تأكد من تسجيل الدخول';
        else
          throw responseData['data'];
      }
    } else
      throw 'تعذر الإتصال';
  }
}

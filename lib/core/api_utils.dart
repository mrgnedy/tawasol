import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/utils.dart';

class APIs {
  static String baseUrl = 'http://tawasol.site/api/';
  static String imageBaseUrl =
      'http://zabayehalshamal.com/public/dash/assets/img/';
  static String token;

  static final String registerEP = '${baseUrl}register';
  static final String loginEP = '${baseUrl}login';
  static final String activcodeuserEP = '${baseUrl}activcodeuser';
  static final String getOccasionsEP = '${baseUrl}getOccasions';
  static final String getAllSectionEP = '${baseUrl}getAllSection';
  static final String saveOccasionsEP = '${baseUrl}saveOccasions';
  static final String updateOccasionsEP = '${baseUrl}updateOccasions';
  static final String deleteOccasionsEP = '${baseUrl}deleteOccasions';
  static final String getAuthOccasionsEP = '${baseUrl}getAuthOccasions';
  static final String getPublicOcassionsEP = '${baseUrl}getPublicOcassions';
  static final String getPrivtOcassionsSectionEP =
      '${baseUrl}getPrivtOcassionsSection';
  static final String getPrivtOcassionsOfficerEP =
      '${baseUrl}getPrivtOcassionsOfficer';
  static final String getRejectedOcassionsEP = '${baseUrl}getRejectedOcassions';
  static final String profileUserEP = '${baseUrl}profileUser';
  static final String profileAdminEP = '${baseUrl}profileAdmin';
  static final String settingEP = '${baseUrl}setting';
  static final String contactUsEP = '${baseUrl}contactUS';
  static final String headDecisionEP = '${baseUrl}headDecision';

  static Future getRequest(url,
      {String token = '', BuildContext context}) async {
    // final reactiveModel = Injector.getAsReactive<AuthStore>();
    String _token;
    // if(reactiveModel.state.logInModel!=null)_token=reactiveModel.state.logInModel.apiToken;
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer _token'});
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
    // final reactiveModel = Injector.getAsReactive<AuthStore>();
    String _token; // = reactiveModel.state.logInModel?.apiToken;
    print('Posting request');
    try {
      final response = await http
          .post(url, body: body, headers: {'Authorization': 'Bearer '});
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

  static checkResponse(http.Response response) {
    print(response);
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      final responseData = json.decode(response.body);

      print(responseData);
      if (responseData['msg'].toString().toLowerCase() == 'success')
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

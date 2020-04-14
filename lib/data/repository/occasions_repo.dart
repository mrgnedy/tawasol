import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/core/api_utils.dart';
import 'package:tawasool/data/models/all_occasions_model.dart';
import 'package:tawasool/data/models/all_sections_model.dart';
import 'package:tawasool/data/models/occasion_mode.dart';
import 'package:tawasool/data/models/sav_occasion_model.dart';
import 'package:tawasool/data/models/search_users_model.dart';
import 'package:http/http.dart' as http;
import 'package:tawasool/presentation/store/auth_store.dart';

class OccasionsRepo {
  Future<AllOccasionsModel> getAllOccasions() async {
    String url = APIs.getOccasionsEP;
    return AllOccasionsModel.fromJson(await APIs.getRequest(url));
  }

  Future<AllSectionsModel> getAllSections() async {
    String url = APIs.getAllSectionEP;
    return AllSectionsModel.fromJson(await APIs.getRequest(url));
  }

  Future<SearchUsersModel> searchUsers(String name) async {
    String url = APIs.searchEP;
    Map<String, dynamic> body = {'name': '$name'};
    return SearchUsersModel.fromJson(await APIs.postRequest(url, body));
  }

  Future<SaveOccasionModel> saveOccasion(
      Map<String, String> savedOccasion, String image,
      [List invitedUsers]) async {
    String token =
        Injector.getAsReactive<AuthStore>().state.credentials.data.apiToken;
    // 'ntR5sNUo5lCVwD9qHcRdRnLuCkexapHtLtkXAh7zoIziXu0MmrZmzpNJZReR';
    Uri url = Uri.parse(APIs.saveOccasionsEP);
    // String image = savedOccasion['image'];
    Map<String, String> body = (savedOccasion); //.toJson();
    Map<String, String> header = {'Authorization': 'Bearer $token'};
    http.MultipartRequest request = http.MultipartRequest('post', url);
    request.fields.addAll(body);
    request.files.add(await http.MultipartFile.fromPath('image', image));
    if (invitedUsers != null && invitedUsers.isNotEmpty)
      for (int i = 0; i < invitedUsers.length; i++) {
        request.fields['invitationUser_ids[$i]'] = invitedUsers[i].toString();
      }
    request.headers.addAll(header);
    print(body);
    try {
      final response = await request.send();
      final responseData =
          json.decode(utf8.decode(await response.stream.first));

      print('gfdfghjk $responseData}');
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        // final responseData = (json.decode(utf8.decode(onData)));

        print(responseData);
        if (responseData['msg'].toString().toLowerCase() == 'success') {
          final ss = SaveOccasionModel.fromJson(responseData);
          print(ss.msg);
          return SaveOccasionModel.fromJson(responseData);
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
      throw 'mmmm $e';
    }
  }

  Future sendComment(String content, id, int userID) async {
    String url = APIs.sendCommentEP;
    Map<String, dynamic> body = {
      'content': '$content',
      'id': '$id',
      // 'user_id': '$userID',
      'is_comment': '1'
    };
    return await APIs.postRequest(url, body);
  }

  Future mngrDecision(int isPublic, id, int userID, int decision) async {
    String url = APIs.headDecisionEP;
    Map<String, dynamic> body = {
      'is_public': '${decision == 1 ? isPublic : 3}',
      'id': '$id',
      'user_id': '$userID',
      'is_accepted': '$decision'
    };
    return await APIs.postRequest(url, body);
  }

  Future deleteOccasion(int id) async {
    String url = APIs.deleteOccasionsEP;
    Map<String, dynamic> body = {'id': '$id'};
    return await APIs.postRequest(url, body);
  }

  Future<SaveOccasionModel> editOccasion() {
    String url = APIs.updateOccasionsEP;
  }

  Future getOccasionByID(int id) async {
    print('sssssssssssssssssssss');
    String url = APIs.ocidEP;
    Map<String, dynamic> body = {'id': '$id'};
    return await APIs.postRequest(url, body);
  }

  Future getAllComments(int id)async{
    print('Getting comments...');
    String url = APIs.getCommentsEP;
    Map<String, dynamic> body = {'id' : '$id'};
    return await APIs.postRequest(url, body);
  }
}

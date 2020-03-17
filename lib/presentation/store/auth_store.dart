import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:tawasool/data/models/credentials_model.dart';
import 'package:tawasool/data/repository/auth_repo.dart';

class AuthStore{//} extends StatesRebuilder {
  final authRepo = AuthRepo();
  CredentialModel credentials = CredentialModel();
  SharedPreferences pref;
  AuthStore(){
    SharedPreferences.getInstance().then((p){
      pref = p;
    });
  }

  Future<CredentialModel> login(Credentials loginInfo)async{
    print(loginInfo.login());
    credentials = await authRepo.login(loginInfo.login());
    if(credentials != null) 
    {
      pref.setString('credentials', json.encode(credentials.data));
      return credentials;
    }
    else 
      throw Exception('تأكد من صحة البيانات');
  }
  Future<CredentialModel> register(Credentials loginInfo)async{
    print(loginInfo.register());
    credentials = await authRepo.register(loginInfo.register());
    if(credentials != null) 
    {
      pref.setString('credentials', json.encode(credentials.data));
      return credentials;
    }
    else 
      throw Exception('تأكد من صحة البيانات');
  }
}
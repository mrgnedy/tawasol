import 'package:tawasool/core/api_utils.dart';
import 'package:tawasool/data/models/credentials_model.dart';
import 'package:tawasool/domain/repos/auth_repo_inter.dart';

class AuthRepo {

  Future<CredentialModel> login(Map<String, dynamic> loginInfo)
  async{
    String url = APIs.loginEP;
    return CredentialModel.fromJson( await APIs.postRequest(url, loginInfo,));
  }
  Future<CredentialModel> register(Map<String, dynamic> registerInfo)
  async{
    String url = APIs.registerEP;
    return CredentialModel.fromJson(await APIs.postRequest(url, registerInfo,));
  }
  Future<CredentialModel> verify(Map<String, dynamic> registerInfo)
  async{
    String url = APIs.activcodeuserEP;
    return await APIs.postRequest(url, registerInfo,);
  }
}
import 'package:tawasool/data/models/credentials_model.dart';

abstract class IAuth {
  Future<CredentialModel> login(){}
}
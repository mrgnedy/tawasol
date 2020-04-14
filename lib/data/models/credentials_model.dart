class CredentialModel {
  String msg;
  Credentials data;

  CredentialModel({this.msg, this.data});

  CredentialModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    data = json['data'] != null ? new Credentials.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Credentials {
  String apiToken;
  String codeJob;
  String phone;
  String password;
  String confirmPassword;
  int id;
  String sectionId;
  String name;
  int type;
  int code;
  String deviceToken;
  String image;

  Credentials({
    this.apiToken,
    this.codeJob,
    this.phone,
    this.id,
    this.name,
    this.deviceToken,
    this.password,
    this.type,
    this.code,
    this.confirmPassword,
    this.sectionId,
    this.image
  });

  Credentials.fromJson(Map<String, dynamic> json) {
    apiToken = json['api_token'];
    codeJob = json['code_job'];
    phone = json['phone'];
    id = json['id'];
    name = json['name'];
    deviceToken = json['device_token'];
    type = json['type'];
    sectionId = json['section_id'].toString();
    code = json['code'];
    image = json['image'];
    
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['api_token'] = this.apiToken;
    data['code_job'] = this.codeJob;
    data['phone'] = this.phone;
    data['id'] = this.id;
    data['section_id'] = this.sectionId;
    data['type'] = this.type;
    data['code'] = this.code;
    data['name'] = this.name;
    data['password'] = this.password;
    data['confirmpass'] = this.confirmPassword;
    data['device_token'] = this.deviceToken;
    return data;
  }
  Map<String, dynamic> login() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code_job'] = this.codeJob;
    data['password'] = this.password;
    data['device_token'] = this.deviceToken??'1';
    // data['api_token'] = this.apiToken;
    // data['phone'] = this.phone;
    // data['id'] = this.id;
    // data['name'] = this.name;
    // data['confirmpass'] = this.confirmPassword;
    return data;
  }
  Map<String, String> register() {
    final Map<String, String> data = new Map<String, String>();
    data['code_job'] = this.codeJob;
    data['name'] = this.name;
    data['password'] = this.password;
    data['confirmpass'] = this.confirmPassword;
    data['device_token'] = this.deviceToken?? ' ';
    data['phone'] = this.phone;
    data['section_id'] = this.sectionId.toString()?? '1';
    // data['api_token'] = this.apiToken;
    data['id'] = this.id.toString();
    return data;
  }
}

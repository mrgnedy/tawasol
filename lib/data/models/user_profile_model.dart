class UserProfileModel {
  String msg;
  UserData data;

  UserProfileModel({this.msg, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = new UserData.fromJson(json['data'].first);
      
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = [this.data.toJson()];
    }
    return data;
  }
}

class UserData {
  int id;
  String name;
  String phone;
  String codeJob;
  Null code;
  int isActive;
  String apiToken;
  int sectionId;
  String deviceToken;
  String createdAt;
  String updatedAt;

  UserData(
      {this.id,
      this.name,
      this.phone,
      this.codeJob,
      this.code,
      this.isActive,
      this.apiToken,
      this.sectionId,
      this.deviceToken,
      this.createdAt,
      this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    codeJob = json['code_job'];
    code = json['code'];
    isActive = json['is_active'];
    apiToken = json['api_token'];
    sectionId = json['section_id'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['code_job'] = this.codeJob;
    data['code'] = this.code;
    data['is_active'] = this.isActive;
    data['api_token'] = this.apiToken;
    data['section_id'] = this.sectionId;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

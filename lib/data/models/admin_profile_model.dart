class AdminProfileModel {
  String msg;
  AdminData data;

  AdminProfileModel({this.msg, this.data});

  AdminProfileModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new AdminData.fromJson(json['data']) : null;
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

class AdminData {
  int id;
  String name;
  int isManger;
  String email;
  Null emailVerifiedAt;
  int codeJob;
  int sectionId;
  String deviceToken;
  String createdAt;
  String updatedAt;

  AdminData(
      {this.id,
      this.name,
      this.isManger,
      this.email,
      this.emailVerifiedAt,
      this.codeJob,
      this.sectionId,
      this.deviceToken,
      this.createdAt,
      this.updatedAt});

  AdminData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isManger = json['is_manger'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    codeJob = json['code_job'];
    sectionId = json['section_id'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_manger'] = this.isManger;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['code_job'] = this.codeJob;
    data['section_id'] = this.sectionId;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

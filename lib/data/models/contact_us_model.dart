class ContactUsModel {
  String msg;
  ContactUsData data;

  ContactUsModel({this.msg, this.data});

  ContactUsModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new ContactUsData.fromJson(json['data']) : null;
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

class ContactUsData {
  String name;
  String message;
  int userId;

  ContactUsData({this.name, this.message, this.userId});

  ContactUsData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    message = json['message'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    return data;
  }
}

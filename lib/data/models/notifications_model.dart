class UserNotificationModel {
  String msg;
  Data data;

  UserNotificationModel({this.msg, this.data});

  UserNotificationModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<Notification> notification;

  Data({this.notification});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['notification'] != null) {
      notification = new List<Notification>();
      json['notification'].forEach((v) {
        notification.add(new Notification.fromJson(v));
      });
      notification = notification.reversed.toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification {
  int id;
  String content;
  int userId;
  int sectionId;
  int occasionId;
  String createdAt;
  String updatedAt;

  Notification(
      {this.id,
      this.content,
      this.userId,
      this.sectionId,
      this.createdAt,
      this.occasionId,
      this.updatedAt});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    occasionId = json['occasion_id'];
    content = json['content'];
    userId = json['user_id'];
    sectionId = json['section_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['occasion_id'] = this.occasionId;
    data['content'] = this.content;
    data['user_id'] = this.userId;
    data['section_id'] = this.sectionId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

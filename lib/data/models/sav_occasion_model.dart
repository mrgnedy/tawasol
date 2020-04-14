class SaveOccasionModel {
  String msg;
  Data data;

  SaveOccasionModel({this.msg, this.data});

  SaveOccasionModel.fromJson(Map<String, dynamic> json) {
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
  Occasions occasions;
  Notification notification;
  Notification1 notification1;

  Data({this.occasions, this.notification, this.notification1});

  Data.fromJson(Map<String, dynamic> json) {
    occasions = json['occasions'] != null
        ? new Occasions.fromJson(json['occasions'])
        : null;
    notification = json['notification'] != null
        ? new Notification.fromJson(json['notification'])
        : null;
    notification1 = json['notification1'] != null
        ? new Notification1.fromJson(json['notification1'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.occasions != null) {
      data['occasions'] = this.occasions.toJson();
    }
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    if (this.notification1 != null) {
      data['notification1'] = this.notification1.toJson();
    }
    return data;
  }
}

class Occasions {
  String nameOccasion;
  String nameOwner;
  String date;
  String time;
  String address;
  String isPublic;
  String checkManger;
  String isAccepted;
  String lng;
  String lat;
  String userId;
  String sectionId;
  String updatedAt;
  String createdAt;
  int id;

  Occasions(
      {this.nameOccasion,
      this.nameOwner,
      this.date,
      this.time,
      this.address,
      this.isPublic,
      this.checkManger,
      this.isAccepted,
      this.lng,
      this.lat,
      this.userId,
      this.sectionId,
      this.updatedAt,
      this.createdAt,
      this.id});

  Occasions.fromJson(Map<String, dynamic> json) {
    nameOccasion = json['name_occasion'];
    nameOwner = json['name_owner'];
    date = json['date'];
    time = json['time'];
    address = json['address'];
    isPublic = json['is_public'];
    checkManger = json['check_manger'];
    isAccepted = json['is_accepted'];
    lng = json['lng'];
    lat = json['lat'];
    userId = json['user_id'];
    sectionId = json['section_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name_occasion'] = this.nameOccasion;
    data['name_owner'] = this.nameOwner;
    data['date'] = this.date;
    data['time'] = this.time;
    data['address'] = this.address;
    data['is_public'] = this.isPublic;
    data['check_manger'] = this.checkManger;
    data['is_accepted'] = this.isAccepted;
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    data['user_id'] = this.userId;
    data['section_id'] = this.sectionId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

class Notification {
  String userId;
  String content;
  String sectionId;
  String updatedAt;
  String createdAt;
  int id;

  Notification(
      {this.userId,
      this.content,
      this.sectionId,
      this.updatedAt,
      this.createdAt,
      this.id});

  Notification.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'].toString();
    content = json['content'];
    sectionId = json['section_id'].toString();
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['section_id'] = this.sectionId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

class Notification1 {
  String userId;
  String content;
  String sectionId;
  String updatedAt;
  String createdAt;
  int id;

  Notification1(
      {this.userId,
      this.content,
      this.sectionId,
      this.updatedAt,
      this.createdAt,
      this.id});

  Notification1.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'].toString();
    content = json['content'];
    sectionId = json['section_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['section_id'] = this.sectionId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

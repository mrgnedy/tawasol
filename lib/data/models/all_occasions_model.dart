class AllOccasionsModel {
  String msg;
  List<Occasion> data;

  AllOccasionsModel({this.msg, this.data});

  AllOccasionsModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Occasion>();
      json['data'].forEach((v) {
        data.add(new Occasion.fromJson(v));
      });
      data = data.reversed.toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Occasion {
  String nameOccasion;
  String nameOwner;
  String date;
  String time;
  num lng;
  num lat;
  num isPublic;
  num isAccepted;
  int id;
  num sectionId;
  String address;
  num userId;
  String image;

  Occasion(
      {this.nameOccasion,
      this.nameOwner,
      this.date,
      this.time,
      this.lng,
      this.lat,
      this.isPublic,
      this.sectionId,
      this.userId,
      this.isAccepted,
      this.id,
      this.address,
      this.image});

  Occasion.fromJson(Map<String, dynamic> json) {
    nameOccasion = json['name_occasion'];
    nameOwner = json['name_owner'];
    address = json['address'];
    date = json['date'];
    time = json['time'];
    lng = json['lng'];
    lat = json['lat'];
    id = json['id'];
    isPublic = json['is_public'];
    isAccepted = json['is_accepted'];
    sectionId = json['section_id'];
    userId = json['user_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name_occasion'] = this.nameOccasion;
    data['name_owner'] = this.nameOwner;
    data['date'] = this.date;
    data['time'] = this.time;
    data['address'] = this.address;
    data['lng'] = this.lng;
    data['id'] = this.id;
    data['lat'] = this.lat;
    data['is_accepted'] = this.isAccepted;
    data['is_public'] = this.isPublic;
    data['section_id'] = this.sectionId;
    data['user_id'] = this.userId;
    data['image'] = this.image;
    return data;
  }
}

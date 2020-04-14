import 'package:tawasool/data/models/all_occasions_model.dart';

class OccasionModel {
  String msg;
  Occasion data;

  OccasionModel({this.msg, this.data});

  OccasionModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Occasion.fromJson(json['data']) : null;
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

// class Data {
//   int id;
//   String nameOccasion;
//   String nameOwner;
//   String date;
//   String time;
//   String address;
//   double lng;
//   double lat;
//   Null image;
//   int isPublic;
//   int isAccepted;
//   int checkManger;
//   int sectionId;
//   int userId;
//   String createdAt;
//   String updatedAt;

//   Data(
//       {this.id,
//       this.nameOccasion,
//       this.nameOwner,
//       this.date,
//       this.time,
//       this.address,
//       this.lng,
//       this.lat,
//       this.image,
//       this.isPublic,
//       this.isAccepted,
//       this.checkManger,
//       this.sectionId,
//       this.userId,
//       this.createdAt,
//       this.updatedAt});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     nameOccasion = json['name_occasion'];
//     nameOwner = json['name_owner'];
//     date = json['date'];
//     time = json['time'];
//     address = json['address'];
//     lng = json['lng'];
//     lat = json['lat'];
//     image = json['image'];
//     isPublic = json['is_public'];
//     isAccepted = json['is_accepted'];
//     checkManger = json['check_manger'];
//     sectionId = json['section_id'];
//     userId = json['user_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name_occasion'] = this.nameOccasion;
//     data['name_owner'] = this.nameOwner;
//     data['date'] = this.date;
//     data['time'] = this.time;
//     data['address'] = this.address;
//     data['lng'] = this.lng;
//     data['lat'] = this.lat;
//     data['image'] = this.image;
//     data['is_public'] = this.isPublic;
//     data['is_accepted'] = this.isAccepted;
//     data['check_manger'] = this.checkManger;
//     data['section_id'] = this.sectionId;
//     data['user_id'] = this.userId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

class AllCommentsModel {
  String msg;
  List<Comment> data;

  AllCommentsModel({this.msg, this.data});

  AllCommentsModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Comment>();
      json['data'].forEach((v) {
        data.add(new Comment.fromJson(v));
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

class Comment {
  int id;
  String content;
  int userId;
  String username;
  String userimage;
  int sectionId;
  int occasionId;
  int isComment;
  String createdAt;
  String updatedAt;

  Comment(
      {this.id,
      this.content,
      this.userId,
      this.username,
      this.userimage,
      this.sectionId,
      this.occasionId,
      this.isComment,
      this.createdAt,
      this.updatedAt});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    userId = json['user_id'];
    username = json['username'];
    userimage = json['userimage'];
    sectionId = json['section_id'];
    occasionId = json['occasion_id'];
    isComment = json['is_comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['userimage'] = this.userimage;
    data['section_id'] = this.sectionId;
    data['occasion_id'] = this.occasionId;
    data['is_comment'] = this.isComment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

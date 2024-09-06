class CommentModel {
  String? username;
  String? comment;
  final datePublished;
  List? likes;
  String? profilePhoto;
  String? uid;
  String? id;

  CommentModel(
      {this.username,
      this.comment,
      this.datePublished,
      this.likes,
      this.profilePhoto,
      this.uid,
      this.id});


  Map<String, dynamic> toJson() => {
    "username": username,
    "comment": comment,
    "date_published": datePublished,
    "likes": likes,
    "profile_picture": profilePhoto,
    "uid":uid,
    "id":id

  };

  CommentModel fromJson(Map<String, dynamic> map) {
    return CommentModel(
        username: map["username"] as String,
        comment: map["comment"] as String,
        datePublished: map["date_published"],
        likes: map["likes"],
        profilePhoto: map["profile_picture"] as String,
        uid: map["uid"] as String,
        id: map["id"] as String

    );
  }
}

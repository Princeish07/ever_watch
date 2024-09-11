import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? name;
  String? email;
  String? phone;
  String? profilePicture;
  List? followers;
  List? following;
  List? receivedRequests;
  List? sentRequests;
  String? uid;

  UserModel(
      {this.name,
      this.email,
      this.phone,
      this.profilePicture,
      this.followers,
      this.following,
        this.sentRequests,
        this.receivedRequests,
      this.uid});

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "profile_picture": profilePicture,
        "followers": followers,
        "following": following,
    "sentRequests":sentRequests,
    "receivedRequests":receivedRequests,
        "docId": uid
      };

  UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map["name"] as String,
        email: map["email"] as String,
        phone: map["phone"] as String,
        profilePicture: map["profile_picture"] as String,
        followers: map["followers"] ?? []  ,
        following: map["following"] ?? [] ,
        sentRequests: map["sentRequests"] ?? [],
        receivedRequests: map["receivedRequests"] ?? [],
        uid: map["docId"] as String);
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? name;
  String? email;
  String? phone;
  String? profilePicture;
  String? uid;

  UserModel({this.name, this.email, this.phone, this.profilePicture, this.uid});

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "profile_picture": profilePicture,
        "docId": uid
      };

  UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map["name"] as String,
        email: map["email"] as String,
        phone: map["phone"] as String,
        profilePicture: map["profile_picture"] as String,
        uid: map["docId"] as String
    );
  }
}

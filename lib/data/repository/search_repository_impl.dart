import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/domain/repository/search_repository.dart';
import 'dart:async';
import 'dart:core';
class SearchRepositoryImpl extends SearchRepository{
  Stream<Resource<List<UserModel>>>? searchUserList({String? userName}) {
    try {
    return  FirebaseFirestore.instance.collection("users").where('name',isGreaterThanOrEqualTo: userName).snapshots().map((snapshot){
      List<UserModel> userList = snapshot.docs.map((doc){
         return UserModel().fromMap(doc.data() as Map<String,dynamic>);
       }).toList();
      return Resource.success(data: userList);
     });

    } catch (e) {
      print("Error"+e.toString());
      return Stream.value(Resource.failure(error: e.toString()));
    }


  }
}
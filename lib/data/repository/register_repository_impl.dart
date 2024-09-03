import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/domain/repository/register_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterRepositoryImpl extends RegisterRepository{

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Future<Resource<UserModel>> createUser({String? email,String? phone,String? name, String? password,String? profilePicture}) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      // FirebaseFirestore firestore = FirebaseFirestore.instance;
      // firestore.
      if(credential.user?.uid!.isNotEmpty==true) {
        Resource<UserModel> userData = await addUser(email: email,
            phone: phone,
            name: name,
            uid: credential.user?.uid,
            profilePicture: profilePicture);

        if (userData.status == Status.SUCCESS) {
          return Resource.success(data: UserModel(name: name,
              email: email,
              phone: phone,
              profilePicture: profilePicture));
        }else{
          return Resource.failure(error: userData.error.toString());
        }
      }else{
        return Resource.failure(error: 'Unable to register');
      }



    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return Resource.failure(error: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return Resource.failure(error: "The account already exists for that email.");

      }
      return Resource.failure(error: e.message);

    } catch (e) {
      return Resource.failure(error: e.toString());

    }
  }

  Future<Resource<UserModel>> addUser({String? email,String? phone,String? name, String? uid,String? profilePicture}) {
    // Call the user's CollectionReference to add a new user


    return  users.doc(uid).set(
      {
        'name':name,
        'phone':phone,
        'email':email,
        'docId':uid,
        'profile_picture':profilePicture
      }
    )
        .then((value){
          return Resource.success(data: UserModel(name: name,email: email,phone: phone,profilePicture: profilePicture,uid: uid));
    })
        .catchError((error) {
          return Resource.failure(error: error.toString());
    });
  }



}
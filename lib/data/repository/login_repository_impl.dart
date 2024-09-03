import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/domain/repository/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepositoryImpl extends LoginRepository{

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Future<Resource<UserModel>> loginUser({String? email, String? password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email ?? "",
          password: password ?? ""
      );

      return await getUserDetails(uid: credential.user?.uid);
      return Resource.success(data: UserModel(email: credential.user?.email,phone: "",profilePicture: "",name: ""));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        return Resource.failure(error: "No user found for that email");

      }
      else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        return Resource.failure(error: "Wrong password provided for that user.");

      }
      return Resource.failure(error: e.message);

    }
  }


  @override
  Future<Resource<UserModel>> getUserDetails({String? uid}) async {
    try {
      DocumentSnapshot documentSnapshot =  await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .get();
      Resource<UserModel>  userData = Resource.success(data: UserModel().fromMap(documentSnapshot.data() as Map<String,dynamic>));
   return userData;

    } catch (e) {
      return Resource.failure(error: e.toString());
    }

  }

}
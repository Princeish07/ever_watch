import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/domain/repository/register_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterRepositoryImpl extends RegisterRepository{
  @override
  Future<Resource<UserModel>> createUser({String? email,String? phone,String? name, String? password,String? profilePicture}) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      return Resource.success(data: UserModel(name: name,email: email,phone: phone,profilePicture: profilePicture));

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



}
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/other/resource.dart';
import '../../data/model/user_model.dart';

abstract class RegisterRepository{
  Future<Resource<UserModel>> createUser({String? email,String? phone,String? name, String? password,String? profilePicture});

}
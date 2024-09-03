import '../../core/other/resource.dart';
import '../../data/model/user_model.dart';

abstract class LoginRepository{
  Future<Resource<UserModel>> loginUser({String? email,String? password});

  Future<Resource<UserModel>> getUserDetails({String? uid});

}
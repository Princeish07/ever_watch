
import 'package:ever_watch/core/other/general_utils.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/data/repository/login_repository_impl.dart';
import 'package:ever_watch/presentation/ui/login/state/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/repository/login_repository.dart';

class LoginProvider extends StateNotifier<LoginState>{
  LoginRepository? loginRepository;
  LoginProvider({this.loginRepository}) : super(LoginState(isAuthenticated: false, isLoading: false));

  login({String? email, String? password}) async {
    if(email==null || email.isEmpty ){

      showToast("Please enter email");
      // state = LoginState(isAuthenticated: false,isLoading: false,errorMessage: "Please enter ");

    }
    else if(password == null || password.isEmpty){
      showToast("Please enter password");

      // state = LoginState(isAuthenticated: false,isLoading: false);

    }else if(password.length<8){
      showToast("Password length should be greater than 8");

      // state = LoginState(isAuthenticated: false,isLoading: false);


    }else {
      state = LoginState(isAuthenticated: false, isLoading: true);

      Resource<UserModel>? userModel = await loginRepository?.loginUser(email: email,password: password);
      print(userModel.toString());
      userModel;
      if(userModel?.status==Status.SUCCESS) {
        state = LoginState(isAuthenticated: true, isLoading: false);
      }else{
        state = LoginState(isAuthenticated: false, isLoading: false,errorMessage: userModel?.error);

      }

    }
  }

}

final loginProvider = StateNotifierProvider<LoginProvider, LoginState>((ref)
{
  return LoginProvider(loginRepository: LoginRepositoryImpl());
}
);
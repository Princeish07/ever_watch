
import 'package:ever_watch/core/other/general_utils.dart';
import 'package:ever_watch/presentation/ui/login/state/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginProvider extends StateNotifier<LoginState>{
  LoginProvider() : super(LoginState(isAuthenticated: false, isLoading: false));

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

      await Future.delayed(const Duration(seconds: 4));

      state = LoginState(isAuthenticated: true, isLoading: false);

    }
  }

}

final loginProvider = StateNotifierProvider<LoginProvider, LoginState>((ref)
{
  return LoginProvider();
}
);
class LoginState {
  bool? isAuthenticated;
  bool? isLoading;
  String? errorMessage="";

  LoginState({this.isAuthenticated,this.isLoading,this.errorMessage=""});

}
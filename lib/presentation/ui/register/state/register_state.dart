import 'dart:io';

class RegisterState {
  bool? isAuthenticated;
  String? profilePicture;
  File? imageFile;
  bool? isLoading;
  String? errorMessage="";

  RegisterState({this.isAuthenticated,this.isLoading,this.errorMessage="",this.profilePicture,this.imageFile});


  RegisterState copyWith({bool? isAuthenticated, String? profilePicture, File? imageFile,bool? isLoading,String? errorMessage}){
    return RegisterState(isAuthenticated: isAuthenticated ?? this.isAuthenticated,profilePicture: profilePicture ??  this.profilePicture,errorMessage: errorMessage ?? this.errorMessage,imageFile: imageFile ?? this.imageFile );
}
}
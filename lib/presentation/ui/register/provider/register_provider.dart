

import 'dart:io';

import 'package:ever_watch/core/service_locator/service_locator.dart';
import 'package:ever_watch/domain/repository/register_repository.dart';
import 'package:ever_watch/presentation/ui/login/state/login_state.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../../core/other/general_utils.dart';
import '../../../../core/other/resource.dart';
import '../../../../data/repository/register_repository_impl.dart';
import '../state/register_state.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;

class RegisterProvider extends StateNotifier<RegisterState>{
  RegisterRepository? registerRepository;
  RegisterProvider({this.registerRepository}) : super(RegisterState(isAuthenticated: false, isLoading: false,errorMessage: "",profilePicture: "",imageFile: null));

  registerNow(
      {String? email,
      String? name,
      String? phone,
      String? password,
      String? confirmPassword}) async {
    if (name == null || name.isEmpty) {
      showToast("Please enter name");
      // state = LoginState(isAuthenticated: false,isLoading: false,errorMessage: "Please enter ");

    }
    else if (email == null || email.isEmpty) {
      showToast("Please enter email");
      // state = LoginState(isAuthenticated: false,isLoading: false,errorMessage: "Please enter ");

    }

   else  if (phone == null || phone.isEmpty) {
      showToast("Please enter phone");
      // state = LoginState(isAuthenticated: false,isLoading: false,errorMessage: "Please enter ");

    }
    else if (password == null || password.isEmpty) {
      showToast("Please enter password");

      // state = LoginState(isAuthenticated: false,isLoading: false);

    } else if (password.length < 8) {
      showToast("Password length should be greater than 8");

      // state = LoginState(isAuthenticated: false,isLoading: false);


    }

    else if (confirmPassword == null || confirmPassword.isEmpty) {
      showToast("Please enter confirm password");

      // state = LoginState(isAuthenticated: false,isLoading: false);

    } else if (password!=confirmPassword) {
      showToast("Password doesn't matched");

      // state = LoginState(isAuthenticated: false,isLoading: false);


    }
    else if(_photo==null){
      showToast("Please upload profile image");

    }
    else {
      state = RegisterState(isAuthenticated: false, isLoading: true);
      await _uploadImage();

      var data = await registerRepository?.createUser(email: email,phone: phone,name: name,profilePicture: state.profilePicture,password: password);


     print(data.toString());
      if(data?.status==Status.SUCCESS) {
        // await Future.delayed(const Duration(seconds: 4));
        state = RegisterState(isAuthenticated: true, isLoading: false);
      }else{
        state = RegisterState(isAuthenticated: false, isLoading: false,errorMessage: data?.error);

      }

    }
  }



  firebaseStorage.FirebaseStorage storage =
      firebaseStorage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future<bool> pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    // setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        state = state.copyWith(imageFile: _photo);

        // _uploadImage();
      } else {
        print('No image selected.');
      }
      return true;
    // });
  }

  Future<bool> pickFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    // setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        state = state.copyWith(imageFile: _photo);
      } else {
        print('No image selected.');
      }

      return true;
    // });
  }


  Future<void> _uploadImage() async {
    if (_photo == null) {

      // state = state.copyWith(errorMessage: "Please select image");
      return;}

    try {
      // Create a unique filename for the image
      String fileName = DateTime.now().toString();
      Reference ref = firebaseStorage.FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = ref.putFile(_photo!);

      // Wait for the upload to complete
      await uploadTask.whenComplete(() async {
        // Get the URL of the uploaded image
        String downloadURL = await ref.getDownloadURL();
        state = state.copyWith(profilePicture: downloadURL);
        print('Image uploaded successfully. Download URL: $downloadURL');

        // You can now store the URL in Firestore or use it as needed
      });
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());

      print('Failed to upload image: $e');
    }
  }
}

final registerProvider = StateNotifierProvider.autoDispose<RegisterProvider, RegisterState>((ref)
{
return RegisterProvider(registerRepository: RegisterRepositoryImpl());
}
);


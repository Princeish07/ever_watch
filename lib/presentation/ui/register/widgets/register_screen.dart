import 'package:ever_watch/core/other/general_utils.dart';
import 'package:ever_watch/presentation/common_widgets/main_button.dart';
import 'package:ever_watch/presentation/common_widgets/text_input_field.dart';
import 'package:ever_watch/presentation/theme/app_assets.dart';
import 'package:ever_watch/presentation/theme/app_strings.dart';
import 'package:ever_watch/presentation/theme/app_style.dart';
import 'package:ever_watch/presentation/ui/register/provider/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/service_locator/service_locator.dart';
import '../../../common_widgets/common_loader.dart';
import '../../../common_widgets/error_message.dart';
import '../../../theme/app_colors.dart';
import '../../home/widgets/home_screen.dart';

class RegisterScreen extends ConsumerWidget {
  TextEditingController? emailCtrl = TextEditingController();
  TextEditingController? nameCtrl = TextEditingController();
  TextEditingController? phoneNumberCtrl = TextEditingController();

  TextEditingController? passwordCtrl = TextEditingController();
  TextEditingController? confirmPasswordCtrl = TextEditingController();

  // File? image;
  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if(image == null) return;
  //     final imageTemp = File([],image.path);
  //     // setState(() => this.image = imageTemp);
  //   } on PlatformException catch(e) {
  //     print('Failed to pick image: $e');
  //   }
  // }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationState = ref.watch(registerProvider);
    ref.listen(registerProvider, (previous, next) {
      if (next.isAuthenticated == true) {
        showToast("Registered successfully");
        Navigator.pop(context);
      }

      if(next.errorMessage!=null && next.errorMessage?.isNotEmpty==true){
        showToast(next.errorMessage!);
      }
    });
    return Scaffold(
      body: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(40),
            child:
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppString.registerText,
                    style: AppStyles()
                        .mainHeadingStyle(AppColors().mainButtonColor!),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      // adding some properties
                      showModalBottomSheet(
                        context: context,
                        // color is applied to main screen when modal bottom screen is displayed
                        //background color for modal bottom screen
                        backgroundColor: Colors.white,
                        //elevates modal bottom screen
                        elevation: 10,
                        // gives rounded corner to modal bottom screen
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        builder: (BuildContext context) {
                          // UDE : SizedBox instead of Container for whitespaces
                          return Container(
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (await ref
                                        .read(registerProvider.notifier)
                                        .pickFromCamera()) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.camera_alt),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "Take photo",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (await ref
                                        .read(registerProvider.notifier)
                                        .pickFromGallery()) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.image),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text("Pick a image",
                                            style: TextStyle(fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.cancel),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text("Cancel",
                                            style: TextStyle(fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(48), // Image radius
                            child: registrationState.imageFile != null
                                ? Image.file(
                              registrationState.imageFile!,
                              fit: BoxFit.fill,
                            )
                                : Image.asset(AppAssets.menImage),
                          ),
                        ),
                        // CircleAvatar(
                        //   radius: 48, // Image radius
                        //   backgroundImage: registrationState.profilePicture != null
                        //       ? NetworkImage(registrationState.profilePicture!,)  // Display uploaded image
                        //       : AssetImage(AppAssets.menImage) as ImageProvider,  // Default image
                        // ),
                        Positioned(
                          top: 1,
                          right: 1,
                          child: Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInputField(
                    hintText: AppString.enterName,
                    textEditingController: nameCtrl,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInputField(
                    hintText: AppString.enterEmailHint,
                    textEditingController: emailCtrl,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInputField(
                    hintText: AppString.enterPhone,
                    textEditingController: phoneNumberCtrl,
                    prefixIcon: const Icon(Icons.phone),
                    isNumber: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInputField(
                    hintText: AppString.enterPassword,
                    textEditingController: passwordCtrl,
                    prefixIcon: const Icon(Icons.enhanced_encryption),
                    isObsecureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInputField(
                    hintText: AppString.enterConfirmPassword,
                    textEditingController: confirmPasswordCtrl,
                    prefixIcon: const Icon(Icons.enhanced_encryption),
                    isObsecureText: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MainButton(
                    buttonText: AppString.registerText,
                    onPressed: () async {
                      print("email--->  " + emailCtrl!.text);
                      print("password--->  " + passwordCtrl!.text);
                      print("name--->  " + nameCtrl!.text);
                      print("phone--->  " + phoneNumberCtrl!.text);
                      print("confirmPassword--->  " + confirmPasswordCtrl!.text);

                      await ref.read(registerProvider.notifier).registerNow(
                          email: emailCtrl!.text,
                          name: nameCtrl!.text,
                          phone: phoneNumberCtrl!.text,
                          password: passwordCtrl!.text,
                          confirmPassword: confirmPasswordCtrl!.text);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w500),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
          if (registrationState.isLoading == true) ...[
            CommonLoader()
          ],
          // if (registrationState.errorMessage != null &&
          //     registrationState.errorMessage!.isNotEmpty) ...[
          //   ErrorMessage(
          //     errorMessage: registrationState.errorMessage,
          //   )
          // ],
        ]),
    );
  }
}

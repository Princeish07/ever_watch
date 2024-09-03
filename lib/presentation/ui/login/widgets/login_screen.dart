
import 'dart:ui';

import 'package:ever_watch/core/other/general_utils.dart';
import 'package:ever_watch/presentation/common_widgets/common_loader.dart';
import 'package:ever_watch/presentation/common_widgets/error_message.dart';
import 'package:ever_watch/presentation/common_widgets/main_button.dart';
import 'package:ever_watch/presentation/common_widgets/text_input_field.dart';
import 'package:ever_watch/presentation/theme/app_strings.dart';
import 'package:ever_watch/presentation/theme/app_style.dart';
import 'package:ever_watch/presentation/ui/home/widgets/home_screen.dart';
import 'package:ever_watch/presentation/ui/register/widgets/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_colors.dart';
import '../provider/login_provider.dart';
class LoginScreen extends ConsumerWidget {
  TextEditingController? emailCtrl = TextEditingController();
  TextEditingController? passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    ref.listen(loginProvider, (previous, next) {
      if(next.isAuthenticated==true){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }else{
        if(loginState.errorMessage==null || next.errorMessage?.isNotEmpty==true){
          showToast(next.errorMessage ?? "");
        }
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Spacer(),
              
                   Text(AppString.loginText,style: AppStyles().mainHeadingStyle(AppColors().mainButtonColor!),),
                  const SizedBox(height: 40,),
              
                  TextInputField(hintText: AppString.enterEmailHint,textEditingController: emailCtrl,prefixIcon: const Icon(Icons.email),),
                  const SizedBox(height: 20,),
              
                  TextInputField(hintText: AppString.enterPassword,textEditingController: passwordCtrl,prefixIcon: const Icon(Icons.enhanced_encryption),isObsecureText: true,),
                  const SizedBox(height: 30,),
            
                  MainButton(buttonText: "Login",onPressed: () async {
                    print("email--->  "+emailCtrl!.text);
                    print("password--->  "+passwordCtrl!.text);
                    await ref.read(loginProvider.notifier).login(email: emailCtrl!.text,password: passwordCtrl!.text);
            
                  },),
                  const SizedBox(height: 20,),
            
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
            
                      },child: const Text("Sign up",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),))
            
                    ],
                  )
            
                  // const Spacer(),
              
              
                ],
              ),
            ),
            if(loginState.isLoading==true) ...[
              CommonLoader()
            ],
            // if(loginState.errorMessage==null || loginState.errorMessage!.isNotEmpty) ...[
            //   ErrorMessage(errorMessage: loginState.errorMessage,)
            // ]
          ],
        ),
      ),
    );
  }
}

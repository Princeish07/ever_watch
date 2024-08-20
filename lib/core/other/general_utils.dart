import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../presentation/theme/app_colors.dart';

//Method to capitalize the String
String capitalize(String input) {
  return input.isEmpty
      ? input
      : (input[0].toUpperCase() + input.substring(1));
}

//Method to check email validation
bool isValidEmail(String email) {
  return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

//Method to check if Pincode is valid or not
bool isPincodeValid(String pincode) {
  return RegExp(r'^[1-9][0-9]{5}$').hasMatch(pincode);
}

//Method to check if url is valid or not
bool isValidURL(String url) {
  // Regular expression pattern for a URL
  final RegExp urlPattern = RegExp(
    r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?' // Protocol (optional)
    r'[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\/)?', // Domain name (required)
  );
  return urlPattern.hasMatch(url);
}

//Method to showToast
void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.mainBgColor,
      textColor: AppColors.mainButtonColor,
      fontSize: 16.0
  );
}

keyboardHide(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

String milliSecondNow() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}

String removeHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(exp, '');
}

bool greaterThan(int a, int b) => a > b;
bool lessThan(int a, int b) => a > b;

bool greaterThanOrEqual(int a, int b) => a >= b;
bool equalTo(int a, int b) => a == b;


bool checkOperator({String? operator, int? a, int? b}){
  if(operator==">"){
    return greaterThan(a!, b!);
  }else if(operator=="<"){
    return lessThan(a!, b!);
  }else {
    return equalTo(a!, b!);
  }
}

String platformString(){

  if (defaultTargetPlatform == TargetPlatform.android) {
    return "Android";
  }
  else if(defaultTargetPlatform == TargetPlatform.iOS){
    return "iOS";

  }
  else{
    return "Web";
  }


}
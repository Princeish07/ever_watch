import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'app_colors.dart';
import 'app_dimen.dart';
import 'app_fonts.dart';

class AppStyles {
  TextStyle mainHeadingStyle(Color color) {
    return TextStyle(fontSize: 18, color: color, fontFamily: AppFonts.fontBold);
  }

  TextStyle mainTitleStyle(Color color) {
    return TextStyle(fontSize: 20, color: color, fontFamily: AppFonts.fontBold);
  }

  TextStyle placeHolderStyle(Color color) {
    return TextStyle(fontSize: 16, color: color, fontFamily: AppFonts.fontSemibold);
  }

  TextStyle descriptionStyle(Color color) {
    return TextStyle(fontSize: 14, color: color, fontFamily: AppFonts.fontRegular);
  }
  TextStyle smallDescBoldStyle(Color color) {
    return TextStyle(fontSize: 14, color: color, fontFamily: AppFonts.fontBold);
  }
  TextStyle smallDescSemiBoldStyle(Color color) {
    return TextStyle(fontSize: 14, color: color, fontFamily: AppFonts.fontSemibold);
  }

  TextStyle smallDescStyle(Color color) {
    return TextStyle(fontSize: 14, color: color, fontFamily: AppFonts.fontRegular);
  }

  TextStyle smallSemiBoldStyle(Color color) {
    return TextStyle(fontSize: 12, color: color, fontFamily: AppFonts.fontBold);
  }
  // TextStyle largeHeadingStyle(Color color) {
  //   return TextStyle(fontSize: 40, color: color, fontWeight: FontWeight.bold);
  // }
  //
  // TextStyle largeSubHeadingStyle(Color color) {
  //   return TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold);
  // }
  //
  // TextStyle regularFontStyle(Color color) {
  //   return TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold);
  // }
  //
  // TextStyle greySmallFontStyle(Color color) {
  //   return TextStyle(fontSize: 12, color: color);
  // }
  //
  // TextStyle greyRegularFontStyle(Color color) {
  //   return TextStyle(fontSize: 16, color: color);
  // }

  ButtonStyle mainButtonStyle() {
    return  ButtonStyle(
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimen.buttonCornerRadius),
            )
        ),
        backgroundColor:
        const MaterialStatePropertyAll<Color>(AppColors.mainButtonColor),
        textStyle: const MaterialStatePropertyAll<TextStyle>(TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: AppFonts.fontSemibold)),
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.white));
  }
  ButtonStyle mainLargeButtonStyle() {
    return  ButtonStyle(
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimen.buttonCornerRadius),
            )
        ),
        backgroundColor:
        const MaterialStatePropertyAll<Color>(AppColors.mainButtonColor),
        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(15)),
        textStyle: const MaterialStatePropertyAll<TextStyle>(TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: AppFonts.fontSemibold)),
        foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white));
  }
}
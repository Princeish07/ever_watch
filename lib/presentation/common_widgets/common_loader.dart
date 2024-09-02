import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
class CommonLoader extends StatefulWidget {
  const CommonLoader({super.key});

  @override
  State<CommonLoader> createState() => _CommonLoaderState();
}

class _CommonLoaderState extends State<CommonLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.5),
        child:  Center(child: CircularProgressIndicator(
          color: AppColors().mainButtonColor,
        )));
  }
}

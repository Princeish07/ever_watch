import 'package:flutter/material.dart';
class IconWithBottomText extends StatelessWidget {
  Icon? icon;
  String? value;
  void Function()? onTap;

   IconWithBottomText({super.key,this.icon,this.value,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onTap,
            child:
            icon!,
          ),
          Text(value!,style: TextStyle(color: Colors.white),)
        ],
      ),

    );
  }
}

import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';
class MainButton extends StatefulWidget {
  String? buttonText;
   void Function()? onPressed;
   MainButton({super.key,required this.buttonText, required this.onPressed});

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width-60,
        child: ElevatedButton(onPressed: widget.onPressed, child:  Text(widget.buttonText ?? "",),style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppColors().mainButtonColor!),foregroundColor:  MaterialStatePropertyAll<Color>(Colors.white))));
  }
}

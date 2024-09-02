import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  String? hintText;
  TextEditingController? textEditingController;
  Icon? prefixIcon = null;
  bool? isObsecureText = false;
  bool? isNumber = false;
  TextInputField({super.key,
    this.hintText,
    required this.textEditingController,
    this.prefixIcon,this.isObsecureText,this.isNumber});

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      obscureText: widget.isObsecureText ?? false,keyboardType: widget.isNumber==true ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
          labelText: widget.hintText,
          enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(5),borderSide: const BorderSide(color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)),
          prefixIcon: widget.prefixIcon),
    );
  }
}

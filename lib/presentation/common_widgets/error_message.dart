import 'package:flutter/material.dart';
class ErrorMessage extends StatelessWidget {
  String? errorMessage;
   ErrorMessage({super.key,this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: MediaQuery.of(context).size.height,
      child:  Center(
        child: Text(errorMessage!),
      ),
    );
  }
}

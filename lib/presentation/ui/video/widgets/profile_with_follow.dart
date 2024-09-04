import 'package:flutter/material.dart';


class ProfileWithFollow extends StatelessWidget {
  String? imageUrl;
   ProfileWithFollow({super.key,this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          children: [

            Positioned(left: 5,
                child: Container(width: 50, height: 50,padding: EdgeInsets.all(1),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(25)),
                child:    ClipRRect(
                  borderRadius: BorderRadius.circular(40),

                  child: Image.asset(imageUrl!,fit: BoxFit.cover,),

                ),)),
            Positioned.fill(top: 28,child: Icon(Icons.add_circle,color: Colors.red,fill: 1,)),


          ],
        ),
      );
  }
}

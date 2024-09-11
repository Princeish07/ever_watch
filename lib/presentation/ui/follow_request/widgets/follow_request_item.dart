import 'package:flutter/material.dart';
class FollowRequestItem extends StatefulWidget {
  const FollowRequestItem({super.key});

  @override
  State<FollowRequestItem> createState() => _FollowRequestItemState();
}

class _FollowRequestItemState extends State<FollowRequestItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(uid: state.searchedUserResult!.data![index].uid,)));
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              child: Image.asset(
                'assets/logo/men_image.jpg',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(45),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "state.searchedUserResult!.data![index].name!.toString()",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "state.searchedUserResult!.data![index].email!.toString()",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

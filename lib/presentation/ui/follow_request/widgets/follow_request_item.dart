import 'package:ever_watch/presentation/ui/follow_request/provider/follow_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/model/video_model.dart';

class FollowRequestItem extends ConsumerStatefulWidget {
 final UserModel userModel;

  FollowRequestItem({super.key,required this.userModel});

  @override
  ConsumerState<FollowRequestItem> createState() => _FollowRequestItemState();
}

class _FollowRequestItemState extends ConsumerState<FollowRequestItem> {

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(uid: state.searchedUserResult!.data![index].uid,)));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Image.asset(
                'assets/logo/men_image.jpg',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
             Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                widget.userModel.name.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
                 Text(
                  widget.userModel.email.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            )),

            Row(
              children: [
                IconButton(onPressed: (){
                  ref.read(followRequestProvider.notifier).rejectFollowRequest(followersId: widget.userModel.uid);

                },style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)), icon: const Icon(Icons.cancel,color: Colors.white,),),
                const SizedBox(width: 5,),
                IconButton(onPressed: (){
                  ref.read(followRequestProvider.notifier).acceptFollowRequest(followersId: widget.userModel.uid);
                },style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)), icon: const Icon(Icons.check_circle,color: Colors.white,),),
              ],
            )
          ],
        ),
      ),
    );
  }
}

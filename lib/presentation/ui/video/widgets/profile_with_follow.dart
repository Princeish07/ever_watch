import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ever_watch/presentation/ui/video/provider/video_provider.dart';

class ProfileWithFollow extends ConsumerWidget {
  String? imageUrl;
  String? createdBy;
  List? sentFollowRequestList;
  List? followingRequest;

  ProfileWithFollow({super.key, this.imageUrl, this.createdBy,this.sentFollowRequestList,this.followingRequest});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Stack(
        children: [
          Positioned(
              left: 5,
              child: Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          if (createdBy?.toString() !=
              FirebaseAuth.instance.currentUser?.uid.toString()) ...[
            if(sentFollowRequestList?.contains(createdBy?.toString())!=true && followingRequest?.contains(createdBy?.toString())!=true ) ...[

                Positioned.fill(
                top: 28,
                child:
                InkWell(
                  onTap: (){
                    ref.read(videoProvider.notifier)?.sendFollowRequest(otherUserId: createdBy!);
                  },
                  child:
                  Icon(
                    Icons.add_circle,
                    color: Colors.red,
                    fill: 1,
                  ),
                )),
    ]
              else if(followingRequest?.contains(createdBy?.toString())==true) ...[
              Positioned.fill(
                  top: 28,
                  child:
                  InkWell(
                    onTap: (){
                      // ref.read(videoProvider.notifier)?.sendFollowRequest(otherUserId: createdBy!);
                    },
                    child:
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      fill: 1,
                    ),
                  )),

            ]

          else ...[
            Positioned.fill(
                top: 28,
                child:
                InkWell(
                  onTap: (){
                    // ref.read(videoProvider.notifier)?.sendFollowRequest(otherUserId: createdBy!);
                  },
                  child:
                  Icon(
                    Icons.access_time_filled_rounded,
                    color: Colors.grey,
                    fill: 1,
                  ),
                )),
          ]

    ]
        ],
      ),
    );
  }
}

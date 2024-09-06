import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:ever_watch/data/model/comment_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/presentation/ui/comment/provider/comment_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentItemView extends ConsumerWidget {
  CommentModel? itemValue;
  String? id;
   CommentItemView({super.key,this.itemValue,this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: Colors.transparent, borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/everwatch-21292.appspot.com/o/uploads%2F2024-08-29%2017%3A49%3A13.985229?alt=media&token=2c369366-8d54-4fcb-b321-40cc55d41f05',
                  fit: BoxFit.cover,
                ),
              )),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemValue!.username!.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[400],
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    itemValue!.comment!.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    timeago.format((itemValue!.datePublished as Timestamp).toDate()),
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: (){
                  ref.read(commentProvider.notifier).likeComment(postId:id,commentId:itemValue?.id);

                },
                child:Icon(
                  itemValue?.likes?.contains(FirebaseAuth.instance.currentUser?.uid?.toString())!=true  ? Icons.favorite_border : Icons.favorite,
                  color: Colors.red[400],
                ) ,
              )
              ,
              Text(
                itemValue!.likes!.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

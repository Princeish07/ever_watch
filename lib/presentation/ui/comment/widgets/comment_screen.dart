import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ever_watch/presentation/ui/comment/provider/comment_provider.dart';
import 'package:ever_watch/presentation/ui/comment/widgets/comment_item_view.dart';
class CommentScreen extends ConsumerStatefulWidget {
  String? id;
   CommentScreen({super.key,this.id});

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState(){
    super.initState();
    commentController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.read(commentProvider);
    return Scaffold(
      body: 
      Expanded(child: Container(
        color: AppColors.mainBgColor,
        padding: EdgeInsets.all(15),

        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(child: ListView.builder(itemCount: 5,itemBuilder: (context,index){
              return CommentItemView();
            })),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: TextField(controller: commentController,
                  decoration: InputDecoration(hintText: "Enter comment",hintStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),

                )),
                IconButton(onPressed: (){
                  ref.watch(commentProvider.notifier).sendComment(id:widget.id.toString(),comment:commentController.text.toString());
                }, icon: Icon(Icons.send))
                
              ],
            )
          ],
        ),
      ))
    );
  }
}

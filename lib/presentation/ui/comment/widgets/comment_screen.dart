import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ever_watch/presentation/ui/comment/provider/comment_provider.dart';
import 'package:ever_watch/presentation/ui/comment/widgets/comment_item_view.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/presentation/common_widgets/common_loader.dart';

class CommentScreen extends ConsumerStatefulWidget {
  String? id;

  CommentScreen({super.key, this.id});

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController(text: "");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(commentProvider.notifier).getCommentList(id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(commentProvider);
    ref.listen(commentProvider, (prev,next){
      if(next.commentList?.status==Status.SUCCESS){
        commentController = TextEditingController(text: "");
      }
    });
    return Scaffold(
        body: Container(
            color: AppColors.mainBgColor,
            padding: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
            Stack(
              children: [
                if(state.commentList?.status==Status.SUCCESS)...[
                  Column(
                    children: [

                      if (state.commentList?.data==null || state.commentList?.data?.isEmpty==true) ...[
                        Expanded(
                            child: Container(
                              color: Colors.transparent,
                            ))
                      ] else ...[
                        Expanded(
                            child: ListView.builder(
                                itemCount: state.commentList?.data?.length,
                                itemBuilder: (context, index) {
                                  return CommentItemView(itemValue: state.commentList?.data?[index],id: widget.id,);
                                }))
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: TextField(
                                controller: commentController,
                                decoration: InputDecoration(
                                    hintText: "Enter comment",
                                    hintStyle: TextStyle(color: Colors.white)),
                                style: TextStyle(color: Colors.white),
                              )),
                          IconButton(
                              onPressed: () {
                                ref.watch(commentProvider.notifier).sendComment(
                                    id: widget.id.toString(),
                                    comment: commentController.text.toString());
                              },
                              icon: Icon(Icons.send))
                        ],
                      )
                    ],
                  ),
                ]
                else ...[
                  CommonLoader()
                ]

              ],
            )
        ));
  }
}

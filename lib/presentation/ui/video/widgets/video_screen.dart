import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:ever_watch/presentation/ui/profile/widgets/profile_screen.dart';
import 'package:ever_watch/presentation/ui/video/widgets/video_player_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'profile_with_follow.dart';
import 'icon_with_bottom_text.dart';
import 'circle_animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/presentation/ui/video/provider/video_provider.dart';
import 'dart:core';
import 'package:ever_watch/presentation/common_widgets/common_loader.dart';
import 'package:ever_watch/core/other/general_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ever_watch/presentation/ui/comment/widgets/comment_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ever_watch/data/model/user_model.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> with AutomaticKeepAliveClientMixin {

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.grey, Colors.white]),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                'assets/logo/men_image.jpg',
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(videoProvider.notifier).getVideoList();
    });
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var state = ref.watch(videoProvider);
    ref.listen(videoProvider, (prev, next) {
      if (next.videoListResult?.status == Status.FAILURE) {
        showToast(next.videoListResult!.error.toString());
      } else if (next.videoListResult?.status == Status.SUCCESS) {
        // showToast("Video fetched Successfully");
      }
    });
    return Scaffold(
        body: Stack(
      children: [
        if (state.videoListResult?.status == Status.SUCCESS) ...[
          PageView.builder(
            itemCount: state.videoListResult?.data?.length ?? 1,
            controller: PageController(initialPage: 0, viewportFraction: 1),
            scrollDirection: Axis.vertical,
            onPageChanged: (value) {
              if (value + 2 == state.videoListResult?.data?.length) {
                ref.read(videoProvider.notifier).getVideoList();
              }
            },
            itemBuilder: (context, index) {
              var itemValue = state.videoListResult?.data;
              // if(state.videoControllerList![index].initialize()==false){
              //   state.videoControllerList![index].initialize();
              // }
              // if (index+1 == (state.videoListResult?.data?.length ?? 0)) {
              //   // Show loader at the last item
              //   return Center(
              //     child: CircularProgressIndicator(),
              //   );
              // } else {
                return Stack(
                  children: [
                    Stack(
                      children: [
                        Expanded(
                          child: VideoPlayerItem(
                            controller: state.videoControllerList![index],
                            videoUrl: itemValue?[index].videoUrl ?? "",
                            onDoubleTap: () {
                              ref
                                  .read(videoProvider.notifier)
                                  ?.likingVideo(id: itemValue?[index].id);
                      },
                            videoModel: itemValue?[index],
                          ),
                        ),
                        if (index+1 == (state.videoListResult?.data?.length ?? 0) && state.hasMore) ...[
                    
                         Positioned.directional(textDirection: TextDirection.ltr, child:  Container(
                           color: Colors.transparent,
                           height: 100,

                           child: Center(
                             child: Column(
                               children: [
                                 Text("Loading more...",style: TextStyle(color: AppColors().mainButtonColor,fontWeight: FontWeight.bold,fontSize: 18),),
                                 CircularProgressIndicator(color: AppColors().mainButtonColor,),
                               ],
                             ),
                           ),),top: 40,start: 20,end: 20,bottom: 20,)
                        ]
                      ],
                    ),
                    Column(
                      // mainAxisSize: MainAxisSize.max,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      itemValue?[index].userName ?? "user name",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      itemValue?[index].caption ?? "caption",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.music_note,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          itemValue?[index].songName ??
                                              "song name",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(top: size.height / 5),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                      uid:
                                                          itemValue?[index].uid,
                                                    )));
                                      },
                                      child: ProfileWithFollow(
                                        imageUrl: "assets/logo/men_image.jpg",
                                        createdBy: itemValue?[index].uid,
                                        sentFollowRequestList: state
                                            .otherProfileDetails
                                            ?.data
                                            ?.sentRequests!,
                                        followingRequest: state
                                            .otherProfileDetails
                                            ?.data
                                            ?.following!,
                                      ),
                                    ),
                                    IconWithBottomText(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: itemValue?[index]
                                                    .likes
                                                    ?.contains(FirebaseAuth
                                                        .instance
                                                        ?.currentUser
                                                        ?.uid) ==
                                                true
                                            ? Colors.red
                                            : Colors.white,
                                        size: 30,
                                      ),
                                      value: itemValue?[index]
                                              .likes
                                              ?.length
                                              .toString() ??
                                          "2",
                                      onTap: () {
                                        ref
                                            .read(videoProvider.notifier)
                                            ?.likingVideo(
                                                id: itemValue?[index].id);
                                      },
                                    ),
                                    IconWithBottomText(
                                      icon: Icon(
                                        Icons.message,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      value: itemValue?[index]
                                              .commentCount
                                              ?.toString() ??
                                          "1",
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentScreen(
                                                      id: itemValue?[index]
                                                          .id
                                                          .toString(),
                                                    )));
                                      },
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final result = await Share.share(
                                            '${itemValue?[index].userName} has shared video ${itemValue?[index].videoUrl} with you');
                                      },
                                      child: IconWithBottomText(
                                          icon: Icon(
                                            Icons.reply,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          value: itemValue?[index]
                                                  .shareCount
                                                  .toString() ??
                                              "3"),
                                    ),
                                    CircleAnimation(
                                      child: buildMusicAlbum('profile photo'),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              // }
            },
          ),
        ] else if (state.videoListResult?.status == Status.LOADING) ...[
          CommonLoader()
        ]
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

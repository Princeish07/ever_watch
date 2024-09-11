import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:ever_watch/core/other/resource.dart';

import 'package:video_compress/video_compress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:ever_watch/presentation/ui/video/widgets/video_player_item.dart';
import 'package:ever_watch/presentation/ui/video/provider/video_provider.dart';
import 'package:ever_watch/presentation/ui/view_video/provider/view_video_provider.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/presentation/ui/video/provider/video_provider.dart';
import 'package:ever_watch/presentation/ui/video/widgets/profile_with_follow.dart';
import 'package:ever_watch/presentation/ui/video/widgets/icon_with_bottom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ever_watch/presentation/ui/comment/widgets/comment_screen.dart';
import 'package:ever_watch/presentation/ui/video/widgets/video_screen.dart';
import 'package:ever_watch/presentation/ui/video/widgets/circle_animation.dart';
import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:ever_watch/presentation/ui/view_video/widgets/view_video_player.dart';

class ViewVideoScreen extends ConsumerStatefulWidget {
  String? videoId;
   ViewVideoScreen({super.key,this.videoId});

  @override
  ConsumerState<ViewVideoScreen> createState() => _ViewVideoScreenState();
}

class _ViewVideoScreenState extends ConsumerState<ViewVideoScreen> {
  // VideoPlayerController? controller;
  @override
  void initState(){
    super.initState();



    ref.read(viewVideoProvider.notifier).getVideoDetails(videoId: widget.videoId);
  }


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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var state = ref.watch(viewVideoProvider);
    // var state1 = ref.watch(videoProvider);
    //
    // ref.listen(viewVideoProvider, (prev,next){
    //   if(next.videoDetailsResult?.status==Status.SUCCESS) {
    //     controller = VideoPlayerController.network((next?.videoDetailsResult?.data?.videoUrl).toString())
    //       ..initialize().then((value) {
    //         controller?.play();
    //         controller?.setVolume(0);
    //       });
    //     controller?.play();
    //   }
    //   state = state.copyWith();
    //
    //
    // });

    return
      Scaffold(
        backgroundColor: AppColors.mainBgColor,
        body:
        Container(margin: EdgeInsets.only(bottom: 20),child: Stack(
          children:
          [
            ViewVideoPlayer(
                videoUrl: state.videoDetailsResult?.data?.videoUrl.toString() ?? "",
                onDoubleTap: () {
                  ref.read(videoProvider.notifier)?.likingVideo(id: state.videoDetailsResult?.data?.id);
                }),
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
                                  state.videoDetailsResult?.data?.userName ?? "user name",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.videoDetailsResult?.data?.caption ?? "caption",
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
                                      state.videoDetailsResult?.data?.songName ??
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
                            ProfileWithFollow(
                                imageUrl: "assets/logo/men_image.jpg"),
                            IconWithBottomText(
                              icon: Icon(
                                Icons.favorite,
                                color: state.videoDetailsResult?.data?.likes?.contains(
                                    FirebaseAuth.instance
                                        ?.currentUser?.uid) ==
                                    true
                                    ? Colors.red
                                    : Colors.white,
                                size: 30,
                              ),
                              value: state.videoDetailsResult?.data?.likes
                                  ?.length
                                  .toString() ??
                                  "2",
                              onTap: () {
                                ref
                                    .read(videoProvider.notifier)?.likingVideo(
                                    id: state.videoDetailsResult?.data?.id);
                              },
                            ),
                            IconWithBottomText(
                              icon: Icon(
                                Icons.message,
                                color: Colors.white,
                                size: 30,
                              ),
                              value: state.videoDetailsResult?.data?.commentCount?.toString() ?? "1",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CommentScreen(id: state.videoDetailsResult?.data?.id.toString(),)));
                              },
                            ),
                            IconWithBottomText(
                                icon: Icon(
                                  Icons.reply,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                value: state.videoDetailsResult?.data?.shareCount
                                    .toString() ?? "3"),
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
        ),),
      );
  }
}

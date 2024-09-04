import 'package:ever_watch/presentation/ui/video/widgets/video_player_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'profile_with_follow.dart';
import 'icon_with_bottom_text.dart';
import 'circle_animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/presentation/ui/video/provider/video_provider.dart';
import 'dart:core';
import 'package:ever_watch/presentation/common_widgets/common_loader.dart';
import 'package:ever_watch/core/other/general_utils.dart';
class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Column(children: [
        Container(
          padding: EdgeInsets.all(11),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.grey, Colors.white]),
            borderRadius: BorderRadius.circular(25),),
          child: ClipRRect(borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              'assets/logo/men_image.jpg', fit: BoxFit.cover,),),)
      ],),
    );
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await ref.read(videoProvider.notifier).getVideoList();
    });

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    var state = ref.watch(videoProvider);
    ref.listen(videoProvider, (prev,next){
      if(next.videoListResult?.status==Status.FAILURE){
        showToast(next.videoListResult!.error.toString());
      }
     else if(next.videoListResult?.status==Status.SUCCESS){
        showToast("Video fetched Successfully");
      }
    });
    return Scaffold(
        body:
        Stack(
          children: [


            PageView.builder(
              itemCount: state.videoListResult!.data!.length!,
                controller: PageController(initialPage: 0, viewportFraction: 1)
                , scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                 var itemValue = state.videoListResult!.data;
                  return Stack(
                    children: [
                      VideoPlayerItem(videoUrl: itemValue![index].videoUrl,),
                      Column(
                        // mainAxisSize: MainAxisSize.max,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 100,),
                          Expanded(child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(child: Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(itemValue![index].userName!, style: TextStyle(fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),),
                                    Text(itemValue![index].caption!, style: TextStyle(
                                        fontSize: 20, color: Colors.white),),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.music_note, color: Colors.white,),
                                        Text(itemValue![index].songName!, style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),),

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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ProfileWithFollow(
                                        imageUrl: "assets/logo/men_image.jpg"),
                                    IconWithBottomText(icon: Icon(
                                      Icons.favorite, color: Colors.white,
                                      size: 30,), value: "2"),
                                    IconWithBottomText(icon: Icon(
                                      Icons.message, color: Colors.white,
                                      size: 30,), value: "1"),
                                    IconWithBottomText(icon: Icon(
                                      Icons.reply, color: Colors.white, size: 30,),
                                        value: "0"),
                                    CircleAnimation(
                                      child: buildMusicAlbum('profile photo'),)
                                  ],
                                ),
                              )
                            ],
                          ),),

                        ],
                      ),


                    ],

                  );
                }),

            if(state.videoListResult?.status==Status.LOADING) ...[
              CommonLoader()
            ]
          ],
        )
    );
  }

}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:ever_watch/presentation/ui/login/widgets/login_screen.dart';
import 'package:ever_watch/presentation/ui/profile/provider/profile_provider.dart';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/presentation/common_widgets/common_loader.dart';
import 'package:ever_watch/core/other/general_utils.dart';
import 'package:ever_watch/presentation/ui/view_video/widgets/view_video_screen.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_platform_interface/vibration_platform_interface.dart';

class UserVideoList extends ConsumerStatefulWidget {
  const UserVideoList({super.key});

  @override
  ConsumerState<UserVideoList> createState() => _UserVideoListState();
}

class _UserVideoListState extends ConsumerState<UserVideoList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(profileProvider.notifier).setLongPressed(isLongPressed: true);
    });

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: -1.0,
      upperBound: 1.0,
    );

    // Add a listener to reverse the controller to create the vibration effect
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.reverse();
      } else if (_controller.isDismissed) {
        _controller.forward();
      }
    });
  }

  void startVibrationEffect() {
    _controller.forward();
  }

  void stopVibrationEffect() {
    _controller.stop();
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();

  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(profileProvider);
    ref.listen(profileProvider, (prev, next) {
      if (next.videoList?.status == Status.FAILURE) {
        showToast(next.videoList!.error!.toString());
      }
      if(next.isLongPressed==true){
        startVibrationEffect();
      }else{
        stopVibrationEffect();
      }
    });
    return Container(
        child: Column(
          children: [

            if (state.videoList?.status == Status.SUCCESS) ...[
              GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.videoList?.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Positioned.fill(
                            child: GestureDetector(

                              onLongPress: () async {
                                if (await Vibration.hasVibrator() == true) {
                                  Vibration.vibrate(duration: 200); // Vibrate for 200ms
                                }
                                ref
                                    .read(profileProvider.notifier)
                                    .setLongPressed(isLongPressed: state.isLongPressed);
                              },
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return ViewVideoScreen(
                                        videoId: state.videoList!.data![index]
                                            .id,
                                      );
                                    }));
                              },
                              child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: AnimatedBuilder(animation: _controller,
                                    builder: (context, child) {
                                      return Transform.translate(offset: Offset(
                                          _controller.value, _controller.value),
                                        child: ClipRect(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            state.videoList!.data![index]
                                                .thumbnails!,
                                            fit: BoxFit.cover,
                                            height: 100,
                                            width: 100,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget: (context, url,
                                                error) =>
                                                Icon(Icons.error),
                                          ),
                                        ),);
                                    },
                                  )
                                // child:Image.network(state.videoList!.data![index].thumbnails!,height: 20,width:20,fit: BoxFit.cover,)
                              ),
                            )),
                        if (state.isLongPressed == true)
                          Positioned(
                            top: -10,
                            right: -10,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.white54),
                              onPressed: () {
                                ref.read(profileProvider.notifier).deleteVideo(videoId: state.videoList!.data![index].id!);

                              },
                            ),
                          ),
                      ],
                    );
                  }),
            ]
            // else if(state.videoList?.status==null || state.videoList?.status==Status.LOADING) ...[
            //   CommonLoader()
            // ]
          ],
        ));
  }
}

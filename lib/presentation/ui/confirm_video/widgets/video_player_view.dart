import 'package:ever_watch/presentation/ui/confirm_video/provider/confirm_video_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends ConsumerWidget {
  final VideoPlayerController? controller;
  const VideoPlayerView({super.key,required this.controller});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    var state = ref.watch(confirmProvider);
    return SizedBox(width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/1.5,
      child: Stack(
        children: [

          VideoPlayer(controller!), GestureDetector(onTap:(){
            ref.read(confirmProvider.notifier).playPauseVideo(controller!);
          },child: Container(color: Colors.transparent,width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.5,child: state.isPlaying==false? Icon(Icons.play_arrow,color: Colors.white,size: 60,) : SizedBox.shrink()))
          ,
        ],
      ),
    );
  }
}

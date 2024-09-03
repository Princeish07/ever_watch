import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
// class VideoPlayerItem extends StatefulWidget {
//   const VideoPlayerItem({super.key});
//
//   @override
//   State<VideoPlayerItem> createState() => _VideoPlayerItemState();
// }
//
// class _VideoPlayerItemState extends State<VideoPlayerItem> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }


class VideoPlayerItem extends ConsumerStatefulWidget {
  String? videoUrl;
   VideoPlayerItem({super.key,this.videoUrl});

  @override
  ConsumerState<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends ConsumerState<VideoPlayerItem> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.videoUrl!)..initialize().then((value){
      controller.play();
      controller.setVolume(1);
    });
    controller.play();
    
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.black
      ),
      child: VideoPlayer(controller)
    );
  }
}

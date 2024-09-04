import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:ever_watch/presentation/ui/video/provider/video_provider.dart';
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
    var state = ref.watch(videoProvider);

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.black
      ),
      child: Stack(
        children: [
          VideoPlayer(controller)
        , GestureDetector(onTap:(){
      ref.read(videoProvider.notifier).playPauseVideo(controller);
    },child: Container(color: Colors.transparent,width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height/1.5,child: state.isPlaying==false? Icon(Icons.play_arrow,color: Colors.white,size: 60,) : SizedBox.shrink()))
    ,
        ],
      )
    );
  }
}

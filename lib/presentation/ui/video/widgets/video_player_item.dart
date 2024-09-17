import 'package:ever_watch/data/model/video_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:ever_watch/presentation/ui/video/provider/video_provider.dart';
import 'package:share_plus/share_plus.dart';
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
  VideoModel? videoModel;
  VideoPlayerController? controller;
  void Function()? onDoubleTap;
   VideoPlayerItem({super.key,this.videoUrl,this.onDoubleTap,this.videoModel,this.controller});

  @override
  ConsumerState<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends ConsumerState<VideoPlayerItem>  with SingleTickerProviderStateMixin , WidgetsBindingObserver {
  // late VideoPlayerController controller;
  bool _isHeartVisible = false;

  @override
  void initState() {
    super.initState();
    // print("BeforeVideoLoad ${DateTime.now().second}");
    //
    //   controller = VideoPlayerController.networkUrl(
    //     Uri.parse(
    //       widget.videoUrl.toString(),
    //     ),
    //     // invalidateCacheIfOlderThan: const Duration(days: 69),
    //   )..initialize().then((value) async {
    //     controller.play();
    //     setState(() {});
    //   });
    // }

    // controller = widget.videoModel!.controller!;
    // controller.play();
    // controller.setVolume(0);

    widget.controller?.setLooping(true);
    widget.controller?.play();
    WidgetsBinding.instance.addObserver(this); // Start observing lifecycle events

    // widget.controller
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(videoProvider.notifier).firstState();
    });



  }

  @override
  void dispose() {
    super.dispose();
    // widget.controller?.dispose();
    WidgetsBinding.instance.removeObserver(this); // Start observing lifecycle events

    widget.controller?.pause();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   ref.read(videoProvider.notifier).playPauseVideo(widget.controller!);
    // });

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    if (state == AppLifecycleState.paused) {
      // Pause the video when the app is backgrounded
      widget.controller?.pause();
    } else if (state == AppLifecycleState.resumed) {
      // Resume the video when the app returns to the foreground
      if (!widget.controller!.value.isPlaying) {
        widget.controller?.play();
      }
    }
  }

    // Method to show heart animation
    void _showHeartAnimation() {
      setState(() {
        _isHeartVisible = true;
      });



      // Hide the heart animation after a short duration
      Future.delayed(Duration(milliseconds: 2000), () {
        setState(() {
          _isHeartVisible = false;
        });

      });
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
          if(widget.videoUrl!="")...[


        VideoPlayer(widget.controller!),

    //     , GestureDetector(onTap:(){
    //   ref.read(videoProvider.notifier).playPauseVideo(controller);
    // },child: Container(color: Colors.transparent,width: MediaQuery.of(context).size.width,
    // height: MediaQuery.of(context).size.height/1.5,child: state.isPlaying==false? Icon(Icons.play_arrow,color: Colors.white,size: 60,) : SizedBox.shrink()))
    // ,
          GestureDetector(
            onDoubleTap: (){
              _showHeartAnimation();
              widget.onDoubleTap!();
            },
            onTap: (){
              ref.read(videoProvider.notifier).playPauseVideo(widget.controller!);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,

              color: Colors.transparent // Placeholder for video or other content
              // color: Colors.transparent // Placeholder for video or other content
              ,child: state.isPlaying==false? Icon(Icons.play_arrow,color: Colors.white,size: 60,) : SizedBox.shrink()),

            // ),
          ),

          // Heart animation
          Center(
            child: AnimatedOpacity(
              opacity: _isHeartVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 100.0,
              ),
            ),
          ),
        ],
    ]
      )
    );
  }

}

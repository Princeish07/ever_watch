import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:ever_watch/presentation/ui/video/provider/video_provider.dart';
import 'package:ever_watch/presentation/ui/view_video/provider/view_video_provider.dart';

// class ViewVideoPlayer extends StatefulWidget {
//   const ViewVideoPlayer({super.key});
//
//   @override
//   State<ViewVideoPlayer> createState() => _ViewVideoPlayerState();
// }
//
// class _ViewVideoPlayerState extends State<ViewVideoPlayer> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class ViewVideoPlayer extends ConsumerStatefulWidget {
  String? videoUrl;
  void Function()? onDoubleTap;

  ViewVideoPlayer({super.key, this.videoUrl, this.onDoubleTap});

  @override
  ConsumerState<ViewVideoPlayer> createState() => _ViewVideoPlayerState();
}

class _ViewVideoPlayerState extends ConsumerState<ViewVideoPlayer>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController controller;
  bool _isHeartVisible = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.videoUrl!)
      ..initialize().then((value) {
        controller.play();
        controller.setVolume(0);
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
    var state = ref.watch(viewVideoProvider);

    ref.listen(viewVideoProvider, (prev, next) {
      controller = VideoPlayerController.network(
          next.videoDetailsResult!.data!.videoUrl!.toString())
        ..initialize().then((value) {
          controller.play();
          controller.setVolume(0);
        });
      controller.play();
    });

    return Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            VideoPlayer(controller),
            GestureDetector(
                onTap: () {
                  ref.read(videoProvider.notifier).playPauseVideo(controller);
                },
                child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: state.isPlaying == false
                        ? const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 60,
                          )
                        : const SizedBox.shrink())),
            GestureDetector(
              onDoubleTap: () {
                _showHeartAnimation();
                widget.onDoubleTap!();
              },
              onTap: () {
                ref.read(videoProvider.notifier).playPauseVideo(controller);
              },
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.transparent
                  // Placeholder for video or other content
                  // color: Colors.transparent // Placeholder for video or other content
                  ,
                  child: state.isPlaying == false
                      ? Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 60,
                        )
                      : SizedBox.shrink()),

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
        ));
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
}

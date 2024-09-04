import 'package:ever_watch/presentation/ui/video/state/video_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/domain/repository/video_repository.dart';
import 'package:ever_watch/data/repository/video_repository_impl.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'dart:core';
import 'package:ever_watch/core/other/resource.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

class VideoProvider extends StateNotifier<VideoState>{
  VideoRepository? videoRepository;

  VideoProvider({this.videoRepository}):super(VideoState());

  Future<void> getVideoList() async {
    Resource<List<VideoModel>>? videoList= await videoRepository?.getVideoList();
   state = state.copyWith(videoListResult: videoList!);
  }

   playPauseVideo(VideoPlayerController controller){
    if(state.isPlaying==true){
      controller.pause();
    }else{
      controller.play();
    }
    controller.setLooping(true);
    controller.setVolume(1);
    state = state.copyWith(isPlaying: !state.isPlaying!);
  }

}

final videoProvider = StateNotifierProvider<VideoProvider, VideoState>((ref){
  return VideoProvider(videoRepository: VideoRepositoryImpl());
});
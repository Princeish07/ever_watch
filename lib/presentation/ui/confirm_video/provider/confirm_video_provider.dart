import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/repository/upload_video_repository_impl.dart';
import 'package:ever_watch/presentation/ui/add_video/state/add_video_state.dart';
import 'package:ever_watch/presentation/ui/confirm_video/state/confirm_video_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../domain/repository/upload_video_repository.dart';

class ConfirmVideoProvider extends StateNotifier<ConfirmVideoState>{
  UploadVideoRepository? uploadVideoRepository;

  ConfirmVideoProvider({this.uploadVideoRepository}):super(ConfirmVideoState(isPlaying: true));


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

  uploadVideo({String? songName, String? caption, String? videoPath}) async {
    if(songName==null || songName.isEmpty){
      state = state.copyWith(uploadVideoResult: Resource.failure(error: "Please enter song name"));
    }else if(caption==null || caption.isEmpty){
      state = state.copyWith(uploadVideoResult: Resource.failure(error: "Please enter caption"));

    }else {
      state = state.copyWith(uploadVideoResult: Resource.loading());

      // Initialize a progress tracker
      double totalProgress = 0.0;
      int tasksCount = 2; // Number of tasks (video and thumbnail uploads)

      // Function to update progress
      double videoProgress = 0.0;
      double thumbnailProgress = 0.0;

      void updateProgress(double progress, String taskType) {
        if (taskType == "video") {
          videoProgress = progress;
        } else if (taskType == "thumbnail") {
          thumbnailProgress = progress;
        }
        double totalProgress = (videoProgress + thumbnailProgress) / 2;
        state = state.copyWith(uploadProgress: totalProgress);
      }

    var result =   await uploadVideoRepository?.uploadVideo(
          songName: songName, caption: caption, videoPath: videoPath,        onProgress: updateProgress
    );

    state = state.copyWith(uploadVideoResult: result);
    }
  }


}

final confirmProvider = StateNotifierProvider<ConfirmVideoProvider,ConfirmVideoState>((ref){
  return ConfirmVideoProvider(uploadVideoRepository: UploadVideoRepositoryImpl());
});
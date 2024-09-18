import 'package:ever_watch/presentation/ui/video/state/video_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/domain/repository/video_repository.dart';
import 'package:ever_watch/data/repository/video_repository_impl.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'dart:core';
import 'package:ever_watch/core/other/resource.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ever_watch/data/repository/profile_repository_impl.dart';
import 'package:ever_watch/domain/repository/profile_repository.dart';
class VideoProvider extends StateNotifier<VideoState> {
  VideoRepository? videoRepository;
  ProfileRepository? profileRepository;

  VideoProvider({this.videoRepository,this.profileRepository})
      : super(VideoState(videoListResult: Resource.loading(), isPlaying: true,hasMore: true));

  // void getVideoList() {
  //   videoRepository
  //       ?.getVideoListStream()
  //       ?.listen((Resource<List<VideoModel>> videoList) async {
  //     List<VideoPlayerController> videoController = await initializeVideoControllers(videoList.data!);
  //     print("Video List ${videoList.data?.toSet().toString()}");
  //     print("Video Controller ${videoController.toSet().toString()}");
  //     print(" is Playing state ${state.isPlaying}");
  //
  //     state = state.copyWith(videoListResult: videoList,videoControllerList: videoController);
  //     getProfileDetails();
  //   });
  //
  //   //  Resource<List<VideoModel>>? videoList= await videoRepository?.getVideoList();
  //   // state = state.copyWith(videoListResult: videoList!);
  // }

  void getVideoList() async {
    final stream = videoRepository?.getVideoListStream();
    stream?.listen((videoList) async {
          List<VideoPlayerController> videoController = await initializeVideoControllers(videoList.data!);

      state = state.copyWith(
        videoListResult: videoList,
        hasMore: state.hasMore,
        videoControllerList: videoController
      );
    });
  }

  void fetchMoreVideos() {
    if (state.hasMore) {
      final stream = videoRepository?.getVideoListStream();
      stream?.listen((videoList) async {
        List<VideoPlayerController> videoController = await initializeVideoControllers(videoList.data!);

        state = state.copyWith(
          videoListResult: videoList,
          hasMore: state.hasMore,
            videoControllerList: videoController

        );
      });
    }
  }



  Future<List<VideoPlayerController>> initializeVideoControllers(List<VideoModel> videoList) async {
    // Use Future.wait to wait for all video controllers to initialize
    List<Future<VideoPlayerController>> controllerFutures = videoList.map((videoModel) async {
      VideoPlayerController controller = VideoPlayerController.networkUrl(
        Uri.parse(videoModel.videoUrl!),
      );
      await controller.initialize();
      return controller;
    }).toList();

    // Wait for all controllers to complete initialization
    return await Future.wait(controllerFutures);
  }

  playPauseVideo(VideoPlayerController controller) {
    if (state.isPlaying == true) {
      controller.pause();
    } else {
      controller.play();
    }
    controller.setLooping(true);
    controller.setVolume(1);
    state = state.copyWith(isPlaying: !state.isPlaying!);
  }

  likingVideo({String? id}) async {
    videoRepository?.likeThePost(id: id);
    // Find the video in the current list by id and modify the likes
    List<VideoModel>? updatedVideoList =
        state.videoListResult?.data?.map((video) {
      if (video.id == id) {
        // Check if the current user's UID is already in the likes list
        if (video.likes?.contains(FirebaseAuth.instance.currentUser?.uid) ==
            true) {
          // If the user has already liked the video, remove their UID (unlike)
          video.likes?.remove(FirebaseAuth.instance.currentUser?.uid);
        } else {
          // If the user hasn't liked the video, add their UID (like)
          video.likes?.add(FirebaseAuth.instance.currentUser?.uid);
        }
      }
      return video; // Return the video (modified or not)
    }).toList();

    state = state.copyWith(
        videoListResult: Resource.success(data: updatedVideoList));
  }

  sendFollowRequest({String? otherUserId}) async {

    try {
      await videoRepository?.sendFollowRequest(otherUserId: otherUserId!);

    } catch (e) {
      print(e);
    }

  }

  getProfileDetails(){

    profileRepository?.getUserDetails(uid: FirebaseAuth.instance?.currentUser?.uid!.toString())?.listen((ref){
      state = state.copyWith(otherProfileDetails:ref!);
    });

  }

  firstState(){

    state = state.copyWith(isPlaying: true);
  }
}

final videoProvider = StateNotifierProvider<VideoProvider, VideoState>((ref) {
  return VideoProvider(videoRepository: VideoRepositoryImpl(),profileRepository: ProfileRepositoryImpl());
});

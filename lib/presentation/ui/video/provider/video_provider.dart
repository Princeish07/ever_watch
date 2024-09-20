
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
    print("getVideoList method called ${state.hasMore}");
    if(state.videoListResult?.data?.isEmpty==null ||state.videoListResult?.data?.isEmpty==true || state.hasMore) {
      print("Hit");
      final videoList = await videoRepository?.getVideoList();

        print("getVideoList method video length ${videoList?.data?.length}");
        if(videoList?.data?.length==0){
          state = state.copyWith(hasMore: false);
        }
        else if(state.videoListResult?.data==null){
          List<
              VideoPlayerController> videoController = await initializeVideoControllers(
              videoList!.data!);
          state = state.copyWith(
              videoListResult: videoList,
              hasMore: true,
              videoControllerList: videoController

          );
        }
        else  {
          List<
              VideoPlayerController> videoController = await initializeVideoControllers(
              videoList!.data!);

          state = state.copyWith(
              videoListResult: Resource.success(
                  data: mergeAndUpdateVideos(
                    currentList: state.videoListResult?.data,
                    newList: videoList.data,
                  )
              ),
              hasMore: true,
              videoControllerList: [
                ...state.videoControllerList!,
                ...videoController
              ]

          );
        }

      // });
    }
  }



  List<VideoModel> mergeAndUpdateVideos({
    required List<VideoModel>? currentList,
    required List<VideoModel>? newList,
  }) {
    Map<String, VideoModel> videoMap = {
      for (VideoModel video in currentList ?? []) video.id!: video
    };

    // Iterate over the new list and update/add videos
    for (VideoModel newVideo in newList ?? []) {
      videoMap[newVideo.id!] = newVideo; // This will either update or add the new video
    }

    // Return the updated list
    return videoMap.values.toList();
  }

  // void fetchMoreVideos() {
  //   print("Fetch more videos method called ${state.hasMore}");
  //   if (state.hasMore) {
  //     final stream = videoRepository?.getVideoListStream();
  //     stream?.listen((videoList) async {
  //
  //       List<VideoPlayerController> videoController = await initializeVideoControllers(videoList.data!);
  //
  //       print("Fetch more videos method video length ${videoList.data?.length}");
  //
  //       if(videoList.data?.length==0){
  //        state = state.copyWith(hasMore: false);
  //       }
  //       else {
  //         state = state.copyWith(
  //             videoListResult: Resource.success(
  //                 data: [...?state.videoListResult?.data, ...videoList.data!]
  //             ),
  //             hasMore: true,
  //             videoControllerList: [
  //               ...state.videoControllerList!,
  //               ...videoController
  //             ]
  //
  //         );
  //       }
  //     });
  //   }
  // }



  Future<List<VideoPlayerController>> initializeVideoControllers(List<VideoModel> videoList) async {
    // Use Future.wait to wait for all video controllers to initialize
    List<Future<VideoPlayerController>> controllerFutures = videoList.map((videoModel) async {
      VideoPlayerController controller = VideoPlayerController.networkUrl(
        Uri.parse(videoModel.videoUrl!),videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true,webOptions: VideoPlayerWebOptions(allowRemotePlayback: true,controls: VideoPlayerWebOptionsControls.enabled(allowDownload: true,allowFullscreen: true,allowPlaybackRate: true,allowPictureInPicture: true)))
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

    profileRepository?.getUserDetails(uid: FirebaseAuth.instance.currentUser?.uid.toString())?.listen((ref){
      state = state.copyWith(otherProfileDetails:ref);
    });

  }

  firstState(){

    state = state.copyWith(isPlaying: true);
  }


  // Optimistically update the comment count
  void incrementCommentCountOptimistically(String videoId) {
    // Find the video index
    var videoIndex = state.videoListResult?.data?.indexWhere((video) => video.id == videoId);

    if (videoIndex != null && videoIndex != -1) {
      // Get the video and increment the comment count
      var video = state.videoListResult?.data?[videoIndex];
      video?.commentCount = (video.commentCount ?? 0) + 1;

      // Update the state to reflect changes
      state = state.copyWith(
        videoListResult: Resource.success(
          data: [...state.videoListResult?.data ?? []],
        ),
      );
    }
  }
}

final videoProvider = StateNotifierProvider<VideoProvider, VideoState>((ref) {
  return VideoProvider(videoRepository: VideoRepositoryImpl(),profileRepository: ProfileRepositoryImpl());
});

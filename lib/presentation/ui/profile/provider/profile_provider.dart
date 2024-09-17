import 'package:ever_watch/data/repository/video_repository_impl.dart';
import 'package:ever_watch/domain/repository/video_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/presentation/ui/profile/state/profile_state.dart';
import 'package:ever_watch/data/repository/profile_repository_impl.dart';
import 'package:ever_watch/domain/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ever_watch/core/other/resource.dart';

import '../../../../data/model/video_model.dart';
class ProfileProvider extends StateNotifier<ProfileState>{
  ProfileRepository? repository;
  VideoRepository? videoRepository;

  ProfileProvider({this.repository,this.videoRepository}):super(ProfileState(isLongPressed: false));

  //Method to get video list of particular user
  getVideoList({String? uid}){
    // state = state.copyWith(videoList: Resource.loading());
    repository?.getVideoListOfParticularUser(uid: uid)?.listen((list){
     var totalLikes = getTotalLikes(list);
      state = state.copyWith(videoList: list,likes: totalLikes);
    });

  }


  int getTotalLikes(Resource<List<VideoModel>> resource) {
    if (resource.data != null) {
      // Use fold to accumulate the sum of likes
      return resource.data!.fold(0, (sum, video) => sum + video.likes!.length);
    } else {
      return 0; // Return 0 if the resource contains no data
    }
  }

  //Method to get user details
  getUserDetails({String? uid}){
    repository?.getUserDetails(uid: uid)?.listen((userDetail){
      state = state.copyWith(userModel: userDetail);
    });

  }

  //method to change isLongPressed state
  setLongPressed({bool? isLongPressed}){
    state = state.copyWith(isLongPressed: !isLongPressed!);
  }

  //method to delete to video
  deleteVideo({String? videoId}){
    repository?.deleteVideo(videoId: videoId!);
  }


  sendFollowRequest({String? otherUserId}) async {

    try {
      await videoRepository?.sendFollowRequest(otherUserId: otherUserId!);

    } catch (e) {
      print(e);
    }

  }


  unsendFollowRequest({String? otherUserId}) async {

    try {
      await videoRepository?.unsendFollowRequest(otherUserId: otherUserId!);

    } catch (e) {
      print(e);
    }

  }


  unFollowRequest({String? otherUserId}) async {

    try {
      await videoRepository?.unFollowUser(otherUserId: otherUserId!);

    } catch (e) {
      print(e);
    }

  }
}

final profileProvider = StateNotifierProvider.autoDispose<ProfileProvider,ProfileState>((ref){
  return ProfileProvider(repository: ProfileRepositoryImpl(),videoRepository: VideoRepositoryImpl());
});
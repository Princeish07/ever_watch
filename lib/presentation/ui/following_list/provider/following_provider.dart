import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/repository/following_list_repository_impl.dart';
import 'package:ever_watch/domain/repository/following_list_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/following_state.dart';

class FollowingProvider extends StateNotifier<FollowingState>{
  FollowingListRepository? followingListRepository;
  FollowingProvider({this.followingListRepository}):super(FollowingState());


  getFollowingList({bool? isFollowingList}){

    try {
      state = state.copyWith(followingList: Resource.loading());
      if(isFollowingList==true) {
        followingListRepository
            ?.getFollowRequestList(uid: FirebaseAuth.instance.currentUser?.uid)
            ?.listen((followResult) {
          state = state.copyWith(followingList: followResult);
        });
      }else{
        followingListRepository
            ?.getFollowerRequestList(uid: FirebaseAuth.instance.currentUser?.uid)
            ?.listen((followResult) {
          state = state.copyWith(followingList: followResult);
        });
      }
      state = state.copyWith(followingList: Resource.success());
    } catch (e) {
      print(e);
      state = state.copyWith(followingList: Resource.failure(error: e.toString()));

    }

  }

}

final followingProvider = StateNotifierProvider.autoDispose<FollowingProvider,FollowingState>((ref){
  return FollowingProvider(followingListRepository: FollowingListRepositoryImpl());
});
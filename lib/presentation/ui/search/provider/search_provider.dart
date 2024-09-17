import 'package:ever_watch/data/repository/video_repository_impl.dart';
import 'package:ever_watch/domain/repository/video_repository.dart';
import 'package:ever_watch/presentation/ui/search/state/search_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';
import 'dart:async';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/domain/repository/search_repository.dart';
import 'package:ever_watch/data/repository/search_repository_impl.dart';
class SearchProvider extends StateNotifier<SearchState>{
  SearchRepository? searchRepository;
  VideoRepository? videoRepository;
  SearchProvider({this.searchRepository,this.videoRepository}):super(SearchState());

  searchUser({String? userName}) async{
    state = state.copyWith(searchedUserResult: Resource.loading());
    await searchRepository?.searchUserList(userName: userName)?.listen((userListResult){
      state = state.copyWith(searchedUserResult: userListResult);

    });
    state = state.copyWith(searchedUserResult: Resource.success(data: []));

  }


  sentFollowRequest({String? otherUserId}) async{
    try {
     var result = await videoRepository?.sendFollowRequest(otherUserId: otherUserId);
     if(result?.status==Status.FAILURE) {
        state = state.copyWith(errorMessage:result?.error.toString());
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  unsendFollowRequest({String? otherUserId}) async {

    try {
      await videoRepository?.unsendFollowRequest(otherUserId: otherUserId!);

    } catch (e) {
      print(e);
    }

  }




}

final searchProvider = StateNotifierProvider.autoDispose<SearchProvider,SearchState>((value){
  return SearchProvider(searchRepository: SearchRepositoryImpl(),videoRepository: VideoRepositoryImpl());
});
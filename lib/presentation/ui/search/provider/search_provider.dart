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
  SearchProvider({this.searchRepository}):super(SearchState());

  searchUser({String? userName}) async{
    state = state.copyWith(searchedUserResult: Resource.loading());
    await searchRepository?.searchUserList(userName: userName)?.listen((userListResult){
      state = state.copyWith(searchedUserResult: userListResult);
    });
  }


}

final searchProvider = StateNotifierProvider<SearchProvider,SearchState>((value){
  return SearchProvider(searchRepository: SearchRepositoryImpl());
});
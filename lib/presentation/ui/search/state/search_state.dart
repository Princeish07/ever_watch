import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';
import 'package:ever_watch/data/model/user_model.dart';
class SearchState{
  Resource<List<UserModel>>? searchedUserResult;

  SearchState({this.searchedUserResult});

  SearchState copyWith({Resource<List<UserModel>>? searchedUserResult}) {
    return SearchState(searchedUserResult: searchedUserResult ?? this.searchedUserResult);
  }
}
import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';
import 'package:ever_watch/data/model/user_model.dart';
class SearchState{
  Resource<List<UserModel>>? searchedUserResult;
  String? errorMessage;

  SearchState({this.searchedUserResult,this.errorMessage});

  SearchState copyWith({Resource<List<UserModel>>? searchedUserResult,String? errorMessage}) {
    return SearchState(searchedUserResult: searchedUserResult ?? this.searchedUserResult,errorMessage: errorMessage ?? this.errorMessage);
  }
}
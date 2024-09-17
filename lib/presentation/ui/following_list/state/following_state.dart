import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/user_model.dart';

class FollowingState{
  Resource<List<UserModel>>? followingList;
  FollowingState({this.followingList});

  FollowingState copyWith({Resource<List<UserModel>>? followingList}){
    return FollowingState(followingList:  followingList ?? this.followingList);
  }
}
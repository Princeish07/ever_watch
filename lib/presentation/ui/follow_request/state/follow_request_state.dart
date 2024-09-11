import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/core/other/resource.dart';

class FollowRequestState{
  Resource<List<UserModel>>? followRequestList;

  FollowRequestState({this.followRequestList});

  FollowRequestState copyWith({Resource<List<UserModel>>? followRequestList}){
    return FollowRequestState(followRequestList: followRequestList ?? this.followRequestList);
  }
}
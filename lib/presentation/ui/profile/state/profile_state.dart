import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/data/model/user_model.dart';

class ProfileState{
  Resource<List<VideoModel>>? videoList;
  Resource<UserModel>? userModel;
  int? likes;

  ProfileState({this.videoList,this.userModel,this.likes});

  ProfileState copyWith({ Resource<List<VideoModel>>? videoList,Resource<UserModel>? userModel}){
    return ProfileState(videoList: videoList ?? this.videoList,userModel: userModel ?? this.userModel,likes: likes ?? this.likes);
  }

}
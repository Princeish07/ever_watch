import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/data/model/user_model.dart';

class ProfileState{
  Resource<List<VideoModel>>? videoList;
  Resource<UserModel>? userModel;
  int? likes;
  bool? isLongPressed;

  ProfileState({this.videoList,this.userModel,this.likes,this.isLongPressed=false});

  ProfileState copyWith({ Resource<List<VideoModel>>? videoList,Resource<UserModel>? userModel,bool? isLongPressed,int? likes}){
    return ProfileState(videoList: videoList ?? this.videoList,userModel: userModel ?? this.userModel,likes: likes ?? this.likes,isLongPressed: isLongPressed ?? this.isLongPressed);
  }

}
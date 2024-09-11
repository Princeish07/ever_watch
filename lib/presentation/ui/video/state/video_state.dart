import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';
import 'package:ever_watch/data/model/user_model.dart';


class VideoState{
  Resource<List<VideoModel>>? videoListResult;
  Resource<UserModel>? otherProfileDetails;
  bool? isPlaying;

  VideoState({this.videoListResult,this.isPlaying=true,this.otherProfileDetails});

  VideoState copyWith({Resource<List<VideoModel>>? videoListResult,bool? isPlaying,Resource<UserModel>? otherProfileDetails})
  {
    return VideoState(videoListResult: videoListResult ?? this.videoListResult,isPlaying: isPlaying ?? this.isPlaying,otherProfileDetails: otherProfileDetails ?? this.otherProfileDetails);
  }
}
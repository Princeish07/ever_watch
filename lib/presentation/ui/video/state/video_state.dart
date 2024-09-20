import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:video_player/video_player.dart';


class VideoState{
  Resource<List<VideoModel>>? videoListResult;
  Resource<UserModel>? otherProfileDetails;
  List<VideoPlayerController>? videoControllerList;
  bool? isPlaying;
  final bool hasMore;

  VideoState({this.videoListResult,this.isPlaying=true,this.otherProfileDetails,this.videoControllerList,required this.hasMore});

  VideoState copyWith({Resource<List<VideoModel>>? videoListResult,bool? isPlaying,Resource<UserModel>? otherProfileDetails,List<VideoPlayerController>? videoControllerList,bool? hasMore})
  {
    return VideoState(videoListResult: videoListResult ?? this.videoListResult,isPlaying: isPlaying ?? this.isPlaying,otherProfileDetails: otherProfileDetails ?? this.otherProfileDetails,videoControllerList: videoControllerList ?? this.videoControllerList,      hasMore: hasMore ?? this.hasMore);
  }
}
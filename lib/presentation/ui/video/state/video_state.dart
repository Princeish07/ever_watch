import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';

class VideoState{
  Resource<List<VideoModel>>? videoListResult;
  bool? isPlaying;

  VideoState({this.videoListResult,this.isPlaying});

  VideoState copyWith({Resource<List<VideoModel>>? videoListResult,bool? isPlaying}){
    return VideoState(videoListResult: videoListResult ?? this.videoListResult,isPlaying: isPlaying ?? this.isPlaying);
  }
}
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/video_model.dart';
class ViewVideoState {

  Resource<VideoModel>? videoDetailsResult;
  bool? isPlaying;

ViewVideoState({this.videoDetailsResult,this.isPlaying=true});

ViewVideoState copyWith({Resource<VideoModel>? videoDetailsResult,bool? isPlaying}){
  return ViewVideoState(videoDetailsResult: videoDetailsResult ?? this.videoDetailsResult,isPlaying: isPlaying ?? this.isPlaying);
}


}
import 'package:ever_watch/core/other/resource.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmVideoState{
  bool? isPlaying;
  Resource<bool>? uploadVideoResult;
  double? uploadProgress;

  ConfirmVideoState({this.isPlaying,this.uploadVideoResult,this.uploadProgress=0.0});

  ConfirmVideoState copyWith({bool? isPlaying,Resource<bool>? uploadVideoResult,double? uploadProgress}){
    return ConfirmVideoState(isPlaying: isPlaying ?? this.isPlaying,uploadVideoResult: uploadVideoResult ?? this.uploadVideoResult ,uploadProgress: uploadProgress ?? this.uploadProgress);
  }


}
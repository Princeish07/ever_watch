import 'package:ever_watch/core/other/resource.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmVideoState{
  bool? isPlaying;
  Resource<bool>? uploadVideoResult;

  ConfirmVideoState({this.isPlaying,this.uploadVideoResult});

  ConfirmVideoState copyWith({bool? isPlaying,Resource<bool>? uploadVideoResult}){
    return ConfirmVideoState(isPlaying: isPlaying ?? this.isPlaying,uploadVideoResult: uploadVideoResult ?? this.uploadVideoResult );
  }


}
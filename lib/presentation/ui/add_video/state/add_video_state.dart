import 'package:image_picker/image_picker.dart';

class AddVideoState{
  XFile? video;

  AddVideoState({this.video});

  AddVideoState copyWith({XFile? video}){
    return AddVideoState(video: video ?? this.video);
  }


}
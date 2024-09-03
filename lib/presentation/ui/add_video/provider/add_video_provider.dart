import 'package:ever_watch/presentation/ui/add_video/state/add_video_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddVideoProvider extends StateNotifier<AddVideoState>{

  AddVideoProvider():super(AddVideoState());

  pickVideo(ImageSource src,BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    state = state.copyWith(video: video);

  }


}

final addVideoProvider = StateNotifierProvider<AddVideoProvider,AddVideoState>((ref){
  return AddVideoProvider();
});
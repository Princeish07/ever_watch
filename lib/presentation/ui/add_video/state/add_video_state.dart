import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddVideoState{
  XFile? video;
  File? audioFile;
   PermissionStatus? permissionStatus;

  AddVideoState({this.video,this.permissionStatus,this.audioFile});

  AddVideoState copyWith({XFile? video,PermissionStatus? permissionStatus, File? audioFile}){
    return AddVideoState(video: video ?? this.video,permissionStatus: permissionStatus ?? this.permissionStatus,audioFile: audioFile ?? this.audioFile );
  }


}
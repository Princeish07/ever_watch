import 'dart:io';

import 'package:ever_watch/presentation/ui/add_video/state/add_video_state.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../confirm_video/widgets/confirm_video_screen.dart';

class AddVideoProvider extends StateNotifier<AddVideoState>{

  AddVideoProvider():super(AddVideoState(permissionStatus: PermissionStatus.denied)){
    requestStoragePermission();
  }

  pickVideo(ImageSource src,BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    state = state.copyWith(video: video);


  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
    state = state.copyWith(permissionStatus: status);
  }

  Future<void> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      File file = File(result.files.single.path!);
     state = state.copyWith(audioFile: file);

    }
  }

  Future<void> mergeAudioAndVideo(BuildContext context) async {
    if (state.permissionStatus != PermissionStatus.granted) {
      print('Storage permission not granted.');
      return;
    }

    final audioPath = await _getAudioFilePath();
    final videoPath = await _getVideoFilePath();
    final outputPath = await getOutputFilePath();

    final command =
        '-i $videoPath -i $audioPath -c:v copy -c:a aac -strict experimental -y $outputPath';

    // final executionId = await FFmpegKit.executeAsync(command);
    // final returnCode = await FFmpegKitConfig.getLastSession();

    await FFmpegKit.execute(command).then((rc) async {
     var output =  await rc.getOutput();
     var returncode = await rc.getReturnCode();
     var argument = await rc.getArguments();
     var allLogs = await rc.getAllLogs().toString();

      if (returncode?.getValue() == ReturnCode.success) {
        print('Merge successful');
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ConfirmVideoScreen(videoFile: File(outputPath),videoPath: outputPath,)));

      } else {
        print('Merge failed');
      }
    });
    // var code = await returnCode?.getReturnCode();
    // if ( code    == ReturnCode.success) {
    //   print('Merge successful');
    // } else {
    //   print('Merge failed');
    // }
  }


  String _getVideoFilePath()  {
    return state.video!.path.toString(); // Replace with your video file path
  }

  String _getAudioFilePath()  {
    return state.audioFile!.path.toString(); // Replace with your desired output file path
  }

  Future<String> getOutputFilePath() async {
    final directory = await getTemporaryDirectory();
    return '${directory.path}/output.mp4'; // Output file path
  }
}

final addVideoProvider = StateNotifierProvider<AddVideoProvider,AddVideoState>((ref){
  return AddVideoProvider();
});
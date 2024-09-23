import 'dart:io';
import 'dart:ui';

import 'package:ever_watch/core/other/general_utils.dart';
import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:ever_watch/presentation/ui/add_video/provider/add_video_provider.dart';
import 'package:ever_watch/presentation/ui/confirm_video/widgets/confirm_video_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddVideoScreen extends ConsumerWidget {
  const AddVideoScreen({super.key});



showOptionDialog(BuildContext context,WidgetRef ref){
  return showDialog(context: context, builder: (context)=> SimpleDialog(children: [
    SimpleDialogOption(padding: EdgeInsets.all(20),onPressed: () async {
      // Navigator.pop(context);

      // await ref.read(addVideoProvider.notifier).pickVideo(ImageSource.camera, context);
      await ref.read(addVideoProvider.notifier).mergeAudioAndVideo(context);
    },child: const Row(children: [
      Icon(Icons.image),
      Text("Camera")
    ],),),

    SimpleDialogOption(padding: EdgeInsets.all(20),onPressed: () async {
      // Navigator.pop(context);

      await ref.read(addVideoProvider.notifier).pickVideo(ImageSource.gallery, context);
    },child: const Row(children: [
      Icon(Icons.photo),
      Text("Gallery")
    ],),),

    SimpleDialogOption(padding: const EdgeInsets.all(20),onPressed: () async {
      await ref.read(addVideoProvider.notifier).pickAudioFile();

      // Navigator.pop(context);

    },child: const Row(children: [
      Icon(Icons.cancel),
      Text("Cancel")
    ],),),
  ],));
}


  @override
  Widget build(BuildContext context,WidgetRef ref) {

  var addVideoState = ref.watch(addVideoProvider);

  ref.listen(addVideoProvider, (previous, next) {
    if(next.video!=null){
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> ConfirmVideoScreen(videoFile: File(next.video!.path),videoPath: next.video?.path,)));
    }

  });
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            if(addVideoState.permissionStatus==PermissionStatus.granted) {
              showOptionDialog(context, ref);
            }else{
              showToast("Permission Denied");
            }
          },
          child: Container(
            color: AppColors().mainButtonColor,
            height: 50,
            width: 190,
            child: Center(
              child: const Text(
                "Add Video",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

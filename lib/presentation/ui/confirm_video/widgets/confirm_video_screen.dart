import 'dart:io';

import 'package:ever_watch/core/other/general_utils.dart';
import 'package:ever_watch/presentation/common_widgets/common_loader.dart';
import 'package:ever_watch/presentation/common_widgets/text_input_field.dart';
import 'package:ever_watch/presentation/ui/confirm_video/provider/confirm_video_provider.dart';
import 'package:ever_watch/presentation/ui/confirm_video/widgets/video_player_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/other/resource.dart';

class ConfirmVideoScreen extends ConsumerStatefulWidget {
  File? videoFile;
  String? videoPath;

   ConfirmVideoScreen({super.key,this.videoFile,this.videoPath});

  @override
  ConsumerState<ConfirmVideoScreen> createState() => _ConfirmVideoScreenState();
}

class _ConfirmVideoScreenState extends ConsumerState<ConfirmVideoScreen> {
  late VideoPlayerController controller;
  TextEditingController? songController;
  TextEditingController? captionController;


  @override
  void initState() {
    super.initState();
    songController = TextEditingController(text: "");
    captionController = TextEditingController(text: "");


    controller = VideoPlayerController.file(widget.videoFile!);
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);

  }


  @override
  Widget build(BuildContext context) {

    var state = ref.watch(confirmProvider);
    ref.listen(confirmProvider, (previous, next) {
      if(next.uploadVideoResult?.status==Status.SUCCESS){
        showToast("Video upload successfully");
        Navigator.pop(context);

      }else if(next.uploadVideoResult?.status==Status.FAILURE){
        showToast(next.uploadVideoResult!.error.toString());
      }
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 30,),
                VideoPlayerView(controller: controller,),
                SizedBox(height: 30,),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
            width:MediaQuery.of(context).size.width-20 ,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: TextInputField(textEditingController: songController,hintText: "Song name",prefixIcon: Icon(Icons.music_note),),
                  ),
                  SizedBox(height: 10,),
                  Container(
            width:MediaQuery.of(context).size.width-20 ,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: TextInputField(textEditingController: captionController,hintText: "Caption",prefixIcon: Icon(Icons.closed_caption),),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: (){
            ref.read(confirmProvider.notifier).uploadVideo(songName: songController?.text.toString(),caption: captionController?.text,videoPath: widget.videoPath );


                  }, child: Text("Share!",style: TextStyle(fontSize: 20,color: Colors.white),))

                ],
              ),
            )
              ],
            ),

            if(state.uploadVideoResult?.status==Status.LOADING) ...[
              const CommonLoader()
            ]
          ],
        ),
      ),

    );
  }
}

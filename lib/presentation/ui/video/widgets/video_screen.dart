import 'package:ever_watch/presentation/ui/video/widgets/video_player_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoScreen extends ConsumerWidget {
  const VideoScreen({super.key});


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      body: PageView.builder(
      controller: PageController(initialPage: 0,viewportFraction: 1)
      ,scrollDirection: Axis.vertical,
          itemBuilder: (context,index){
        return Stack(
          children: [
            VideoPlayerItem(videoUrl: "url",),
            Column(
              children: [
                SizedBox(height: 100,),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('username',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                          Text('Caption',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)

                        ],
                      ),
                    )
                  ],
                )
              ],
            )

          ],

        );

      })
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:ever_watch/presentation/ui/login/widgets/login_screen.dart';
import 'package:ever_watch/presentation/ui/profile/provider/profile_provider.dart';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/presentation/common_widgets/common_loader.dart';
import 'package:ever_watch/core/other/general_utils.dart';
class UserVideoList extends ConsumerStatefulWidget {
  const UserVideoList({super.key});

  @override
  ConsumerState<UserVideoList> createState() => _UserVideoListState();
}

class _UserVideoListState extends ConsumerState<UserVideoList> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(profileProvider);
    ref.listen(profileProvider, (prev,next){
      if(next.videoList?.status==Status.FAILURE) {
      showToast(next.videoList!.error!.toString());
    }
    });
    return
      Container(
          child: Column(
        children: [
          if(state.videoList?.status==Status.SUCCESS) ...[

            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
                itemCount: state.videoList?.data!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0
                ),
                itemBuilder: (BuildContext context, int index){
                  return Padding(padding: EdgeInsets.all(15),
                   child: ClipRect(
                      child: CachedNetworkImage(
                        imageUrl: state.videoList!.data![index].thumbnails!,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                  // child:Image.network(state.videoList!.data![index].thumbnails!,height: 20,width:20,fit: BoxFit.cover,)
              );
            }),
          ]
          // else if(state.videoList?.status==null || state.videoList?.status==Status.LOADING) ...[
          //   CommonLoader()
          // ]
        ],
      ));
  }
}

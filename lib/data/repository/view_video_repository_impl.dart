import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/domain/repository/view_video_repository.dart';
import 'dart:core';

class ViewVideoRepositoryImpl extends ViewVideoRepository {
  Stream<Resource<VideoModel>>? getViewDetails({String? videoId})  {
    try {
      return
           FirebaseFirestore.instance.collection('videos').doc(videoId!).snapshots().map((videoDoc){
            VideoModel videoModel = VideoModel()
                .fromJson (videoDoc.data() as Map<String, dynamic>);
            return Resource.success(data: videoModel);
          });

    } catch (e) {
      print(e);
      return Stream.value(Resource.failure(error: e.toString()));
    }
  }
}

import 'package:ever_watch/domain/repository/video_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';
import 'dart:async';

class VideoRepositoryImpl extends VideoRepository{

  Future<Resource<List<VideoModel>>>? getVideoList() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("videos").get();

      List<VideoModel> videoList = snapshot.docs.map((doc) {
        return VideoModel().fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return Resource.success(data: videoList);
    } catch (e) {
      return Resource.failure(error: e.toString());
    }
  }

}
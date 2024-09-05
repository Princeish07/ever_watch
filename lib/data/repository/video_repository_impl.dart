import 'package:ever_watch/domain/repository/video_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:core';
import 'dart:async';

class VideoRepositoryImpl extends VideoRepository{

  Stream<Resource<List<VideoModel>>>? getVideoListStream() {
    try {
      return FirebaseFirestore.instance.collection("videos").snapshots().map((snapshot) {
        List<VideoModel> videoList = snapshot.docs.map((doc) {
          return VideoModel().fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        return Resource.success(data: videoList);
      });
    } catch (e) {
      return Stream.value(Resource.failure(error: e.toString()));
    }
  }

  Future<Resource<bool>> likeThePost({String? id}) async
  {
    try{
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("videos").doc(id).get();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  if((snapshot.data() as Map<String,dynamic>)["likes"].contains(uid)){
  await FirebaseFirestore.instance.collection("videos").doc(id).update({'likes':FieldValue.arrayRemove([uid])});
  return Resource.success(data: true);

  }else{
  await FirebaseFirestore.instance.collection("videos").doc(id).update({'likes':FieldValue.arrayUnion([uid])});
  return Resource.success(data: true);
  }
  }
  catch(e){
      return Resource.failure(error: e.toString());
  }
  }

}
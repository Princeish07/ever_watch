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


  Future<Resource<bool>>? sendFollowRequest({String? otherUserId}) async{
    try {
      DocumentReference currentUserRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid?.toString());
      DocumentReference targetUserRef = FirebaseFirestore.instance.collection('users').doc(otherUserId!);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the target user's ID to the current user's 'sentRequests'
      batch.update(currentUserRef, {
            'sentRequests': FieldValue.arrayUnion([otherUserId])
          });

      // Add the current user's ID to the target user's 'receivedRequests'
      batch.update(targetUserRef, {
            'receivedRequests': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid?.toString()])
          });

      await batch.commit();
      return Resource.success(data: true);
    } catch (e) {
      print(e);
      return Resource.failure(error: e.toString());
    }
  }

  @override
  Future<Resource<bool>>? unsendFollowRequest({String? otherUserId}) async{
    try {
      DocumentReference currentUserRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid?.toString());
      DocumentReference targetUserRef = FirebaseFirestore.instance.collection('users').doc(otherUserId!);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the target user's ID to the current user's 'sentRequests'
      batch.update(currentUserRef, {
        'sentRequests': FieldValue.arrayRemove([otherUserId])
      });

      // Add the current user's ID to the target user's 'receivedRequests'
      batch.update(targetUserRef, {
        'receivedRequests': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid.toString()])
      });

      await batch.commit();
      return Resource.success(data: true);
    } catch (e) {
      print(e);
      return Resource.failure(error: e.toString());
    }
  }

  @override
  Future<Resource<bool>>? unFollowUser({String? otherUserId}) async{
    try {
      DocumentReference currentUserRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid?.toString());
      DocumentReference targetUserRef = FirebaseFirestore.instance.collection('users').doc(otherUserId!);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the target user's ID to the current user's 'sentRequests'
      batch.update(currentUserRef, {
        'following': FieldValue.arrayRemove([otherUserId])
      });

      // Add the current user's ID to the target user's 'receivedRequests'
      batch.update(targetUserRef, {
        'followers': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid?.toString()])
      });

      await batch.commit();
      return Resource.success(data: true);
    } catch (e) {
      print(e);
      return Resource.failure(error: e.toString());
    }
  }



}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/domain/repository/upload_video_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoRepositoryImpl extends UploadVideoRepository {
  @override
  Future<Resource<bool>> uploadVideo(
      {String? songName, String? caption, String? videoPath,    Function(double, String)? onProgress, // Add the onProgress callback

      }) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      // var allDocs = await FirebaseFirestore.instance.collection("videos").get();
      // int len = allDocs.docs.length;
      DocumentReference docRef= await FirebaseFirestore.instance.collection("videos").doc();

      String videoUrl =
          await _uploadVideoToStorage(id: '${docRef.id}', videoPath: videoPath,        onProgress: (progress) => onProgress?.call(progress,"video"),
          );

      String thumbNails =
          await _uploadImageToStorage(id: "${docRef.id}", videoPath: videoPath,        onProgress: (progress) => onProgress?.call(progress,"image"),
          );
      // DocumentReference docRef= await FirebaseFirestore.instance.collection("videos").doc();
      VideoModel videoModel = VideoModel(
          userName: (userDoc.data()! as Map<String, dynamic>)['name'],
          uid: FirebaseAuth.instance.currentUser?.uid,
          id: docRef.id,
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          profilePhoto:
          (userDoc.data()! as Map<String, dynamic>)['profile_picture'],
          thumbnails: thumbNails);
     await docRef.set(videoModel.toJson());




      // await FirebaseFirestore.instance.collection("videos").doc("Video $len").set(videoModel.toJson());
      return Resource.success(data: true);
    } catch (e) {
      return Resource.failure(error: e.toString());
    }
  }

  Future<String> _uploadVideoToStorage({String? id, String? videoPath,    Function(double progress)? onProgress,
  }) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('videos').child(videoPath!);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));

    // Track upload progress
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      onProgress?.call(progress);
    });


    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  _compressVideo(String videoPath
      ) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }

  _getThumbnails(String videoPath) async {
    final thumbnails = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnails;
  }

  Future<String> _uploadImageToStorage({String? id, String? videoPath,    Function(double progress)? onProgress,}) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('thumbnails').child(videoPath!);
    UploadTask uploadTask = ref.putFile(await _getThumbnails(videoPath));
    // Track upload progress
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      onProgress?.call(progress);
    });
    TaskSnapshot taskSnapshot = await uploadTask;


    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

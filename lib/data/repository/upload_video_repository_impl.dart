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
      {String? songName, String? caption, String? videoPath}) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      var allDocs = await FirebaseFirestore.instance.collection("videos").get();
      int len = allDocs.docs.length;

      String videoUrl =
          await _uploadVideoToStorage(id: 'Video $len', videoPath: videoPath);

      String thumbNails =
          await _uploadImageToStorage(id: "Video $len", videoPath: videoPath);

      VideoModel videoModel = VideoModel(
          userName: (userDoc.data()! as Map<String, dynamic>)['name'],
          uid: FirebaseAuth.instance.currentUser?.uid,
          id: 'Video $len',
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          profilePhoto:
              (userDoc.data()! as Map<String, dynamic>)['profile_picture'],
          thumbnails: thumbNails);

      await FirebaseFirestore.instance.collection("videos").doc("Video $len").set(videoModel.toJson());
      return Resource.success(data: true);
    } catch (e) {
      return Resource.failure(error: e.toString());
    }
  }

  Future<String> _uploadVideoToStorage({String? id, String? videoPath}) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('videos').child(videoPath!);
    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }

  _getThumbnails(String videoPath) async {
    final thumbnails = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnails;
  }

  Future<String> _uploadImageToStorage({String? id, String? videoPath}) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('thumbnails').child(videoPath!);
    UploadTask uploadTask = ref.putFile(await _getThumbnails(videoPath));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

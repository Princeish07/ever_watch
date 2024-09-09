import 'package:ever_watch/domain/repository/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/user_model.dart';

class ProfileRepositoryImpl extends ProfileRepository {

  Stream<Resource<List<VideoModel>>>? getVideoListOfParticularUser(
      {String? uid}) {
    try {
      return FirebaseFirestore.instance
          .collection('videos')
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((video) {
        List<VideoModel>? videoList = video.docs.map((doc) {
          return VideoModel().fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
        return Resource.success(data: videoList);
      });
    } catch (e) {
      print(e);
      return Stream.value(Resource.failure(error: e.toString()));
    }
  }

  Stream<Resource<UserModel>>? getUserDetails({String? uid}){
    try {
      return FirebaseFirestore.instance.collection("users").doc(uid).snapshots().map((usersModel){
            UserModel userModel = UserModel().fromMap(usersModel.data() as Map<String,dynamic>);
            return Resource.success(data: userModel);

          });
    } catch (e) {
      print(e);
      return Stream.value(Resource.failure(error: e.toString()));
    }
  }
}

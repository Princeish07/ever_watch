import 'package:ever_watch/domain/repository/comment_repository.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ever_watch/data/model/comment_model.dart';
class CommentRepositoryImpl extends CommentRepository{
  Stream<Resource<List<CommentModel>>> getCommentList() {
    return Stream.value(Resource.success());
  }

  Future<Resource<bool>> sendComment({String? comment,String? postId}) async{
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid.toString()).get();
      var allDocs = await FirebaseFirestore.instance.collection("videos").doc(postId).collection("comments").get();
      int len = allDocs.docs.length;
      // return
      CommentModel commentModel = CommentModel(username:( userDoc.data() as Map<String,dynamic>)['name'],comment: comment,datePublished: DateTime.now(),likes: [],profilePhoto: ( userDoc.data() as Map<String,dynamic>)['profile_picture'],uid: FirebaseAuth.instance.currentUser?.uid.toString(),id: 'Comment $len');

      await FirebaseFirestore.instance.collection('videos').doc(postId).collection('comments').doc('Comment $len').set(commentModel.toJson());

      // FirebaseFirestore.instance.collection("comments").doc(postId).
      return Resource.success(data: true);
    } catch (e) {
      return Resource.failure(error: e.toString());
    }
  }
}


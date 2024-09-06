import 'package:ever_watch/domain/repository/comment_repository.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ever_watch/data/model/comment_model.dart';

class CommentRepositoryImpl extends CommentRepository {
  Stream<Resource<List<CommentModel>>> getCommentList({String? postId}) {
    try {
      return FirebaseFirestore.instance.collection("videos").doc(postId)
          .collection('comments').snapshots()
          .map((snapshot) {
        List<CommentModel> commentList = snapshot.docs.map((doc) {
          return CommentModel().fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        return Resource.success(data: commentList);
      });
    } catch (e) {
      return Stream.value(Resource.failure(error: e.toString()));
    }
    return Stream.value(Resource.success());
  }

  Future<Resource<bool>> sendComment({String? comment, String? postId}) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
          "users").doc(FirebaseAuth.instance.currentUser?.uid.toString()).get();
      var allDocs = await FirebaseFirestore.instance.collection("videos").doc(
          postId).collection("comments").get();
      int len = allDocs.docs.length;
      // return
      CommentModel commentModel = CommentModel(
          username: (userDoc.data() as Map<String, dynamic>)['name'],
          comment: comment,
          datePublished: DateTime.now(),
          likes: [],
          profilePhoto: (userDoc.data() as Map<String,
              dynamic>)['profile_picture'],
          uid: FirebaseAuth.instance.currentUser?.uid.toString(),
          id: 'Comment $len');

      await FirebaseFirestore.instance.collection('videos').doc(postId)
          .collection('comments').doc('Comment $len')
          .set(commentModel.toJson());

      DocumentSnapshot doc = await FirebaseFirestore.instance.collection(
          "videos").doc(postId).get();
      await FirebaseFirestore.instance.collection("videos").doc(postId).update({
        'comment_count': (doc.data() as Map<String, dynamic>)['comment_count'] +
            1
      });

      return Resource.success(data: true);
    } catch (e) {
      return Resource.failure(error: e.toString());
    }
  }

  Future<Resource<bool>> likedComment({String? postId, String? commentId}) async{
  try{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('videos')
        .doc(postId).collection('comments')
        .doc(commentId).get();
    var uid = FirebaseAuth.instance.currentUser?.uid?.toString();
    if ((snapshot.data() as Map<String,dynamic>)["likes"].contains(uid)){
    await  FirebaseFirestore.instance.collection('videos').doc(postId).collection('comments').doc(commentId).update({'likes':FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])});
    }else{
    await FirebaseFirestore.instance.collection('videos').doc(postId).collection('comments').doc(commentId).update({'likes':FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])});

    }

    return Resource.success(data: true);
  }catch(e){

    return Resource.failure(error: e.toString());

  }
  }
}


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
      // Get user data for the current user
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid.toString())
          .get();

      // Get current comment count for the video post
      DocumentReference videoDocRef = FirebaseFirestore.instance
          .collection("videos")
          .doc(postId);

      DocumentSnapshot videoDoc = await videoDocRef.get();
      int currentCommentCount = (videoDoc.data() as Map<String, dynamic>)['comment_count'];

      // Get the length of current comments to generate a unique comment ID
      var allDocs = await videoDocRef.collection("comments").get();
      int len = allDocs.docs.length;

      // Create the comment model
      CommentModel commentModel = CommentModel(
        username: (userDoc.data() as Map<String, dynamic>)['name'],
        comment: comment,
        datePublished: DateTime.now(),
        likes: [],
        profilePhoto: (userDoc.data() as Map<String, dynamic>)['profile_picture'],
        uid: FirebaseAuth.instance.currentUser?.uid.toString(),
        id: 'Comment $len',
      );

      // Start a Firestore batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Create a reference for the comment document
      DocumentReference commentDocRef = videoDocRef
          .collection('comments')
          .doc('Comment $len');

      // Add the comment to the comments sub-collection
      batch.set(commentDocRef, commentModel.toJson());

      // Update the comment count in the 'videos' collection
      batch.update(videoDocRef, {'comment_count': currentCommentCount + 1});

      // Commit the batch operation
      await batch.commit();

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


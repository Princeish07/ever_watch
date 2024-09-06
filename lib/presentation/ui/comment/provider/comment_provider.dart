import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/presentation/ui/comment/state/comment_state.dart';
import 'package:ever_watch/domain/repository/comment_repository.dart';
import 'package:ever_watch/data/repository/comment_repository_impl.dart';
import 'package:ever_watch/data/model/comment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CommentProvider extends StateNotifier<CommentState>{
  CommentRepository? commentRepository;

  CommentProvider({this.commentRepository}):super(CommentState());

  sendComment({String? id,String? comment}) async{
   var result =  await  commentRepository?.sendComment(comment:comment,postId: id);
   state = state.copyWith(commentAddedResult: result);
  }

  getCommentList({String? id}){
    commentRepository?.getCommentList(postId:id)?.listen((Resource<List<CommentModel>> commentList) {
      state = state.copyWith(commentList: commentList);
    });
  }

  likeComment({String? postId,String? commentId}){
    commentRepository?.likedComment(postId: postId,commentId: commentId);

    // Find the video in the current list by id and modify the likes
    List<CommentModel>? updatedCommentList = state.commentList?.data?.map((video) {
      if (video.id == commentId) {
        // Check if the current user's UID is already in the likes list
        if (video.likes?.contains(FirebaseAuth.instance.currentUser?.uid)==true) {
          // If the user has already liked the video, remove their UID (unlike)
          video.likes?.remove(FirebaseAuth.instance.currentUser?.uid);
        } else {
          // If the user hasn't liked the video, add their UID (like)
          video.likes?.add(FirebaseAuth.instance.currentUser?.uid);
        }
      }
      return video; // Return the video (modified or not)
    }).toList();

    state = state.copyWith(commentList: Resource.success(data: updatedCommentList));
  }

}

final commentProvider = StateNotifierProvider<CommentProvider,CommentState>((ref){

  return CommentProvider(commentRepository: CommentRepositoryImpl());
});
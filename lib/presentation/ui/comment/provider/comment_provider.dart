import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/presentation/ui/comment/state/comment_state.dart';
import 'package:ever_watch/domain/repository/comment_repository.dart';
import 'package:ever_watch/data/repository/comment_repository_impl.dart';
class CommentProvider extends StateNotifier<CommentState>{
  CommentRepository? commentRepository;

  CommentProvider({this.commentRepository}):super(CommentState());

  sendComment({String? id,String? comment}) async{
 var result =  await  commentRepository?.sendComment(comment:comment,postId: id);
   state = state.copyWith(commentList: Resource.success(data: []),commentAddedResult: result);
  }

}

final commentProvider = StateNotifierProvider<CommentProvider,CommentState>((ref){

  return CommentProvider(commentRepository: CommentRepositoryImpl());
});
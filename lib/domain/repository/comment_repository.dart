import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';
import 'package:ever_watch/data/model/comment_model.dart';
abstract class CommentRepository{
  Stream<Resource<List<CommentModel>>> getCommentList();

  Future<Resource<bool>> sendComment({String? comment,String? postId});
}
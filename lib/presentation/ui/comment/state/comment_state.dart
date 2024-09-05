import 'dart:core';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/comment_model.dart';

class CommentState {
  Resource<List<CommentModel>>? commentList;
  Resource<bool>? commentAddedResult;

  CommentState({this.commentList, this.commentAddedResult});

  CommentState copyWith(
      {Resource<List<CommentModel>>? commentList,
      Resource<bool>? commentAddedResult}) {
    return CommentState(
        commentList: commentList ?? this.commentList,
        commentAddedResult: commentAddedResult ?? this.commentAddedResult);
  }
}

import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/video_model.dart';

abstract class VideoRepository{
  Future<Resource<List<VideoModel>>>? getVideoList();

  Resource<bool>? resetPagination();

  Future<Resource<bool>> likeThePost({String? id});

  Future<Resource<bool>>? sendFollowRequest({String? otherUserId});

  Future<Resource<bool>>? unsendFollowRequest({String? otherUserId});

  Future<Resource<bool>>? unFollowUser({String? otherUserId});

}
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/video_model.dart';

abstract class VideoRepository{
  Stream<Resource<List<VideoModel>>>? getVideoListStream();

  Future<Resource<bool>> likeThePost({String? id});
}
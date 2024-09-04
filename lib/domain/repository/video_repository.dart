import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/video_model.dart';

abstract class VideoRepository{
  Future<Resource<List<VideoModel>>>? getVideoList();
}
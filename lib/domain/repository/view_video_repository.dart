import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/video_model.dart';
    import 'dart:async';
    import 'dart:core';
abstract class ViewVideoRepository{
  Stream<Resource<VideoModel>>? getViewDetails({String? videoId});
}
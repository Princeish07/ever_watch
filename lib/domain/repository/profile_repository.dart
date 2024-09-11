import 'dart:async';
import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';
import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/data/model/user_model.dart';

abstract class ProfileRepository {
  Stream<Resource<List<VideoModel>>>? getVideoListOfParticularUser({String? uid});

  Stream<Resource<UserModel>>? getUserDetails({String? uid});
  Future<Resource<bool>>? deleteVideo({String? videoId});

}
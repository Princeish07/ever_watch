import 'dart:core';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/core/other/resource.dart';

abstract class FollowRequestRepository {
  Stream<Resource<List<UserModel>>>? getFollowRequestList({String? uid});

  Future<Resource<bool>> rejectFollowRequest({required String followerUserId});

  Future<Resource<bool>> acceptFollowRequest({ required String followerUserId});

}
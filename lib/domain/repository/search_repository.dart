import 'package:ever_watch/core/other/resource.dart';
import 'dart:core';
import 'package:ever_watch/data/model/user_model.dart';
import 'dart:async';
abstract class SearchRepository{
  Stream<Resource<List<UserModel>>>? searchUserList({String? userName});
}
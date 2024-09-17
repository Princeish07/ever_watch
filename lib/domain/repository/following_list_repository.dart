import '../../core/other/resource.dart';
import '../../data/model/user_model.dart';

abstract class FollowingListRepository{
  Stream<Resource<List<UserModel>>>? getFollowRequestList({String? uid});
  Stream<Resource<List<UserModel>>>? getFollowerRequestList({String? uid});

}
import 'package:ever_watch/presentation/ui/follow_request/state/follow_request_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/domain/repository/follow_request_repository.dart';
import 'package:ever_watch/data/repository/follow_request_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FollowRequestProvider extends StateNotifier<FollowRequestState> {
  FollowRequestRepository? followRequestRepository;
  FollowRequestProvider({this.followRequestRepository}):super(FollowRequestState());


  fetchFollowRequestList(){
    followRequestRepository?.getFollowRequestList(uid: FirebaseAuth.instance?.currentUser?.uid!.toString())?.listen((userModel){
      state = state.copyWith(followRequestList: userModel);
    });
  }


}

final followRequestProvider = StateNotifierProvider<FollowRequestProvider,FollowRequestState>((ref){
  return FollowRequestProvider(followRequestRepository: FollowRequestRepositoryImpl());
});


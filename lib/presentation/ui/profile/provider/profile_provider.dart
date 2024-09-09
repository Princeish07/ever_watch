import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/presentation/ui/profile/state/profile_state.dart';
import 'package:ever_watch/data/repository/profile_repository_impl.dart';
import 'package:ever_watch/domain/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ever_watch/core/other/resource.dart';
class ProfileProvider extends StateNotifier<ProfileState>{
  ProfileRepository? repository;

  ProfileProvider({this.repository}):super(ProfileState());

  getVideoList(){
    // state = state.copyWith(videoList: Resource.loading());
    repository?.getVideoListOfParticularUser(uid: FirebaseAuth.instance.currentUser!.uid?.toString())?.listen((list){
      state = state.copyWith(videoList: list);
    });

  }

  getUserDetails(){
    // state = state.copyWith(videoList: Resource.loading());

    repository?.getUserDetails(uid: FirebaseAuth.instance.currentUser!.uid?.toString())?.listen((userDetail){
      state = state.copyWith(userModel: userDetail);
    });

  }
}

final profileProvider = StateNotifierProvider<ProfileProvider,ProfileState>((ref){
  return ProfileProvider(repository: ProfileRepositoryImpl());
});
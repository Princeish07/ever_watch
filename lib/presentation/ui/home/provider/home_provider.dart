import 'package:ever_watch/presentation/ui/add_video/widgets/add_video_screen.dart';
import 'package:ever_watch/presentation/ui/video/widgets/video_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/home_state.dart';
import 'package:ever_watch/presentation/ui/search/widgets/search_screen.dart';
import 'package:ever_watch/presentation/ui/profile/widgets/profile_screen.dart';

class HomeProvider extends StateNotifier<HomeState>{
  HomeProvider():super(HomeState(currentPage: 0));
  List<Widget> mainPages = [

    VideoScreen(),
    SearchScreen(),
    AddVideoScreen(),
    Text("Messages",style: TextStyle(color: Colors.black),),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser?.uid,),

  ];


  updatePages({int? index}){

    state = state.copy(currentPage: index);

  }

}

final homeProvider = StateNotifierProvider<HomeProvider,HomeState>((ref){
  return HomeProvider();
});
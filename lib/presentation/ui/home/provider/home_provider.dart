import 'package:ever_watch/presentation/ui/add_video/widgets/add_video_screen.dart';
import 'package:ever_watch/presentation/ui/video/widgets/video_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/home_state.dart';

class HomeProvider extends StateNotifier<HomeState>{
  HomeProvider():super(HomeState(currentPage: 0));
  List<Widget> mainPages = [

    VideoScreen(),
    Text("Search",style: TextStyle(color: Colors.black),),
    AddVideoScreen(),
    Text("Messages",style: TextStyle(color: Colors.black),),
    Text("Profile",style: TextStyle(color: Colors.black),),

  ];


  updatePages({int? index}){

    state = state.copy(currentPage: index);

  }

}

final homeProvider = StateNotifierProvider<HomeProvider,HomeState>((ref){
  return HomeProvider();
});
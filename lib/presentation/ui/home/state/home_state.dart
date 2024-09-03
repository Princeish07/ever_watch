import 'package:ever_watch/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeState{



 int? currentPage;

  HomeState({this.currentPage});

  HomeState copy({int? currentPage}){
    return HomeState(currentPage: currentPage ?? this.currentPage);

  }

}
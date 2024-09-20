import 'package:ever_watch/core/other/general_utils.dart';
import 'package:ever_watch/presentation/common_widgets/custom_icon.dart';
import 'package:ever_watch/presentation/ui/home/provider/home_provider.dart';
import 'package:ever_watch/presentation/ui/login/widgets/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:core';
import 'package:ever_watch/core/other/resource.dart';

import '../../../common_widgets/common_bottom_navigation_bar.dart';
import '../../../theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  int currentIndex=0;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      // appBar: AppBar(actions: [IconButton(onPressed: () async {
    //     await FirebaseAuth.instance.signOut();
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    //
    // }, icon: const Icon(Icons.logout))],),
      bottomNavigationBar:
      CommonBottomNavigationBar(onTap: (index) async {
        await ref.read(homeProvider.notifier).updatePages(index: index);

      },),
      body: Container(
        color: Colors.white,
        child:IndexedStack(
          index: homeState.currentPage!, // Display the page corresponding to the current index
          children: ref.read(homeProvider.notifier).mainPages, // List of all pages
        ),
      ),
    );
  }
}

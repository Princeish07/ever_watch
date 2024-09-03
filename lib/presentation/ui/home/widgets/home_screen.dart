import 'package:ever_watch/core/other/general_utils.dart';
import 'package:ever_watch/presentation/common_widgets/custom_icon.dart';
import 'package:ever_watch/presentation/ui/home/provider/home_provider.dart';
import 'package:ever_watch/presentation/ui/login/widgets/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/common_bottom_navigation_bar.dart';
import '../../../theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  int currentIndex=0;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(actions: [IconButton(onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

      }, icon: const Icon(Icons.logout))],),
      bottomNavigationBar:
      CommonBottomNavigationBar(onTap: (index) async {
        await ref.read(homeProvider.notifier).updatePages(index: index);

      },),
      body: Container(
        color: Colors.white,
        child: Center(
          child: ref.read(homeProvider.notifier).mainPages[homeState.currentPage!]

        ),
      ),
    );
  }
}

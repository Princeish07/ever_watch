import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:ever_watch/presentation/ui/login/widgets/login_screen.dart';
import 'package:ever_watch/presentation/ui/profile/provider/profile_provider.dart';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/presentation/common_widgets/common_loader.dart';
import 'package:ever_watch/presentation/ui/profile/widgets/profile_details.dart';
import 'package:ever_watch/presentation/ui/profile/widgets/user_video_list.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  String? uid;

  ProfileScreen({super.key, this.uid});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  @override
  void  initState(){
    super.initState();
    ref.read(profileProvider.notifier).getVideoList();
    ref.read(profileProvider.notifier).getUserDetails();

  }


  @override
  Widget build(BuildContext context) {
    var state = ref.watch(profileProvider);
    return Scaffold(
        backgroundColor: AppColors.mainBgColor,
        appBar: AppBar(
          centerTitle: true,
          leading: Icon(Icons.person_add_alt_outlined),
          title: Text(
            state.userModel?.data?.name ?? "rivaanranwat", style: TextStyle(fontWeight: FontWeight.w500),),
          actions: [
            Icon(Icons.more_horiz)
          ],
        ),
        body: SafeArea(child:
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15,),
              ProfileDetails(),
              SizedBox(height: 10,),
              UserVideoList()

            ],
          ),
        )
        )
    );
  }
}

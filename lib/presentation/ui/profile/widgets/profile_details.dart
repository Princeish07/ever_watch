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
import 'package:ever_watch/core/other/general_utils.dart';

class ProfileDetails extends ConsumerStatefulWidget {
  const ProfileDetails({super.key});

  @override
  ConsumerState<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends ConsumerState<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(profileProvider);
    ref.listen(profileProvider, (prev,next){
      if(next.userModel?.status==Status.FAILURE) {
        showToast(next.userModel!.error!.toString());
      }
    });
    return Stack(
      children: [
        if (state.userModel?.status == Status.SUCCESS) ...[
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: state.userModel!.data!.profilePicture.toString(),
                    height: 100,
                    width: 100,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  Text(
                    '10',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Following',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ]),
                Container(
                  color: Colors.black54,
                  width: 1,
                  height: 15,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                ),
                Column(children: [
                  Text(
                    '5K',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Followers',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ]),
                Container(
                  color: Colors.black54,
                  width: 1,
                  height: 15,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                ),
                Column(children: [
                  Text(
                    '10',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Following',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ])
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 140,
              height: 47,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.5))),
              child: Center(
                child: InkWell(
                  onTap: () async {
                     FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ]),
        ] else if (state.userModel?.status==null || state.userModel?.status == Status.LOADING) ...[
          CommonLoader()
        ]
      ],
    );
  }
}

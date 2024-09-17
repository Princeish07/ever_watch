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

import '../../following_list/widgets/follwing_list.dart';

class ProfileDetails extends ConsumerStatefulWidget {
  String? uid;

  ProfileDetails({super.key, this.uid});

  @override
  ConsumerState<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends ConsumerState<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(profileProvider);
    ref.listen(profileProvider, (prev, next) {
      if (next.userModel?.status == Status.FAILURE) {
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
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> FollwingList(isFollowingList: true,)));
                  },
                  child: Column(children: [
                    Text(
                      state.userModel!.data!.following!.length.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Following',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ]),
                ),
                Container(
                  color: Colors.black54,
                  width: 1,
                  height: 15,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> FollwingList(isFollowingList: false,)));

                  },
                  child: Column(children: [
                    Text(
                      state.userModel!.data!.followers!.length.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Followers',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ]),
                ),
                Container(
                  color: Colors.black54,
                  width: 1,
                  height: 15,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                ),
                 Column(children: [
                  Text(
                    state.likes.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Likes',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ])
              ],
            ),
            if (widget.uid ==
                FirebaseAuth.instance.currentUser?.uid.toString()) ...[
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 140,
                height: 47,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.5))),
                child: Center(
                  child: InkWell(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ] else ...[
              if (state.userModel?.data?.receivedRequests
                          ?.contains(FirebaseAuth.instance.currentUser?.uid) !=
                      true &&
                  state.userModel?.data?.followers
                          ?.contains(FirebaseAuth.instance.currentUser?.uid) !=
                      true) ...[
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 140,
                  height: 47,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue)),
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        ref.read(profileProvider.notifier).sendFollowRequest(
                            otherUserId: state.userModel?.data?.uid.toString());
                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Follow",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.add_circle_outlined,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ] else if (state.userModel?.data?.followers
                      ?.contains(FirebaseAuth.instance.currentUser?.uid) ==
                  true) ...[
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 140,
                  height: 47,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green)),
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        // await FirebaseAuth.instance.signOut();
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => LoginScreen()));

                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("UnFollowing !"),
                            content:
                                const Text("Do you really want to unfollow"),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: AppColors.borderColor, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(14),
                                        alignment: Alignment.center, // Center text in the button
                                        child: const Text(
                                          "No",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8), // Space between the buttons
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        ref.read(profileProvider.notifier).unFollowRequest(
                                            otherUserId: state.userModel?.data?.uid);
                                        Navigator.of(ctx).pop();

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors().mainButtonColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(14),
                                        alignment: Alignment.center, // Center text in the button
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        );
                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Followed",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ] else if(state.userModel?.data?.sentRequests
                  ?.contains(FirebaseAuth.instance.currentUser?.uid) ==
                  true) ...[
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 140,
                  height: 47,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey)),
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("Undo Request!"),
                            content: const Text("Do you really want to undo the follow request"),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: AppColors.borderColor, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(14),
                                        alignment: Alignment.center, // Center text in the button
                                        child: const Text(
                                          "No",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8), // Space between the buttons
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        ref.read(profileProvider.notifier).unsendFollowRequest(
                                            otherUserId: state.userModel?.data?.uid);
                                        Navigator.of(ctx).pop();

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors().mainButtonColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(14),
                                        alignment: Alignment.center, // Center text in the button
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );

                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Request Sent",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.watch_later_sharp,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]
            ]
          ]),
        ] else if (state.userModel?.status == null ||
            state.userModel?.status == Status.LOADING) ...[
          const CommonLoader()
        ]
      ],
    );
  }
}

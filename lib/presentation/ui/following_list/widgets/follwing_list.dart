import 'package:ever_watch/presentation/ui/following_list/provider/following_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/other/general_utils.dart';
import '../../../../core/other/resource.dart';
import '../../../common_widgets/common_loader.dart';
import '../../../theme/app_colors.dart';
import '../../profile/widgets/profile_screen.dart';

class FollwingList extends ConsumerStatefulWidget {
  bool? isFollowingList;
   FollwingList({super.key,this.isFollowingList});

  @override
  ConsumerState<FollwingList> createState() => _FollwingListState();
}

class _FollwingListState extends ConsumerState<FollwingList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(followingProvider.notifier).getFollowingList(
          isFollowingList: widget.isFollowingList);
    });
  }

  @override
  Widget build(BuildContext context) {

    var state = ref.watch(followingProvider);

    ref.listen(followingProvider, (prev, next) {
      if (next.followingList?.status == Status.FAILURE) {
        showToast(next.followingList!.error.toString());
      }

    });

    return Scaffold(
      backgroundColor: AppColors.mainBgColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: widget.isFollowingList==true ? Text("Following List",style: TextStyle(fontSize: 18, color: Colors.white),) : Text("Followers List",style: TextStyle(fontSize: 18, color: Colors.white),),
      ),
      body: Stack(
        children: [
          if (state.followingList == null ||
              (state.followingList?.data == null ||
                  state.followingList?.data!.isEmpty == true) &&
                  state.followingList?.status == Status.SUCCESS) ...[
            Center(
              child: Text(
                "No user found",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )
          ] else if (state.followingList?.status == Status.SUCCESS) ...[
            Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListView.builder(
                    itemCount: state.followingList?.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    uid: state.followingList!
                                        .data![index].uid,
                                  )));
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: Image.asset(
                                  'assets/logo/men_image.jpg',
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(45),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.followingList!.data![index].name!
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        state
                                            .followingList!.data![index].email!
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  )),
                              if (state.followingList!.data![index]
                                  .receivedRequests
                                  ?.contains(FirebaseAuth
                                  .instance.currentUser?.uid) !=
                                  true &&
                                  state.followingList!.data![index]
                                      .followers
                                      ?.contains(FirebaseAuth
                                      .instance.currentUser?.uid) !=
                                      true) ...[
                                ElevatedButton(
                                  onPressed: () {

                                    // ref.read(followingProvider.notifier).sentFollowRequest(otherUserId: state.searchedUserResult!.data![index].uid);
                                  },
                                  style: ButtonStyle(
                                      padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(10)),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue)),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Follow",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.add_circle_outlined,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ] else if (state.followingList!.data![index]
                                  .receivedRequests
                                  ?.contains(FirebaseAuth
                                  .instance.currentUser?.uid) ==
                                  true) ...[
                                ElevatedButton(
                                  onPressed: () {
                                    // ref.read(searchProvider.notifier).unsendFollowRequest(otherUserId: state.searchedUserResult!.data![index].uid);

                                  },
                                  style: ButtonStyle(
                                      padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(10)),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey)),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Request Sent",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.access_time_filled_rounded,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ] else ...[
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                      padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(10)),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppColors().mainButtonColor!)),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Message",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.message,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    }))
          ] else if (state.followingList?.status == Status.LOADING) ...[
            CommonLoader()
          ]
        ],
      ),
    );
  }
}

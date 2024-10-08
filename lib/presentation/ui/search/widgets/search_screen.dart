import 'package:ever_watch/presentation/ui/profile/provider/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ever_watch/presentation/theme/app_colors.dart';
import 'package:ever_watch/presentation/ui/search/provider/search_provider.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/presentation/common_widgets/common_loader.dart';
import 'package:ever_watch/core/other/general_utils.dart';
import 'package:ever_watch/presentation/ui/profile/widgets/profile_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   ref.read(searchProvider.notifier).searchUser(userName: "");
  // }


  @override
  Widget build(BuildContext context) {
    var state = ref.watch(searchProvider);
    ref.listen(searchProvider, (prev, next) {
      if (next.searchedUserResult?.status == Status.FAILURE) {
        showToast(next.searchedUserResult!.error.toString());
      }
      if(next.errorMessage?.isNotEmpty==true) {
        showToast(next.errorMessage.toString());
      }
    });

    return Scaffold(
      backgroundColor: AppColors.mainBgColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: TextFormField(
          decoration: const InputDecoration(
              filled: false,
              hintText: "Search",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintStyle: TextStyle(fontSize: 18, color: Colors.white),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))),
          onFieldSubmitted: (value) {
            ref.read(searchProvider.notifier).searchUser(userName: value);
          },
        ),
      ),
      body: Stack(
        children: [
          if (state.searchedUserResult == null ||
              (state.searchedUserResult?.data == null ||
                      state.searchedUserResult?.data!.isEmpty == true) &&
                  state.searchedUserResult?.status == Status.SUCCESS) ...[
            Center(
              child: Text(
                "Search for users!",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )
          ] else if (state.searchedUserResult?.status == Status.SUCCESS) ...[
            Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListView.builder(
                    itemCount: state.searchedUserResult?.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        uid: state.searchedUserResult!
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
                                    state.searchedUserResult!.data![index].name!
                                        .toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    state
                                        .searchedUserResult!.data![index].email!
                                        .toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )),
                              if (state.searchedUserResult!.data![index]
                                          .receivedRequests
                                          ?.contains(FirebaseAuth
                                              .instance.currentUser?.uid) !=
                                      true &&
                                  state.searchedUserResult!.data![index]
                                          .followers
                                          ?.contains(FirebaseAuth
                                              .instance.currentUser?.uid) !=
                                      true) ...[
                                ElevatedButton(
                                  onPressed: () {

                                    ref.read(searchProvider.notifier).sentFollowRequest(otherUserId: state.searchedUserResult!.data![index].uid);
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
                              ] else if (state.searchedUserResult!.data![index]
                                      .receivedRequests
                                      ?.contains(FirebaseAuth
                                          .instance.currentUser?.uid) ==
                                  true) ...[
                                ElevatedButton(
                                  onPressed: () {
                                    ref.read(searchProvider.notifier).unsendFollowRequest(otherUserId: state.searchedUserResult!.data![index].uid);

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
          ] else if (state.searchedUserResult?.status == Status.LOADING) ...[
            CommonLoader()
          ]
        ],
      ),
    );
  }
}

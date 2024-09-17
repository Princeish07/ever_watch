import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/user_model.dart';
import 'package:ever_watch/domain/repository/following_list_repository.dart';

class FollowingListRepositoryImpl extends FollowingListRepository{
  @override
  Stream<Resource<List<UserModel>>>? getFollowRequestList({String? uid}) async* {
    try {
      // Listen to the user's document for real-time updates
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(uid);

      await for (DocumentSnapshot userDoc in userDocRef.snapshots()) {
        if (userDoc.exists) {
          // Ensure receivedRequests field exists and is a valid list
          List<dynamic> followRequestIds = [];
          if (userDoc.data() != null && (userDoc.data() as Map<String,dynamic>).containsKey('following')==true) {
            followRequestIds = List<String>.from((userDoc.data() as Map<String,dynamic>)['following']);
          }

          if (followRequestIds.isEmpty) {
            yield Resource.success(data:[]); // Emit success state with empty list
            continue;
          }

          // Fetch all requested user documents concurrently
          List<UserModel> followRequestsDetails = await Future.wait(
            followRequestIds.map((followUserId) async {
              DocumentSnapshot userDetails = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(followUserId)
                  .get();

              if (userDetails.exists) {
                // Convert Firestore document data to UserModel
                return UserModel().fromMap(userDetails.data() as Map<String,dynamic>);
              }
              return UserModel();
            }),
          );

          // Remove any null results and emit success state with user details
          followRequestsDetails.removeWhere((user) => user == null);

          yield Resource.success(data:followRequestsDetails); // Emit success state
        } else {
          yield Resource.success(data:[]); // Emit success state with empty list if user doesn't exist
        }
      }
    } catch (e) {
      yield Resource.failure(error: 'Error fetching follow requests: $e'); // Emit error state
    }
  }
  Stream<Resource<List<UserModel>>>? getFollowerRequestList({String? uid}) async* {
    try {
      // Listen to the user's document for real-time updates
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(uid);

      await for (DocumentSnapshot userDoc in userDocRef.snapshots()) {
        if (userDoc.exists) {
          // Ensure receivedRequests field exists and is a valid list
          List<dynamic> followRequestIds = [];
          if (userDoc.data() != null && (userDoc.data() as Map<String,dynamic>).containsKey('followers')==true) {
            followRequestIds = List<String>.from((userDoc.data() as Map<String,dynamic>)['followers']);
          }

          if (followRequestIds.isEmpty) {
            yield Resource.success(data:[]); // Emit success state with empty list
            continue;
          }

          // Fetch all requested user documents concurrently
          List<UserModel> followRequestsDetails = await Future.wait(
            followRequestIds.map((followUserId) async {
              DocumentSnapshot userDetails = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(followUserId)
                  .get();

              if (userDetails.exists) {
                // Convert Firestore document data to UserModel
                return UserModel().fromMap(userDetails.data() as Map<String,dynamic>);
              }
              return UserModel();
            }),
          );

          // Remove any null results and emit success state with user details
          followRequestsDetails.removeWhere((user) => user == null);

          yield Resource.success(data:followRequestsDetails); // Emit success state
        } else {
          yield Resource.success(data:[]); // Emit success state with empty list if user doesn't exist
        }
      }
    } catch (e) {
      yield Resource.failure(error: 'Error fetching follow requests: $e'); // Emit error state
    }
  }

}
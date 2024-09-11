import 'package:ever_watch/domain/repository/follow_request_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/user_model.dart';

class FollowRequestRepositoryImpl extends FollowRequestRepository{
  Stream<Resource<List<UserModel>>>? getFollowRequestList({String? uid}) async* {
    try {
      // Listen to the user's document for real-time updates
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(uid?.toString());

      await for (DocumentSnapshot userDoc in userDocRef.snapshots()) {
        if (userDoc.exists) {
          // Get the followRequest field, which is a list of user IDs
          List<dynamic> followRequestIds = userDoc['receivedRequests'] ?? [];

          if (followRequestIds.isEmpty) {
            yield Resource.success(data: []); // Emit success state with empty list
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

          yield Resource.success(data:followRequestsDetails!); // Emit success state
        } else {
          yield Resource.success(data:[]); // Emit success state with empty list if user doesn't exist
        }
      }
    } catch (e) {
      yield Resource.failure(error:'Error fetching follow requests: $e'); // Emit error state
    }

  }
}
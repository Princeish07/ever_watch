import 'package:ever_watch/domain/repository/follow_request_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/core/other/resource.dart';
import 'package:ever_watch/data/model/user_model.dart';

class FollowRequestRepositoryImpl extends FollowRequestRepository{
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
          if (userDoc.data() != null && (userDoc.data() as Map<String,dynamic>)?.containsKey('receivedRequests')==true) {
            followRequestIds = List<String>.from((userDoc.data() as Map<String,dynamic>)['receivedRequests']);
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


  @override
  Future<Resource<bool>> acceptFollowRequest({ required String followerUserId}) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      var currentUserId = FirebaseAuth.instance.currentUser?.uid;

      // Reference to the current user's document
      DocumentReference currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);

      // Reference to the follower's document
      DocumentReference followerUserRef = FirebaseFirestore.instance.collection('users').doc(followerUserId);

      // Step 1: Remove followerUserId from receivedRequests and add to followers
      batch.update(currentUserRef, {
        'receivedRequests': FieldValue.arrayRemove([followerUserId]),
        'followers': FieldValue.arrayUnion([followerUserId]),
      });

      // Step 2: Add currentUserId to the follower's following list
      batch.update(followerUserRef, {
        'following': FieldValue.arrayUnion([currentUserId]),
      });

      // Commit the batch
      await batch.commit();
      return Resource.success(data: true);
    } catch (e) {
      print('Error accepting follow request: $e');
      return Resource.failure(error: e.toString());
    }
  }


  @override
  Future<Resource<bool>> rejectFollowRequest({required String followerUserId}) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      var currentUserId = FirebaseAuth.instance.currentUser?.uid;

      // Reference to the current user's document
      DocumentReference currentUserRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);


      DocumentReference followerUserRef = FirebaseFirestore.instance.collection('users').doc(followerUserId);


      // Step 1: Remove followerUserId from receivedRequests
      batch.update(currentUserRef, {
        'receivedRequests': FieldValue.arrayRemove([followerUserId]),
      });

      batch.update(followerUserRef, {
        'sentRequests': FieldValue.arrayRemove([currentUserId]),
      });

      // Commit the batch
      await batch.commit();
      return Resource.success(data: true);
    } catch (e) {
      print('Error rejecting follow request: $e');
      return Resource.failure(error: e.toString());
    }
  }


}
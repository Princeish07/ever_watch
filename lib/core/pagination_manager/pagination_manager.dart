import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ever_watch/core/other/resource.dart';

class PaginationManager<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath;
  final T Function(Map<String, dynamic>) _fromJson;
  final int _pageSize;

  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  PaginationManager(
      this._collectionPath,
      this._fromJson,
      this._pageSize,
      );

  Stream<Resource<List<T>>> getPaginatedStream() {
    Query query = _firestore.collection(_collectionPath)
        // .orderBy('timestamp') // Adjust sorting according to your needs
        .limit(_pageSize);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    return query.snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        _hasMore = snapshot.docs.length == _pageSize;
      } else {
        _hasMore = false;
      }

      List<T> items = snapshot.docs.map((doc) {
        return _fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return Resource.success(data: items);
    });
  }

  bool get hasMore => _hasMore;

  void reset() {
    _lastDocument = null;
    _hasMore = true;
  }
}

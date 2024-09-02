enum Status { SUCCESS, LOADING, FAILURE }

class Resource<T> {
  final Status status;
  late final T? data;
  final String? message;
  final dynamic error;

  Resource._({required this.status, this.data, this.message, this.error});

  static Resource<T> success<T>({T? data}) {
    return Resource._(status: Status.SUCCESS, data: data);
  }

  static Resource<T> loading<T>({T? data}) {
    return Resource._(status: Status.LOADING, data: data);
  }

  static Resource<T> failure<T>({String? message, dynamic error, T? data}) {
    return Resource._(status: Status.FAILURE, message: message, error: error, data: data);
  }
}

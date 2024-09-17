import '../../core/other/resource.dart';

abstract class UploadVideoRepository{
  Future<Resource<bool>> uploadVideo({String? songName,String? caption,String? videoPath,    Function(double, String)? onProgress, });

  }
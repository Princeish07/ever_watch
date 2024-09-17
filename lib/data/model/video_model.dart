import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class VideoModel {
  String? userName;
  String? uid;
  String? id;
  List? likes;
  int? commentCount;
  int? shareCount;
  String? songName;
  String? caption;
  String? videoUrl;
  String? thumbnails;
  String? profilePhoto;
  // VideoPlayerController? controller;

  VideoModel({this.userName,
    this.uid,
    this.id,
    this.likes,
    this.commentCount,
    this.shareCount,
    this.songName,
    this.caption,
    this.videoUrl,
    this.thumbnails,
    this.profilePhoto,
    // this.controller
  });

  Map<String, dynamic> toJson() =>
      {
        'username': userName,
        'uid': uid,
        "id": id,
        "likes": likes,
        "comment_count": commentCount,
        "share_count": shareCount,
        "song_name": songName,
        "caption": caption,
        "video_url": videoUrl,
        "thumbnails": thumbnails,
        "profile_picture": profilePhoto
      };

  VideoModel fromJson(Map<String, dynamic> map)  {
    return VideoModel(userName: map['username'],
        uid: map["uid"],
        id: map['id'],
        likes: map['likes'],
        commentCount: map["comment_count"],
        shareCount: map['share_count'],
        songName: map['song_name'],
        caption: map['caption'],
        videoUrl: map['video_url'],
        thumbnails: map['thumbnails'],
        profilePhoto: map['profile_picture'],
      // controller: await VideoPlayerController.networkUrl(Uri.parse(map['video_url']))..initialize()

    );
  }
}

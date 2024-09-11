import 'package:riverpod/riverpod.dart';
import 'package:ever_watch/presentation/ui/view_video/state/view_video_state.dart';
import 'package:ever_watch/data/model/video_model.dart';
import 'package:ever_watch/domain/repository/view_video_repository.dart';
import 'package:ever_watch/data/repository/view_video_repository_impl.dart';
import 'package:video_player/video_player.dart';

class ViewVideoProvider extends StateNotifier<ViewVideoState> {
  ViewVideoRepository? viewVideoRepository;

  ViewVideoProvider({this.viewVideoRepository}):super(ViewVideoState(isPlaying: true));

  getVideoDetails({String? videoId}){
    viewVideoRepository?.getViewDetails(videoId:videoId!)?.listen((videoDetailResult){
      state = state.copyWith(videoDetailsResult: videoDetailResult);
    });


  }

  playPauseVideo(VideoPlayerController controller){

    if(state.isPlaying==true){
      controller.pause();
    }else{
      controller.play();
    }
    controller.setLooping(true);
    controller.setVolume(1);
    state = state.copyWith(isPlaying: !state.isPlaying!);
  }

}

final viewVideoProvider = StateNotifierProvider.autoDispose<ViewVideoProvider,ViewVideoState>((ref){
  return ViewVideoProvider(viewVideoRepository: ViewVideoRepositoryImpl());
});
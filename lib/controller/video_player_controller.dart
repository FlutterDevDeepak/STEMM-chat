import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerManager {
  static final VideoPlayerManager _instance = VideoPlayerManager._internal();
  factory VideoPlayerManager() => _instance;
  VideoPlayerManager._internal();

  final Map<String, ChewieController> _controllers = {};

  Future<ChewieController> getControllerForVideo(String videoUrl) async {
    if (_controllers.containsKey(videoUrl)) {
      return _controllers[videoUrl]!;
    }

    final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await videoPlayerController.initialize();

    final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      aspectRatio: videoPlayerController.value.aspectRatio,
    );

    _controllers[videoUrl] = chewieController;
    return chewieController;
  }

  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}

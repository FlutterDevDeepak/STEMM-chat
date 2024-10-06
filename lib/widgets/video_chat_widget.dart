import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:stemm_test/controller/video_player_controller.dart';

class VideoMessageWidget extends StatelessWidget {
  final String videoUrl;

  const VideoMessageWidget({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChewieController>(
      future: VideoPlayerManager().getControllerForVideo(videoUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return SizedBox(
            width: 250,
            height: 200,
            child: Chewie(controller: snapshot.data!),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

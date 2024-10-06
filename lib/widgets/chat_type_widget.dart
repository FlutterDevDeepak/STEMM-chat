import 'package:flutter/material.dart';
import 'package:stemm_test/widgets/document_chat_widget.dart';
import 'package:stemm_test/widgets/video_chat_widget.dart';

class ChatTypeWidget extends StatelessWidget {
  final Map<String, dynamic> messageData;
  const ChatTypeWidget({super.key, required this.messageData});

  @override
  Widget build(BuildContext context) {
    switch (messageData['type']) {
      case 'text':
        return Text(messageData['content']);
      case 'image':
        return Image.network(
          messageData['content'],
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Text('Error loading image');
          },
        );
      case 'video':
        return VideoMessageWidget(videoUrl: messageData['content']);
      case 'document':
        return DocumentMessageWidget(
          fileName: '',
          fileUrl: messageData['content'],
        );
      default:
        return const Text('Unsupported message type');
    }
  }
}

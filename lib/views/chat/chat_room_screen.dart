import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stemm_test/controller/chat_controller.dart';
import 'package:stemm_test/views/profile/profile_screen.dart';
import 'package:stemm_test/widgets/chat_type_widget.dart';

class ChatRoom extends StatefulWidget {
  final String otherUserId;
  final Map<String, dynamic> userData;

  const ChatRoom({super.key, required this.otherUserId, required this.userData});

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {
  late String chatId;

  final chatController = Get.put(ChatController());
  @override
  void initState() {
    super.initState();
    chatId = _getChatId(chatController.currentUser!.uid, widget.otherUserId);
  }

  String _getChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0 ? '$userId1-$userId2' : '$userId2-$userId1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userData['name'] ?? ""),
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Get.to(() =>  ProfileScreen(userData: widget.userData,));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.userData['photoUrl'] ?? ""),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet. Start a conversation!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var messageData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    bool isMe = messageData['senderId'] == chatController.currentUser!.uid;
                    return Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                isMe ? 'You' : 'Other',
                                style: const TextStyle(fontSize: 10),
                              ),
                              ChatTypeWidget(
                                messageData: messageData,
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () async {
                    await chatController.sendMessage(chatId: chatId, recieverId: widget.otherUserId, type: "document");
                  }),
              IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () async {
                    await chatController.sendMessage(chatId: chatId, recieverId: widget.otherUserId, type: "image");
                  }),
              IconButton(
                  icon: const Icon(Icons.videocam),
                  onPressed: () async {
                    await chatController.sendMessage(chatId: chatId, recieverId: widget.otherUserId, type: "video");
                  }),
              Expanded(
                child: TextField(
                  controller: chatController.messageController,
                  decoration: const InputDecoration(hintText: 'Type a message'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  await chatController.sendMessage(chatId: chatId, recieverId: widget.otherUserId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

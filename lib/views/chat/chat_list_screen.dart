import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:stemm_test/views/auth/login_screen.dart';
import 'package:stemm_test/views/chat/chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Chats List'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(LoginScreen());
            },
            icon: const Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('userId', isNotEqualTo: currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var userData = doc.data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    userData['photoUrl'] ?? '',
                  ),
                  radius: 25,
                ),
                title: Text(
                  userData['name'] ?? '',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  userData['email'] ?? '',
                ),
                onTap: () {
                  Get.to(() => ChatRoom(
                        otherUserId: doc.id,
                        userData: userData,
                      ));
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  Future sendMessage({String type = "text", required String chatId, required String recieverId}) async {
    File? file;
    if (type == "text") {
      if (messageController.text.isNotEmpty) {
        await FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
          'senderId': currentUser!.uid,
          'receiverId': recieverId,
          'content': messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'text',
        });
        messageController.clear();
      }
    } else {
      if (type == 'document') {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx'],
        );
        if (result != null) {
          file = File(result.files.single.path!);

          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          Reference storageRef = FirebaseStorage.instance.ref().child('chat_files/$fileName');
          await storageRef.putFile(file);
          String fileUrl = await storageRef.getDownloadURL();
          await FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
            'senderId': currentUser!.uid,
            'receiverId': recieverId,
            'content': fileUrl,
            'timestamp': FieldValue.serverTimestamp(),
            'type': type,
          });
        }
      } else {
        final picker = ImagePicker();
        final XFile? pickedFile;
        if (type == 'video') {
          pickedFile = await picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 30));
        } else {
          pickedFile = await picker.pickImage(source: ImageSource.gallery);
        }
        if (pickedFile != null) {
          file = File(pickedFile.path);
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          Reference storageRef = FirebaseStorage.instance.ref().child('chat_files/$fileName');
          await storageRef.putFile(file);
          String fileUrl = await storageRef.getDownloadURL();
          await FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
            'senderId': currentUser!.uid,
            'receiverId': recieverId,
            'content': fileUrl,
            'timestamp': FieldValue.serverTimestamp(),
            'type': type,
          });
        }
      }
    }
  }
}

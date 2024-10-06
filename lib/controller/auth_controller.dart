import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool showPassword = false.obs;
  RxString profileImage="".obs;
  final auth = FirebaseAuth.instance;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<bool> loginUser() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      isLoading.value = true;
      UserCredential credential = await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      debugPrint(credential.toString());

      if (credential.user!.uid.isNotEmpty) {
        clear();
        pref.setString("email", emailController.text);
        isLoading.value = false;
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      isLoading.value = false;
      if (e.code == 'user-not-found') {
        Get.snackbar("Failed", 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Failed", 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        Get.snackbar("Failed", 'Please enter correct email');
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

 Future<bool> registerUser() async {
    try {
      isLoading.value = true;
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      debugPrint(credential.toString());
      if (credential.user!.uid.isNotEmpty) {
        await saveUserData(credential.user!.uid, emailController.text, nameController.text, passwordController.text.toString());
        isLoading.value = false;
         Get.snackbar("Success", 'Registration successful');
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      isLoading.value = false;
      if (e.code == 'weak-password') {
        Get.snackbar("Failed", 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Failed", 'The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        Get.snackbar("Failed", 'Please enter correct email');
      }
      isLoading.value = false;
      return false;
    } catch (e) {
      Get.snackbar("Failed", e.toString());
      isLoading.value = false;
      return false;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = pickedFile.path;
    }
  }

  saveUserData(String uid, String email, String name, String pass) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('profile_pics').child('$uid.jpg');
      await ref.putFile(File(profileImage.value));
      final profilePicUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'photoUrl': profilePicUrl,
        'userId': uid,
      });
      clear();
    } catch (e) {
      Get.snackbar("Failed", e.toString());
    }
  }

  clear() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    profileImage.value = '';
  }

  togglePass() {
    showPassword.value = !showPassword.value;
  }

  logoutUser() {
    auth.signOut();
  }
}

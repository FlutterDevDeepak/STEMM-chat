import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  const ProfileScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(userData['photoUrl'] ?? ""),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              userData['name'] ?? "",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Email",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              userData['email'] ?? "",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

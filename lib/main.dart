import 'package:flutter/material.dart';
import 'login_page.dart';
import 'appwrite_client.dart'; // Ensure this file correctly initializes appwriteClient

void main() {
  runApp(GroupGamingApp());
}

class GroupGamingApp extends StatelessWidget {
  const GroupGamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Gaming',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(client: appwriteClient), // Ensure LoginPage expects this
    );
  }
}

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'appwrite_client.dart'; // Ensure this file correctly initializes appwriteClient

void main() {
  runApp(const GroupGamingApp());
}

class GroupGamingApp extends StatelessWidget {
  const GroupGamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Gaming',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GradientBackground(child: LoginPage(client: appwriteClient)), // Removed 'const'
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,  // Left to right gradient
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFFFFFF), // White (left side)
            Color(0xFF076585), // Dark Blue-Green (right side)
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make Scaffold background transparent
        body: child, // Display the page inside the gradient
      ),
    );
  }
}

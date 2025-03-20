import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'appwrite_client.dart'; // Ensure this file correctly initializes Appwrite

class PostInvitePage extends StatefulWidget {
  const PostInvitePage({Key? key}) : super(key: key);

  @override
  _PostInvitePageState createState() => _PostInvitePageState();
}

class _PostInvitePageState extends State<PostInvitePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gameController = TextEditingController();
  final TextEditingController _playersController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late Databases databases;

  // 🔹 Replace with your actual database & collection IDs
  final String databaseId = '67d260270026140252d0';
  final String collectionId = '67dc5d7a00342ae4e24a';

  @override
  void initState() {
    super.initState();
    databases = Databases(appwriteClient);
  }

  @override
  void dispose() {
    _gameController.dispose();
    _playersController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _postInvite() async {
    if (_formKey.currentState!.validate()) {
      try {
        await databases.createDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: ID.unique(),
          data: {
            'game': _gameController.text.trim(),
            'players_needed': int.parse(
              _playersController.text.trim(),
            ), // Convert to int
            'description': _descriptionController.text.trim(),
            'timestamp': DateTime.now().toIso8601String(),
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invite posted successfully!')),
        );

        Navigator.pop(context);
      } on AppwriteException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Failed to post invite.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Game Invite')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _gameController,
                decoration: const InputDecoration(labelText: 'Game Name'),
                validator:
                    (value) => value!.isEmpty ? 'Enter a game name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _playersController,
                decoration: const InputDecoration(labelText: 'Players Needed'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Enter number of players' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator:
                    (value) => value!.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _postInvite,
                child: const Text('Post Invite'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'appwrite_client.dart';

class PostInvitePage extends StatefulWidget {
  const PostInvitePage({Key? key}) : super(key: key);

  @override
  _PostInvitePageState createState() => _PostInvitePageState();
}

class _PostInvitePageState extends State<PostInvitePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _playersController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  late Databases databases;
  late Account account;

  final String databaseId = '67d260270026140252d0';
  final String collectionId = '67dc5d7a00342ae4e24a';

  final List<String> _games = [
    "Call of Duty",
    "PUBG",
    "Valorant",
    "League of Legends",
    "Clash Royale",
    "Among Us",
    "Chess",
    "Ludo",
  ];

  final List<String> _languages = [
    "English",
    "Malayalam",
    "Hindi",
    "Tamil",
    "Telugu",
    "Gujarati",
    "French",
    "Spanish",
    "Chinese",
    "Portuguese",
    "Bengali",
    "Russian",
    "Mandarin",
    "Korean",
    "Indonesian",
  ];

  String _selectedGame = "Call of Duty";
  String _selectedLanguage = "English";

  @override
  void initState() {
    super.initState();
    databases = Databases(appwriteClient);
    account = Account(appwriteClient);
  }

  @override
  void dispose() {
    _playersController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _postInvite() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await account.get();
        String username = user.name;
        String userId = user.$id;

        await databases.createDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: ID.unique(),
          data: {
            'game': _selectedGame,
            'players_needed': int.parse(_playersController.text.trim()),
            'join_link': _linkController.text.trim(),
            'username': username,
            'user_id': userId, // Store user ID
            'language': _selectedLanguage, // Store selected language
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
              DropdownButtonFormField<String>(
                value: _selectedGame,
                decoration: const InputDecoration(labelText: 'Select Game'),
                items:
                    _games.map((String game) {
                      return DropdownMenuItem<String>(
                        value: game,
                        child: Text(game),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGame = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: const InputDecoration(labelText: 'Select Language'),
                items:
                    _languages.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
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
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Join Link/Team Link',
                ),
                keyboardType: TextInputType.url,
                validator:
                    (value) =>
                        value!.isEmpty
                            ? 'Enter a valid join link or team link'
                            : null,
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

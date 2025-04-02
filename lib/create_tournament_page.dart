import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'appwrite_client.dart'; // Import the global Appwrite client
import 'package:file_picker/file_picker.dart'; // Import file picker package

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({Key? key}) : super(key: key);

  @override
  _CreateTournamentPageState createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _registrationLinkController =
      TextEditingController();
  final TextEditingController _gameController =
      TextEditingController(); // Controller for game field
  late Databases databases;
  late Storage storage;
  late Account account;

  bool isUploading = false;
  bool isImageUploaded = false; // Track if image has been uploaded
  String? _imageFileId;
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  String? _userId; // To store the user ID
  String? _userName; // To store the user name

  final String databaseId = '67d260270026140252d0';
  final String collectionId = '67e7ecb70015b4466647';

  @override
  void initState() {
    super.initState();
    databases = Databases(appwriteClient);
    storage = Storage(appwriteClient);
    account = Account(appwriteClient);
    _fetchUserDetails(); // Fetch user ID and user name
  }

  Future<void> _fetchUserDetails() async {
    try {
      final User user = await account.get(); // Get authenticated user details
      setState(() {
        _userId = user.$id; // Store user ID
        _userName = user.name; // Store user name
      });
    } catch (e) {
      print('Failed to fetch user details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch user details!')),
      );
    }
  }

  Future<void> _selectAndUploadImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final fileBytes = result.files.single.bytes;
        final fileName = result.files.single.name;

        setState(() {
          _selectedFileBytes = fileBytes;
          _selectedFileName = fileName;
        });

        if (fileBytes != null) {
          setState(() {
            isUploading = true;
          });

          final uploadResult = await storage.createFile(
            bucketId: '67e7e3050013c9195200',
            fileId: ID.unique(),
            file: InputFile.fromBytes(bytes: fileBytes, filename: fileName),
          );

          setState(() {
            _imageFileId = uploadResult.$id;
            isUploading = false;
            isImageUploaded = true; // Mark image as uploaded
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully!')),
          );
        } else {
          print('File bytes are null.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to upload image!')));
    }
  }

  Future<void> _createTournament() async {
    if (_formKey.currentState!.validate()) {
      try {
        await databases.createDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: ID.unique(),
          data: {
            'T_Name': _nameController.text.trim(),
            'T_Desc': _descriptionController.text.trim(),
            'link': _registrationLinkController.text.trim(),
            'game': _gameController.text.trim(), // Save game entered manually
            'imageFileId': _imageFileId, // Include imageFileId if uploaded
            'user_id': _userId, // Add user ID
            'user_name': _userName, // Add user name
            'Date': DateTime.now().toIso8601String(),
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tournament created successfully!')),
        );

        Navigator.pop(context, true); // Return true to refresh the list
      } on AppwriteException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Failed to create tournament.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _registrationLinkController.dispose();
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Tournament')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tournament Name'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Enter a tournament name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Tournament Description',
                  hintText:
                      'Enter Details like Venue, No. of Players, Prizes, etc.',
                ),
                maxLines: 5, // Enable multi-line input
                keyboardType: TextInputType.multiline,
                validator:
                    (value) =>
                        value!.isEmpty
                            ? 'Enter a tournament description'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _registrationLinkController,
                decoration: const InputDecoration(
                  labelText: 'Registration Link (Optional)',
                  hintText: 'https://example.com/register',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gameController,
                decoration: const InputDecoration(
                  labelText: 'Game (e.g., PUBG, Valorant)',
                ),
                validator:
                    (value) => value!.isEmpty ? 'Enter the game name' : null,
              ),
              const SizedBox(height: 16),
              if (!isImageUploaded) // Display upload button only if no image is uploaded
                ElevatedButton(
                  onPressed: _selectAndUploadImage,
                  child:
                      isUploading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Upload Thumbnail (Optional)'),
                ),
              if (_selectedFileName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Uploaded File: $_selectedFileName',
                    style: const TextStyle(color: Colors.green, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createTournament,
                child: const Text('Create Tournament'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

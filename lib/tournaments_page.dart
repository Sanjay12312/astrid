import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'appwrite_client.dart'; // Import the global client file
import 'create_tournament_page.dart'; // Import the create tournament page
import 'tournament_detail_page.dart'; // Import the tournament detail page

class TournamentPage extends StatefulWidget {
  const TournamentPage({Key? key}) : super(key: key);

  @override
  _TournamentPageState createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage> {
  late Databases databases;
  late Storage storage;
  List<dynamic> tournaments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    databases = Databases(appwriteClient);
    storage = Storage(appwriteClient);
    _fetchTournaments();
  }

  Future<void> _fetchTournaments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final DocumentList result = await databases.listDocuments(
        databaseId: '67d260270026140252d0',
        collectionId: '67e7ecb70015b4466647',
      );

      setState(() {
        tournaments = result.documents;
        isLoading = false;
      });
    } on AppwriteException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching tournaments: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getImageUrl(String fileId) {
    const String bucketId = '67e7e3050013c9195200'; // Your bucket ID
    const String endpoint =
        'https://cloud.appwrite.io/v1'; // Your Appwrite endpoint
    const String projectId = '67d1abbc001255976a3c'; // Your Appwrite project ID

    return '$endpoint/storage/buckets/$bucketId/files/$fileId/view?project=$projectId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tournaments")),
      body: Column(
        children: [
          // Add "Hosting a Tournament?" section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Text(
                  "Hosting a Tournament?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateTournamentPage(),
                      ),
                    ).then((value) {
                      if (value == true) {
                        _fetchTournaments(); // Refresh the tournament list
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Create a Tournament",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),

          // Render the tournament list
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : tournaments.isEmpty
                    ? const Center(
                      child: Text(
                        'No tournaments available.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      itemCount: tournaments.length,
                      itemBuilder: (context, index) {
                        final tournament = tournaments[index];
                        final String? imageFileId =
                            tournament.data['imageFileId'];
                        final String imageUrl =
                            imageFileId != null
                                ? _getImageUrl(imageFileId)
                                : '';

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading:
                                imageFileId != null
                                    ? Image.network(
                                      imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                    : const Icon(Icons.image_not_supported),
                            title: Text(
                              tournament.data['T_Name'] ?? 'Unknown Tournament',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Created by ${tournament.data['user_name'] ?? 'Unknown User'} on '
                              '${DateTime.parse(tournament.data['Date']).toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TournamentDetailPage(
                                        tournament: tournament.data,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

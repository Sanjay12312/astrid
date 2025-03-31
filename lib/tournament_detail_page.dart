import 'package:flutter/material.dart';

class TournamentDetailPage extends StatelessWidget {
  final Map<String, dynamic> tournament;

  const TournamentDetailPage({Key? key, required this.tournament})
    : super(key: key);

  String? _getImageUrl(String? fileId) {
    if (fileId == null) {
      print('ImageFileId is null'); // Debug line
      return null; // If no imageFileId, return null
    }
    const String bucketId =
        '67e7e3050013c9195200'; // Replace with your bucket ID
    const String endpoint =
        'https://cloud.appwrite.io/v1'; // Replace with your Appwrite endpoint
    const String projectId =
        '67d1abbc001255976a3c'; // Replace with your Appwrite project ID

    final url =
        '$endpoint/storage/buckets/$bucketId/files/$fileId/view?project=$projectId';
    print('Generated Image URL: $url'); // Debug line
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final String name = tournament['T_Name'] ?? 'Unnamed Tournament';

    final String description =
        tournament['T_Desc'] ?? 'No description available.';

    final String registrationLink =
        tournament['link'] ?? 'No registration link provided.';

    final String game = tournament['game'] ?? 'Not specified';

    final String userName = tournament['user_name'] ?? 'Unknown User';

    final String? imageFileId = tournament['imageFileId'];

    final String? imageUrl = _getImageUrl(imageFileId);

    final String timestamp = tournament['Date'] ?? '';

    DateTime? createdAt;
    try {
      createdAt = DateTime.parse(timestamp);
      print('Parsed Timestamp: ${createdAt.toLocal()}'); // Debug line
    } catch (e) {
      print('Error parsing timestamp: $e'); // Debug line
    }

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Banner Section
            if (imageUrl != null)
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Tournament Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Created by $userName on ${createdAt?.toLocal().toString().split(' ')[0] ?? 'Date not available'}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Game:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(game, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text(
                    'Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text(
                    'Registration Link:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    registrationLink,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

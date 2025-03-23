import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'appwrite_client.dart';
import 'package:url_launcher/url_launcher.dart';

class GameInvitesPage extends StatefulWidget {
  final String gameName;

  const GameInvitesPage({Key? key, required this.gameName}) : super(key: key);

  @override
  _GameInvitesPageState createState() => _GameInvitesPageState();
}

class _GameInvitesPageState extends State<GameInvitesPage> {
  late Databases databases;
  late Account account;
  final String databaseId = '67d260270026140252d0';
  final String collectionId = '67dc5d7a00342ae4e24a';
  List<Document> invites = [];
  bool isLoading = true;
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    databases = Databases(appwriteClient);
    account = Account(appwriteClient);
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    try {
      final user = await account.get();
      setState(() {
        currentUserId = user.$id;
      });
      _fetchInvites();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error fetching user data')));
    }
  }

  Future<void> _fetchInvites() async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: [
          Query.equal('game', widget.gameName),
          Query.orderDesc('timestamp'),
        ],
      );

      setState(() {
        invites = response.documents;
        isLoading = false;
      });
    } on AppwriteException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error fetching invites')),
      );
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteInvite(String documentId) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invite deleted successfully!')),
      );

      _fetchInvites();
    } on AppwriteException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to delete invite.')),
      );
    }
  }

  void _launchURL(String url) async {
    if (url.isEmpty) return;

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open link")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.gameName)),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : invites.isEmpty
              ? const Center(child: Text("No invites yet!"))
              : ListView.builder(
                itemCount: invites.length,
                itemBuilder: (context, index) {
                  final invite = invites[index].data;
                  final String joinLink = invite['join_link'] ?? '';
                  final String username = invite['username'] ?? 'Unknown';
                  final String inviteUserId = invite['user_id'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: MouseRegion(
                            onEnter: (event) => setState(() {}),
                            onExit: (event) => setState(() {}),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                      (states) =>
                                          states.contains(MaterialState.hovered)
                                              ? Colors
                                                  .green
                                                  .shade300 // Hover color
                                              : Colors
                                                  .green
                                                  .shade600, // Default color
                                    ),
                                shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder
                                >(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                elevation: MaterialStateProperty.all(4),
                              ),
                              onPressed:
                                  joinLink.isNotEmpty
                                      ? () => _launchURL(joinLink)
                                      : null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                child: Text(
                                  "$username - Join - Players Needed: ${invite['players_needed']}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (inviteUserId == currentUserId) ...[
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteInvite(invites[index].$id),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
    );
  }
}

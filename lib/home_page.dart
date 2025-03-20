import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'login_page.dart';
import 'room_list_page.dart';
import 'post_invite_page.dart'; // Import PostInvitePage

class HomePage extends StatefulWidget {
  final Client client;

  const HomePage({Key? key, required this.client}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Account account;
  String userName = "";
  bool isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    account = Account(widget.client);
    _fetchUserInfo();
  }

  // Retrieve the current user's information from Appwrite.
  Future<void> _fetchUserInfo() async {
    try {
      final user = await account.get();
      setState(() {
        userName = user.name.isNotEmpty ? user.name : user.email;
        isLoading = false;
      });
    } on AppwriteException catch (e) {
      print('Error fetching user info: ${e.message}');
      setState(() {
        userName = "Unknown";
        isLoading = false;
      });
    } catch (e) {
      print('Unexpected error: $e');
      setState(() {
        userName = "Error";
        isLoading = false;
      });
    }
  }

  // Delete the current session to log out.
  Future<void> _logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(client: widget.client),
        ),
        (route) => false,
      );
    } on AppwriteException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Logout failed.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Returns the current page based on the selected bottom navigation index.
  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const ActivitiesPage();
      case 1:
        return const GamingPage();
      default:
        return const Center(child: Text("Invalid Page"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            isLoading ? const Text('Loading...') : Text('Welcome, $userName!'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Activities'),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Gaming',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostInvitePage()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Post Game Invite',
      ),
    );
  }
}

// Page that displays the list of available activities.
class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({Key? key}) : super(key: key);

  final List<String> activities = const [
    'Group Chat',
    'Team Match',
    'Tournament',
    'Practice Session',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(activities[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoomListPage(optionName: activities[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Page that displays the list of available gaming options.
class GamingPage extends StatelessWidget {
  const GamingPage({Key? key}) : super(key: key);

  final List<String> games = const [
    'Online Battle Arena',
    'Role-Playing Game',
    'Strategy Game',
    'Puzzle Game',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(games[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RoomListPage(optionName: games[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

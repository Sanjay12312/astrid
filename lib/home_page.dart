import 'package:flutter/material.dart';
import 'post_invite_page.dart';
import 'game_invites_page.dart';
import 'tournaments_page.dart'; // Import the TournamentsPage file

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFFFFFF), // White
            Color(0xFF076585), // Dark Blue-Green
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Transparent Scaffold
        appBar: AppBar(title: const Text("Astrid")),
        body:
            _selectedIndex == 0 ? TournamentPage() : _buildGamingPage(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: "Tournaments",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset),
              label: "Gaming",
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PostInvitePage()),
            );
          },
          child: const Icon(Icons.add), // "+" icon
        ),
      ),
    );
  }

  Widget _buildGamingPage() {
    return _buildGameSelectionPage();
  }

  Widget _buildGameSelectionPage() {
    final List<Map<String, String>> games = [
      {"name": "Call of Duty", "image": "assets/cod.jpg"},
      {"name": "PUBG", "image": "assets/pubg.jpg"},
      {"name": "Clash Royale", "image": "assets/clash_royale.jpg"},
      {"name": "League of Legends", "image": "assets/league_of_legends.jpg"},
      {"name": "Among Us", "image": "assets/among_us.jpg"},
      {"name": "Valorant", "image": "assets/valorant.jpg"},
      {"name": "Chess", "image": "assets/chess.jpg"},
      {"name": "Ludo", "image": "assets/ludo.jpg"},
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Select a Game",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: games.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              GameInvitesPage(gameName: games[index]["name"]!),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: Image.asset(
                            games[index]["image"]!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        games[index]["name"]!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'room_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _showGameOptions = false;
  bool _showSpecificGames = false;
  String _selectedCategory = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Astrid")),
      body: _selectedIndex == 0 ? _buildActivitiesPage() : _buildGamingPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _showGameOptions = false;
            _showSpecificGames = false;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Activities"),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: "Gaming",
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesPage() {
    return const Center(
      child: Text(
        "Activities Section",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGamingPage() {
    if (_showSpecificGames) {
      return _buildGameSelectionPage();
    } else if (_showGameOptions) {
      return _buildGameCategories();
    } else {
      return _buildGamingMain();
    }
  }

  Widget _buildGamingMain() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _showGameOptions = true;
          });
        },
        child: const Text("Select Game Category"),
      ),
    );
  }

  Widget _buildGameCategories() {
    List<String> categories = [
      'Online Battle Arena',
      'Role-Playing Game',
      'Strategy Game',
      'Puzzle Game',
    ];

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(categories[index]),
            onTap: () {
              if (categories[index] == "Role-Playing Game") {
                setState(() {
                  _selectedCategory = categories[index];
                  _showSpecificGames = true;
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            RoomListPage(optionName: categories[index]),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildGameSelectionPage() {
    final List<Map<String, String>> games = [
      {"name": "Call of Duty", "image": "assets/cod.jpg"},
      {"name": "PUBG Mobile", "image": "assets/pubg.jpg"},
      {"name": "Clash Royale", "image": "assets/clash_royale.jpg"},
      {"name": "Among Us", "image": "assets/among_us.jpg"},
      {"name": "League of Legends", "image": "assets/league_of_legends.jpg"},
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Select a Role-Playing Game",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: games.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.1, // Makes the cards less stretched
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              RoomListPage(optionName: games[index]["name"]!),
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
                        height: 80, // Smaller image height
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: Image.asset(
                            games[index]["image"]!,
                            fit: BoxFit.contain, // Keeps image proportions
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

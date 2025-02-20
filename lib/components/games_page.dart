import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> games = [
      "Call of Duty",
      "Fortnite",
      "PUBG",
      "Apex Legends",
      "Valorant",
      "Minecraft",
      "League of Legends",
      "Rocket League",
      "Overwatch",
      "Rainbow Six Siege",
      "FIFA 22",
      "Dota 2",
      "Counter-Strike",
      "Street Fighter V",
      "GTA V",
      "The Witcher 3",
      "Halo Infinite",
      "Among Us",
      "Cyberpunk 2077",
      "World of Warcraft"
    ];

    final List<Color> tabColors = [
      Colors.blue.shade200,
      Colors.green.shade200,
      Colors.orange.shade200,
      Colors.purple.shade200,
      Colors.teal.shade200,
      Colors.red.shade200,
      Colors.yellow.shade200,
      Colors.pink.shade200,
      Colors.cyan.shade200,
      Colors.lime.shade200,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Games Page'),
        backgroundColor: Colors.blueGrey.shade700,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8),
              color: tabColors[index % tabColors.length],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                tileColor: tabColors[index % tabColors.length],
                title: Text(
                  games[index],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                leading: const Icon(
                  Icons.videogame_asset,
                  color: Colors.black87,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GameDetailPage(gameName: games[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class GameDetailPage extends StatefulWidget {
  final String gameName;
  const GameDetailPage({super.key, required this.gameName});

  @override
  _GameDetailPageState createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  final List<String> servers = [
    "Asia",
    "North America",
    "South America",
    "Australia",
    "Europe",
    "KRJP",
  ];

  final List<String> languages = [
    "English",
    "Spanish",
    "French",
    "German",
    "Chinese",
    "Japanese",
    "Korean",
    "Russian",
    "Portuguese",
    "Italian",
    "Dutch",
    "Hindi",
    "Arabic",
    "Turkish",
    "Vietnamese",
    "Thai",
    "Swedish",
    "Polish",
    "Greek",
    "Hebrew",
    "Indonesian",
    "Malay",
    "Filipino",
    "Tamil",
    "Telugu",
    "Bengali",
    "Marathi",
    "Gujarati",
    "Punjabi",
    "Kannada",
    "Malayalam",
    "Odia",
    "Urdu"
  ];

  String? selectedServer;
  String? selectedLanguage;
  List<String> joinedPlayers = [];

  void _joinGame() {
    if (!joinedPlayers.contains("Player 1")) {
      setState(() {
        joinedPlayers.add("Player 1");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameName),
        backgroundColor: Colors.blueGrey.shade700,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  hint: const Text("Server"),
                  value: selectedServer,
                  items: servers.map((String server) {
                    return DropdownMenuItem<String>(
                      value: server,
                      child: Text(server),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedServer = value;
                    });
                  },
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  hint: const Text("Language"),
                  value: selectedLanguage,
                  items: languages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to ${widget.gameName}!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (selectedServer != null)
            Text(
              'Selected Server: $selectedServer',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          if (selectedLanguage != null)
            Text(
              'Selected Language: $selectedLanguage',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          const SizedBox(height: 20),
          if (joinedPlayers.isNotEmpty)
            Column(
              children: [
                const Text(
                  'Joined Players:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...joinedPlayers.map(
                  (player) => ListTile(
                    leading: const Icon(Icons.person, color: Colors.blue),
                    title: Text(player,
                        style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _joinGame,
        label: const Text("Join"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

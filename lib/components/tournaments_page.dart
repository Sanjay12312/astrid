import 'package:flutter/material.dart';

class TournamentsPage extends StatefulWidget {
  const TournamentsPage({super.key});

  @override
  _TournamentsPageState createState() => _TournamentsPageState();
}

class _TournamentsPageState extends State<TournamentsPage> {
  final List<String> tournaments = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tournaments',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueGrey.shade700,
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
          itemCount: tournaments.length,
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
                  tournaments[index],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                leading: const Icon(
                  Icons.emoji_events,
                  color: Colors.black87,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetailsPage(game: tournaments[index]),
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

class GameDetailsPage extends StatefulWidget {
  final String game;
  const GameDetailsPage({super.key, required this.game});

  @override
  _GameDetailsPageState createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
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
    "Bengali",
    "Gujarati",
    "Punjabi",
    "Marathi",
    "Kannada",
    "Telugu",
    "Urdu"
  ];

  String? selectedServer;
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game),
        backgroundColor: Colors.blueGrey.shade700,
        actions: [
          DropdownButton<String>(
            hint: const Text("Server", style: TextStyle(color: Colors.white)),
            value: selectedServer,
            dropdownColor: Colors.blueGrey.shade700,
            items: servers.map((String server) {
              return DropdownMenuItem<String>(
                value: server,
                child: Text(server, style: const TextStyle(color: Colors.white)),
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
            hint: const Text("Language", style: TextStyle(color: Colors.white)),
            value: selectedLanguage,
            dropdownColor: Colors.blueGrey.shade700,
            items: languages.map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedLanguage = value;
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Text(
          "Selected Game: ${widget.game}\nServer: ${selectedServer ?? "Not selected"}\nLanguage: ${selectedLanguage ?? "Not selected"}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

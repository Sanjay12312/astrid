import 'package:flutter/material.dart';
import 'games_page.dart';
import 'tournaments_page.dart';
import 'user_login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    GamesPage(),
    TournamentsPage(),
    UserLoginPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Game Hub",
          style: TextStyle(
            fontSize: 24, // Making the font size larger
            fontWeight: FontWeight.bold, // Making the font bolder
            color: Colors.black, // Setting the font color to black for contrast
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // White background for a clean look
        elevation: 0, // Removing the shadow for a flat look
      ),
      body: Column(
        children: [
          if (_selectedIndex == 0 || _selectedIndex == 1) // Show search bar only on Games & Tournaments page
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search game names...",
                  hintStyle: TextStyle(color: Colors.black54), // Lighter hint text color
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners for a soft look
                    borderSide: BorderSide(color: Colors.black45, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Tournaments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white, // White background for the bottom navigation
        selectedItemColor: Colors.black, // Black color for selected icon
        unselectedItemColor: Colors.black54, // Lighter black for unselected icons
        elevation: 5, // Slight elevation to distinguish the bottom bar
      ),
    );
  }
}

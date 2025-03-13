// File: lib/room_list_page.dart
import 'package:flutter/material.dart';

class RoomListPage extends StatelessWidget {
  final String optionName;

  const RoomListPage({Key? key, required this.optionName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample hardcoded list of available rooms for the given option.
    final List<String> availableRooms = [
      'Room 1 for $optionName',
      'Room 2 for $optionName',
      'Room 3 for $optionName',
      'Room 4 for $optionName',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Available Rooms for $optionName"),
      ),
      body: ListView.builder(
        itemCount: availableRooms.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(availableRooms[index]),
              onTap: () {
                // For now, show a SnackBar. In a full app, you could navigate to room details or join the room.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Joining ${availableRooms[index]}")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

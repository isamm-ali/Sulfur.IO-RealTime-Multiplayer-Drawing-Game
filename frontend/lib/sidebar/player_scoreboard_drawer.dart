import 'package:flutter/material.dart';
import 'package:frontend/data/avatars.dart';

class PlayerScore extends StatelessWidget {
  final List<Map> userData;
  PlayerScore(this.userData);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '- Scores -',
              style: TextStyle(
                fontFamily: 'Unkempt',
                fontSize: 30,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                final player = userData[index];
                return ListTile(
                  leading: ClipOval(
                    child: Image.asset(
                      getAvatar(player['avatarId'].toString()).asset,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    player['username'].toString(),
                    style: const TextStyle(
                      fontFamily: 'Unkempt',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    player['points'].toString(),
                    style: const TextStyle(
                      fontFamily: 'Unkempt',
                      fontSize: 20,
                      color: Colors.black,
                    ),
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

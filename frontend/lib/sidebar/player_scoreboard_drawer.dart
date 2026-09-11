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
                final data = userData[index].values;

                return ListTile(
                  leading: ClipOval(
                    child: Image.asset(
                      getAvatar(data.elementAt(1).toString()).asset,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    data.elementAt(0).toString(),
                    style: const TextStyle(
                      fontFamily: 'Unkempt',
                      fontSize: 23,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    data.elementAt(2).toString(),
                    style: const TextStyle(
                      fontFamily: 'Unkempt',
                      fontSize: 23,
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

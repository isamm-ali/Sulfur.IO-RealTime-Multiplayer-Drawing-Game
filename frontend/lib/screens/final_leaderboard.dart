import 'package:flutter/material.dart';
import 'package:frontend/data/avatars.dart';
import 'package:frontend/screens/home_screen.dart';

class FinalLeaderboard extends StatelessWidget {
  final List<Map> scoreboard;
  FinalLeaderboard({super.key, required this.scoreboard});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounddrawingpage.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(8),
        height: double.maxFinite,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '- Leaderboard -',
                style: TextStyle(
                  fontFamily: 'Unkempt',
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      blurRadius: 1.5,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scoreboard.length,
                primary: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final player = scoreboard[index];
                  return ListTile(
                    leading: ClipOval(
                      child: Image.asset(
                        getAvatar(player['avatarId'].toString()).asset,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      player['username'].toString(),
                      style: const TextStyle(
                        fontFamily: 'Unkempt',
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Text(
                      player['points'].toString(),
                      style: const TextStyle(
                        fontFamily: 'Unkempt',
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(padding: const EdgeInsets.only(bottom: 30), child: SizedBox(
              width: 150,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(140, 55),
                  elevation: 6,
                  shadowColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 64, 255, 0),
                  foregroundColor: const Color(0xFFF4D6B2),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 0.3, color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'HOME',
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: 'Unkempt',
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),)
          ],
        ),
      ),
    );
  }
}

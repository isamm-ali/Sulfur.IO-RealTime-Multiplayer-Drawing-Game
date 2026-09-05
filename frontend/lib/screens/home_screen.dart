import 'package:flutter/material.dart';
import 'package:frontend/screens/create_room_screen.dart';
import 'package:frontend/screens/join_room_screen.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundhomepage.png'),
            fit: BoxFit.cover,
          ),
          color: const Color.fromARGB(255, 198, 230, 255),
        ),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Text(
              "SULFUR.IO",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "DynaPuff",
                fontSize: 45,
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
            SizedBox(height: 35),
            Text(
              "Create or Join a room to play!",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Unkempt",
                fontSize: 27,
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateRoomScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(140, 55),
                    elevation: 6,
                    shadowColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 64, 255, 0),
                    foregroundColor: const Color(0xFFF4D6B2),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.7, color: Colors.white),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'CREATE',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Unkempt",
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

                const SizedBox(width: 30),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinRoomScreen(),
                      ),
                    );},
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(140, 55),
                    elevation: 6,
                    shadowColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    foregroundColor: const Color(0xFFF4D6B2),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.7, color: Colors.white),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'JOIN',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Unkempt",
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

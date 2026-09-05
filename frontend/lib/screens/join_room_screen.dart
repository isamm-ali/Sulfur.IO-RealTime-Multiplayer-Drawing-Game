import 'package:flutter/material.dart';
import 'package:frontend/data/avatars.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roomNameController = TextEditingController();

  int selectedIndex = 0;
  late String? selectedPlayers;
  late String? selectedRounds;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundhomepage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            const Text(
              'Join Room',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Unkempt',
                fontSize: 50,
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

            const SizedBox(height: 30),

            const Text(
              ' - Enter your name - ',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Unkempt',
                fontSize: 23,
                fontWeight: FontWeight.w400,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: 280,
              child: TextField(
                controller: nameController,
                style: const TextStyle(
                  fontFamily: 'Unkempt',
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'ex: sulfurcodes',
                  hintStyle: const TextStyle(
                    fontFamily: 'Unkempt',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              ' - Enter room code - ',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Unkempt',
                fontSize: 23,
                fontWeight: FontWeight.w400,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: 280,
              child: TextField(
                controller: roomNameController,
                style: const TextStyle(
                  fontFamily: 'Unkempt',
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Ask your friend',
                  hintStyle: const TextStyle(
                    fontFamily: 'Unkempt',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              ' - Choose your avatar - ',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Unkempt',
                fontSize: 23,
                fontWeight: FontWeight.w400,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(avatars.length, (index) {
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    width: 65,
                    height: 65,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.yellow, width: 3)
                          : null,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        avatars[index].asset,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 120,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
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
            ),
          ],
        ),
      ),
    );
  }
}

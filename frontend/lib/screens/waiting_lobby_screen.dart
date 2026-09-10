import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaitingLobbyScreen extends StatefulWidget {
  final int occupancy;
  final int noOfPlayers;
  final String lobbyName;
  const WaitingLobbyScreen({
    required this.occupancy,
    required this.noOfPlayers,
    required this.lobbyName,
  });
  @override
  State<WaitingLobbyScreen> createState() => _WaitingLobbyScreenState();
}

class _WaitingLobbyScreenState extends State<WaitingLobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
  width: double.infinity,
  height: double.infinity,
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage(
        'assets/images/backgrounddrawingpage.png',
      ),
      fit: BoxFit.cover,
    ),
  ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                overflow: TextOverflow.ellipsis,
                'Waiting for ${widget.occupancy - widget.noOfPlayers} players...',
                style: TextStyle(
                  fontFamily: 'Unkempt',
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(3, 3),
                      blurRadius: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: TextField(
                style: const TextStyle(fontFamily: 'Unkempt'),
                readOnly: true,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.lobbyName));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 1),
                      backgroundColor: const Color.fromARGB(255, 64, 255, 0),
                      content: Text(
                        'Copied!',
                        style: TextStyle(
                          shadows: [
                            Shadow(
                              offset: Offset(3, 3),
                              blurRadius: 3,
                              color: Colors.black,
                            ),
                          ],
                          fontFamily: 'Unkempt',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Tap to copy room name!',
                  hintStyle: const TextStyle(
                    fontFamily: 'Unkempt',
                    fontSize: 22,
                    color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              blurRadius: 1,
                              color: Colors.white,
                            ),
                    ],
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 64, 255, 0),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 0.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black, width: 0.2),
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

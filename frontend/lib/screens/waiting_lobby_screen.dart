import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/data/avatars.dart';

class WaitingLobbyScreen extends StatefulWidget {
  final int occupancy;
  final int noOfPlayers;
  final String lobbyName;
  final players;
  const WaitingLobbyScreen({
    required this.occupancy,
    required this.noOfPlayers,
    required this.lobbyName,
    required this.players,
  });
  @override
  State<WaitingLobbyScreen> createState() => _WaitingLobbyScreenState();
}

class _WaitingLobbyScreenState extends State<WaitingLobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backgrounddrawingpage.png'),
          fit: BoxFit.cover,
        ),
      ),
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                overflow: TextOverflow.ellipsis,
                'Waiting for ${widget.occupancy - widget.noOfPlayers} player(s)...',
                style: TextStyle(
                  fontFamily: 'Unkempt',
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 1,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              width: 200,
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
                  hintText: 'copy room name!',
                  hintStyle: const TextStyle(
                    fontFamily: 'Unkempt',
                    fontSize: 23,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0.8, 0.8),
                        blurRadius: 1,
                        color: Colors.black,
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
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 0.2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Align(
              alignment: .centerStart,
              child: Text(
              '  In Room :',
              style: TextStyle(
                fontFamily: 'Unkempt',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(0.5, 0.5),
                    blurRadius: 1,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            ),
            SizedBox(height: 12,),
            Expanded(
              child: ListView.builder(
                itemCount: widget.players.length,
                shrinkWrap: true,
                primary: true,
                itemBuilder: (context, index) {
                  final player = widget.players[index];
                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${index + 1}.',
                          style: const TextStyle(
                            fontFamily: 'Unkempt',
                            fontSize: 25,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 1,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ClipOval(
                          child: Image.asset(
                            getAvatar(player['avatarId'].toString()).asset,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      player['nickname'],
                      style: const TextStyle(
                        fontFamily: 'Unkempt',
                        fontSize: 25,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

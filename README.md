# Sulfur.IO

A real-time multiplayer drawing and guessing game. Same core loop as Skribbl.io, rebuilt from scratch with its own art, UI, and backend architecture.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat&logo=node.js&logoColor=white)
![Express](https://img.shields.io/badge/Express_5-000000?style=flat&logo=express&logoColor=white)
![Socket.IO](https://img.shields.io/badge/Socket.IO-010101?style=flat&logo=socket.io&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=flat&logo=mongodb&logoColor=white)
![Vercel](https://img.shields.io/badge/Vercel-000000?style=flat&logo=vercel&logoColor=white)
![Render](https://img.shields.io/badge/Render-46E3B7?style=flat&logo=render&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

> **Live demo:**

> **Preview:**

https://github.com/user-attachments/assets/e4306ef3-ce34-4fdb-b3de-efe682cf3098

|                                                                                                         |                                                                                                         |
| ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| <img width="500" src="https://github.com/user-attachments/assets/88d20aae-1522-45ba-aa66-a996f40feed6" /> | <img src="https://github.com/user-attachments/assets/c47c5a9d-4a73-4411-b287-cbf36cf7f3fc" width="500"> |
| <img src="[https://github.com/user-attachments/assets/c47c5a9d-4a73-4411-b287-cbf36cf7f3fc](https://github.com/user-attachments/assets/b9250604-f122-49f9-87cd-ab77b47146e4)" width="500"> | <img src="[https://github.com/user-attachments/assets/88d20aae-1522-45ba-aa66-a996f40feed6](https://github.com/user-attachments/assets/c34b99dc-e0db-46ad-a0b4-9296b5df71f1)" width="500"> |
| <img src="[https://github.com/user-attachments/assets/6a6c9181-75e0-40f9-a8ba-5499babce1ea](https://github.com/user-attachments/assets/6a6c9181-75e0-40f9-a8ba-5499babce1ea)" width="500"> | <img src="[https://github.com/user-attachments/assets/7025168c-7ec0-4ec2-82b1-68388eb3739c](https://github.com/user-attachments/assets/7025168c-7ec0-4ec2-82b1-68388eb3739c)" width="500"> |


## What it does

- Host a room with a custom name, lobby size, and round count, then share the room name with friends
- Join a room and wait in a live lobby until it fills up and the game starts
- Draw on a shared canvas in real time, everyone else watches the strokes appear live
- Pick from a full color picker and adjustable brush width, or wipe the canvas
- Guess the word through live chat, correct guesses are auto-detected and flagged for the room
- Turn rotates automatically at the end of each 60-second round, with a new random word each turn
- Score rewards speed: the faster you guess, the more points you get
- Live scoreboard during play, final leaderboard once all rounds are done
- Custom avatars, hand-drawn UI, and two custom fonts (DynaPuff, Unkempt) instead of a generic Material look

## Tech stack

| Layer | Tech |
|---|---|
| Client | Flutter (Dart), `socket_io_client`, `flutter_colorpicker`, `CustomPainter` for the canvas |
| Server | Node.js, Express 5, Socket.IO |
| Database | MongoDB via Mongoose |
| Realtime transport | WebSocket with polling fallback |

## How it works

Each game room is a single MongoDB document (`Room`) with an embedded array of `Player` subdocuments, so the whole game state for a room (players, current word, whose turn it is, round number, scores) lives in one place and gets broadcast to everyone in that room on every update.

- **Rooms** are created with a unique name, an occupancy limit, and a round count. The room locks once it fills up.
- **Word selection** picks a random word from the server-side word bank for every turn, so the word is never sent to the drawer's opponents.
- **Drawing** is just relayed: `paint`, `color-change`, `stroke-width`, and `clear-screen` events get broadcast to everyone else in the room as they happen, with no drawing data persisted.
- **Guessing** is checked server-side against the room's current word. A correct guess is scored as `round((200 / timeTaken) * 10)` points, so guessing in 2 seconds is worth a lot more than guessing in 55, and each player can only score once per turn.
- **Turn rotation** advances `turnIndex` round-robin through the players array. Wrapping back to index 0 increments `currentRound`, and the game ends once `currentRound` passes `maxRounds`.
- **Disconnects** remove the player from the room, shift the turn index so it still points at a valid player, hand the turn to the next player if the person who left was mid-turn, and delete the room entirely if it empties out.

## Real-time events

| Event | Direction | Purpose |
|---|---|---|
| `create-game` | client → server | Create a room and join it as party leader |
| `join-game` | client → server | Join an existing room by name |
| `paint` | client ↔ server | Broadcast a stroke to the rest of the room |
| `color-change` | client ↔ server | Sync the active brush color |
| `stroke-width` | client ↔ server | Sync the active brush size |
| `clear-screen` | client ↔ server | Clear the shared canvas |
| `message` | client ↔ server | Send a chat message / guess, or relay a correct-guess notice |
| `change-turn` | client ↔ server | Advance to the next player's turn |
| `updateScore` | client ↔ server | Push the latest scoreboard |
| `updateRoom` | server → client | Send the full room state after a join or leave |
| `notCorrectGame` | server → client | Reject an invalid create/join attempt (full room, bad name, already started) |
| `game-finished` | server → client | Signal that the last round is over and send final scores |
| `disconnect` | client → server | Clean up a player who left mid-game |

## Project structure

```
.
├── backend/
│   └── src/
│       ├── app.js                  # Express app setup
│       ├── server.js               # HTTP + Socket.IO server entry 
│       ├── config/
│       │   └── database.js         # MongoDB connection
│       ├── controllers/
│       │   └── socketController.js # All game logic: rooms, turns, 
│       ├── models/
│       │   ├── player.js           # Player subdocument schema
│       │   └── room.js             # Room schema (embeds players)
│       ├── services/
│       │   └── getWord.js          # Word bank / random word picker
│       └── socket/
│           └── socketServer.js     # Wires socket events to controllers
│
└── frontend/
    └── lib/
        ├── main.dart
        ├── data/
        │   └── avatars.dart
        ├── models/
        │   ├── my_custom_painter.dart  # Renders strokes onto the 
        │   └── touch_points.dart       # Stroke point data
        ├── screens/
        │   ├── home_screen.dart
        │   ├── create_room_screen.dart
        │   ├── join_room_screen.dart
        │   ├── waiting_lobby_screen.dart
        │   ├── paint_screen.dart       # Core game screen: canvas, 
        │   └── final_leaderboard.dart
        └── widgets/
            └── player_scoreboard_drawer.dart
```

## Getting started

### Prerequisites

- Node.js and npm
- A MongoDB connection string (local instance or Atlas)
- Flutter SDK

### Backend

```bash
cd backend
npm install
```

Create a `.env` file in `backend/`:

```
PORT=5000
MONGODB_CONNECTION_STRING=your_mongodb_connection_string
```

```bash
npm start
```

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

By default the app points at `http://localhost:5000` for web and desktop, and `http://10.0.2.2:5000` for the Android emulator (that's the emulator's alias for the host machine's `localhost`). To connect to a physical device or a deployed backend, update the `host` getter in `lib/screens/paint_screen.dart`.

## Possible next steps

- Move the word bank into MongoDB or a config file so it's easy to expand past the current 40 words
- Add reconnect handling so a dropped connection mid-round doesn't just remove the player
- Add basic room password / private room support
- Persist finished games for a match history or global leaderboard

## License

MIT

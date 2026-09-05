# SULFUR.IO

A real-time multiplayer drawing and guessing game. Same core gameplay as Skribbl.io, but with a completely different visual identity: new art, new UI, new theme, built from scratch.

## What it does

- Create a room and invite friends with a room code
- Join an existing room and wait in a live lobby before the game starts
- Draw on a shared canvas in real time while everyone else watches and guesses
- Pick from different pen colors, brush sizes, and an eraser
- Guess the word through live chat, correct guesses get flagged automatically
- Turns rotate automatically between players each round
- Points are calculated based on how fast you guess
- Live scoreboard during the round, final leaderboard once the game ends

## Preview

## Tech stack

**Frontend:** Flutter
**Backend:** Node.js, Express, Socket.IO
**Database:** MongoDB with Mongoose

## Getting started

### Backend

```bash
cd backend
npm install
```

Create a `.env` file:

```
PORT=5000
MONGO_URI=your_mongodb_connection_string
```

```bash
npm start
```

### Frontend

```bash
cd frontend
flutter pub get
```

Point the socket connection at your running backend (wherever you're storing that URL in the Flutter project), then:

```bash
flutter run
```

## Project structure

```
.
├── backend/     # Express server, Socket.IO events, Mongoose models
└── frontend/    # Flutter app
```

## Credits

Core gameplay and architecture inspired by [Rivaan Ranawat's Skribbl.io clone tutorial](https://github.com/RivaanRanawat/skribblio-youtube-tutorial). Everything visual (UI, art, theme) in this version was rebuilt from scratch.

## License

MIT
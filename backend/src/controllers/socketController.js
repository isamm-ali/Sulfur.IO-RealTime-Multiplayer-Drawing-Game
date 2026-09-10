import { Room } from "../models/room.js";
import { getWord } from "../services/getWord.js";

export const createGame = async (
  io,
  socket,
  { nickname, avatarId, name, occupancy, maxRounds },
) => {
  try {
    const existingRoom = await Room.findOne({ name });
    if (existingRoom) {
      socket.emit("notCorrectGame", "Room with that name already exists!");
      return;
    }
    const room = await Room.create({
      word: getWord(),
      name,
      occupancy,
      maxRounds,
      players: [
        {
          socketId: socket.id,
          nickname,
          avatarId,
          isPartyLeader: true,
        },
      ],
    });
    socket.join(name);
    io.to(name).emit("updateRoom", room);
  } catch (error) {
    console.error(error);
    socket.emit("serverError", "Something went wrong");
  }
};

export const joinGame = async (io, socket, { nickname, avatarId, name }) => {
  try {
    const room = await Room.findOne({ name });
    if (!room) {
      socket.emit("notCorrectGame", "Please enter a valid room name!");
      return;
    }
    if (room.players.length >= room.occupancy) {
      socket.emit("notCorrectGame", "Room is full!");
      return;
    }
    if (!room.isJoin) {
      socket.emit("notCorrectGame", "Game has already started!");
      return;
    }
    const updatedRoom = await Room.findOneAndUpdate(
      { name },
      {
        $push: {
          players: {
            socketId: socket.id,
            nickname,
            avatarId,
          },
        },
      },
      { new: true },
    );
    if (!updatedRoom) {
      socket.emit("notCorrectGame", "Room no longer exists!");
      return;
    }
    updatedRoom.turn = updatedRoom.players[updatedRoom.turnIndex];
    await updatedRoom.save();
    socket.join(name);
    io.to(name).emit("updateRoom", updatedRoom);
  } catch (error) {
    console.error(error);
    socket.emit("serverError", "Something went wrong");
  }
};

export const paint = async (io, socket, { details, roomName }) => {
  try {
    io.to(roomName).emit("points", {
      details,
    });
  } catch (error) {
    console.error(error);
    socket.emit("serverError", "Something went wrong");
  }
};

export const colorChange = async (io, socket, { color, roomName }) => {
  try {
    io.to(roomName).emit("color-change", color);
  } catch (error) {
    console.error(error);
    socket.emit("serverError", "Something went wrong");
  }
};

export const strokeWidth = async (io, socket, { value, roomName }) => {
  try {
    io.to(roomName).emit("stroke-width", value);
  } catch (error) {
    console.error(error);
    socket.emit("serverError", "Something went wrong");
  }
};

export const clearScreen = async (io, socket, { roomName }) => {
  try {
    io.to(roomName).emit("clear-screen", "");
  } catch (error) {
    console.error(error);
    socket.emit("serverError", "Something went wrong");
  }
};

export const message = async (io, socket, { roomName, message, timeTaken }) => {
  try {
    const room = await Room.findOne({ name: roomName });
    if (!room) return;
    const player = room.players.find((player) => player.socketId === socket.id);
    if (!player) return;
    if (message === room.word) {
      if (timeTaken !== 0) {
        player.points += Math.round((200 / timeTaken) * 10);
      }
      player.getUserCtr += 1;
      await room.save();
      io.to(roomName).emit("message", {
        nickname: player.nickname,
        avatarId: player.avatarId,
        message: "Guessed it!",
        guessedUserCtr: player.getUserCtr,
      });
    } else {
      io.to(roomName).emit("message", {
        nickname: player.nickname,
        avatarId: player.avatarId,
        message,
        guessedUserCtr: player.getUserCtr,
      });
    }
  } catch (error) {
    console.error(error);
    socket.emit("serverError", "Something went wrong");
  }
};

export const changeTurn = async (io, socket, name) => {
  try {
    const room = await Room.findOne({ name });
    if (!room) return;
    const index = room.turnIndex;
    if (index + 1 === room.players.length) {
      room.currentRound += 1;
    }
    if (room.currentRound <= room.maxRounds) {
      const word = getWord();
      room.word = word;
      room.turnIndex = (index + 1) % room.players.length;
      room.turn = room.players[room.turnIndex];
      await room.save();
      io.to(name).emit("change-turn", room);
    } else {
    }
  } catch (error) {
    console.error(error);
    socket.emit("serverError", "Something went wrong");
  }
};

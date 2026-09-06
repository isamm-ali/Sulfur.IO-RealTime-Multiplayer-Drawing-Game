import { Room } from "../models/room.js";
import { getWord } from "../services/getWord.js";

export const createGame = async (
  io,
  socket,
  { nickname, name, occupancy, maxRounds },
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

export const joinGame = async (
  io,
  socket,
  { nickname, name },
) => {
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
          },
        },
      },
      { new: true },
    );
    if (!updatedRoom) {
      socket.emit("notCorrectGame", "Room no longer exists!");
      return;
    }
    updatedRoom.turn =
        updatedRoom.players[updatedRoom.turnIndex];
    await updatedRoom.save();
    socket.join(name);
    io.to(name).emit("updateRoom", updatedRoom);
  } catch (error) {
    console.error(error);
    socket.emit("serverError", "Something went wrong");
  }
};

export const paint = async (
  io,
  socket,
  { details, roomName },
) => {
  io.to(roomName).emit("points", {
    details: details,
  });
};
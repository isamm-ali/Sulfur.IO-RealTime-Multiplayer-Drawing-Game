import { createGame, joinGame, paint } from "../controllers/socketController.js";

export const SocketServer = (io) => {
  io.on("connection", (socket) => {
    console.log("User connected: ", socket.id);
    socket.on("create-game", (data) => createGame(socket, data, io));
    socket.on("join-game", (data) => joinGame(socket, data, io));
    socket.on("paint", (data) => paint(data, io));
  });
};
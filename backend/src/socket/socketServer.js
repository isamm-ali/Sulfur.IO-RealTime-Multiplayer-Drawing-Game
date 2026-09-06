import {
  createGame,
  joinGame,
  paint,
} from "../controllers/socketController.js";

export const SocketServer = (io) => {
  io.on("connection", (socket) => {
    console.log("User connected:", socket.id);

    socket.on("create-game", (data) => {
      createGame(io, socket, data);
    });

    socket.on("join-game", (data) => {
      joinGame(io, socket, data);
    });

    socket.on("paint", (data) => {
      paint(io, socket, data);
    });

    socket.on("disconnect", () => {
      console.log("User disconnected:", socket.id);
    });
  });
};

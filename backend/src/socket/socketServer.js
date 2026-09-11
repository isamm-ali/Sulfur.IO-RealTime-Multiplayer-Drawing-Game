import {
  changeTurn,
  clearScreen,
  colorChange,
  createGame,
  joinGame,
  message,
  paint,
  strokeWidth,
  disconnect,
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
    socket.on("color-change", ({ color, roomName }) =>
      colorChange(io, socket, { color, roomName }),
    );
    socket.on("stroke-width", ({ value, roomName }) =>
      strokeWidth(io, socket, { value, roomName }),
    );
    socket.on("clear-screen", ({ roomName }) =>
      clearScreen(io, socket, { roomName }),
    );
    socket.on("message", (data) => message(io, socket, data));
    socket.on("change-turn", (data) => changeTurn(io, socket, data));
    socket.on("disconnect", () => disconnect(socket));
  });
};

import { createGame, joinGame } from "../controllers/socketController.js";

export const SocketServer = (io) => {
    io.on('connection', (socket) => {
        console.log('User connected: ', socket.id);
        socket.on('create-game', createGame);
        socket.on('join-game', joinGame )
    });
}
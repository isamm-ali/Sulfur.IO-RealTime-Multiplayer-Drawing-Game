import dotenv from "dotenv";
import http from "http";
import dns from 'dns';
import { app } from "./app.js";
import { connectDB } from "./config/database.js";
import { Server } from "socket.io";
import { socketServer } from "./socket/socketServer.js";

dotenv.config();
dns.setServers(["1.1.1.1", "8.8.8.8"]);
const PORT = process.env.PORT;
const httpServer = http.createServer(app);

const io = new Server(httpServer, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
  transports: ["polling", "websocket"],
});
socketServer(io);

try {
  await connectDB();
} catch (error) {
  console.error("Database connection failed:", error);
  process.exit(1);
}

httpServer.listen(PORT, () => {
  console.log(`Server is running on ${PORT}`);
});

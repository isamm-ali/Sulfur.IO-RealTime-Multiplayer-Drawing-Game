import mongoose from "mongoose";
import { playerSchema } from "./player.js";

const roomSchema = new mongoose.Schema({
  word: {
    required: true,
    type: String,
  },
  name: {
    required: true,
    type: String,
    unique: true,
    trim: true,
  },
  occupancy: {
    required: true,
    type: String,
    default: 2,
  },
  maxRounds: {
    required: true,
    type: Number,
  },
  currentRound: {
    required: true,
    type: Number,
    default: 1,
  },
  players: [playerSchema],
  isJoin: {
    type: Boolean,
    default: true,
  },
  turn: playerSchema,
  turnIndex: {
    type: Number,
    default: 0,
  },
});

export const Room = new mongoose.model("Room", roomSchema);

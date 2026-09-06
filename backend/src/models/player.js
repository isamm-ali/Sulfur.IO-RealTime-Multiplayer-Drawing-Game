import mongoose from "mongoose";

export const playerSchema = new mongoose.Schema({
  nickname: {
    type: String,
    trim: true,
  },
  socketId: {
    type: String,
  },
  isPartyLeader: {
    type: Boolean,
    default: false,
  },
  points: {
    type: Number,
    default: 0,
  },
});

export const playerModel = new mongoose.model("Player", playerSchema);

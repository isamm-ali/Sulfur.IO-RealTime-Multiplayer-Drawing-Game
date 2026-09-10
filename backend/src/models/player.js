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
  avatarId: {
    type: String,
    required: true,
  },
});

export const playerModel = mongoose.model("Player", playerSchema);

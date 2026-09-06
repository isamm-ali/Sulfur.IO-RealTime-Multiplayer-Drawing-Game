import mongoose from "mongoose";

export const connectDB = async () => {
  try {
    const connectionString = process.env.MONGODB_CONNECTION_STRING;
    await mongoose.connect(connectionString);
    console.log("Database connection successful");
  } catch (error) {
    console.error("MongoDB connection failed:", error);
  }
};
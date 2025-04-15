
const mongoose = require("mongoose");


//check database connected or not

const connectDB = async () => {
    try {
      await mongoose.connect("mongodb://localhost:27017/askmytutor", {
        useNewUrlParser: true,
        useUnifiedTopology: true,
      });
      console.log("✅ Database connected successfully.");
    } catch (error) {
      console.error("❌ Database connection failed:", error.message);
      process.exit(1);
    }
  };
  
  module.exports = connectDB;
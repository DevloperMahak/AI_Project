
const mongoose = require("mongoose");


//check database connected or not

const connectDB = async () => {
    try {
      await mongoose.connect("mongodb+srv://mahak-gupta-09:MysafePassword@cluster-askmytutor.8whvt4e.mongodb.net/?retryWrites=true&w=majority&appName=Cluster-askmytutor", {
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
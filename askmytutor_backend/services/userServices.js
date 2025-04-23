const Tesseract = require('tesseract.js');
const { PSM } = Tesseract; 
const path = require('path');
const axios = require('axios');
const User = require('../models/signup_model');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const signupModel = require('../models/signup_model');


// Perform OCR on the given image
const performOCR = async (imagePath) => {
  const fullPath = path.resolve(imagePath);
  try {
  // Tesseract OCR processing with logging and better error handling
  const result = await Tesseract.recognize(fullPath, 'eng', {
    logger: m => console.log(m), // Optional: Logs OCR progress
    tessedit_pageseg_mode: Tesseract.PSM.SINGLE_BLOCK,  // or try PSM.SPARSE_TEXT
    tessedit_char_whitelist: '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-*/=<>():,.%',
  });

  // ✅ Log raw OCR result before any cleanup
  console.log("Raw OCR Output:", result.data.text);
  
  if (result && result.data && result.data.text) {
    return result.data.text.trim(); // Return trimmed text from OCR
  } else {
    throw new Error('No text extracted from the image');
  }
} catch (error) {
  console.error('OCR Error:', error.message);
  throw new Error('Failed to extract text from the image');
}
};

// Subject-based prompt mapping
const subjectPromptMap = {
  math: "Solve the following math problem: ",
  science: "Explain the following science concept: ",
  history: "Tell me about the following historical event: ",
  literature: "Explain the meaning of the following literature: ",
  // Add more subjects as needed
};



async function askGROQ(prompt,subject = 'general') {

   // Use the subjectPromptMap to prepend the subject-specific message
   const subjectPrompt = subjectPromptMap[subject] || "";
   const fullPrompt = subjectPrompt + prompt;  // Combine subject prompt with the user prompt
  
  try {
  const response = await axios.post(
    'https://api.groq.com/openai/v1/chat/completions',
    {
      model: 'llama-3.3-70b-versatile',
      messages: [{ role: 'user', content: fullPrompt }],
    },
    {
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${process.env.GROQ_API_KEY}`,
      },
    }
  );
  return response.data.choices[0].message.content;
}catch (error) {
  console.error("GROQ API Error:", error.response ? error.response.data : error.message); // Log the error response
  throw error; // Rethrow the error after logging it
}
}


const createUser = async (name, email, password) => {
  // Check if user already exists
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    throw new Error("User already exists with this email");
  }

  // Create new user
  const user = new User({
    name,
    email,
    password,
  });

  await user.save();
  console.log("✅ User saved successfully:", user); // Add this line
  return user;
};

// Function to log in a user and return a JWT token
const loginUser = async (email, password) => {
  const user = await User.findOne({ email });
  if (!user) {
    throw new Error('User not found');
  }

  console.log("Entered password (raw):", password);
console.log("Password from DB (hashed):", user.password);
console.log("Entered password length:", password.length);
console.log("Password from DB length:", user.password.length);


  const isPasswordValid = await bcrypt.compare(password.trim(),user.password);

  console.log("Password match:", isPasswordValid);
  if (!isPasswordValid) {
    throw new Error('Invalid password');
  }

  // Create JWT token
  const token = jwt.sign(
    { id: user._id, email: user.email },
    process.env.JWT_SECRET, // Use a secret key from environment variables
    { expiresIn: '1h' } // Token expiration
  );

  return { user, token };
};

const sendResetLink = async (email) => {
  const user = await User.findOne({ email });

  if (!user) {
    return { status: false, message: "User not found" };
  }

  // Generate a JWT token valid for 15 minutes
  const token = jwt.sign({ email }, process.env.JWT_SECRET, { expiresIn: '15m' });

  // Simulate sending email (log the reset link)
  console.log(`Send email to ${email} with reset link: https://askmytutor-l6m0nu1np-devlopermahaks-projects.vercel.app/forgotpassword?token=${token}`);

  return { status: true, message: "Reset link sent" };
};


module.exports = { performOCR, askGROQ , createUser, loginUser, sendResetLink,};

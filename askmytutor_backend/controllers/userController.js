const { performOCR , askGROQ , createUser,loginUser} = require('../services/userServices');
const sharp = require('sharp');  // Use sharp for image preprocessing
const path = require('path');


// Preprocess image and perform OCR
const preprocessImage = async (imagePath) => {
  console.log('Original uploaded image path:', imagePath);
  try {
    const processedImagePath = path.join(__dirname, '..', 'uploads', 'processed_' + Date.now() + '.jpg');

    // Preprocess the image (resize, grayscale, and normalize)
    await sharp(imagePath)
      .resize({ width: 1000 })  // Resize the image to a manageable size
      .grayscale()  // Convert the image to grayscale
      .normalize()  // Improve contrast
      .threshold(150)            // ADD THIS: force high contrast
      .linear(1.5, -10)  // Increase contrast and brightness (optional)
      .sharpen()
      .toFile(processedImagePath);

    return processedImagePath;  // Return the path of the processed image
  } catch (error) {
    console.error('Error during image preprocessing:', error);
    throw new Error('Image preprocessing failed');
  }
};


const extractTextFromImage = async (req, res) => {
  try {
    const imagePath = req.file.path;
    console.log('Uploaded file:', req.file);

    // Preprocess the image to improve OCR accuracy
    const processedImagePath = await preprocessImage(imagePath);

     // Now perform OCR on the processed image
     const text = await performOCR(processedImagePath);

     // Clean up the extracted text (e.g., trim whitespace, remove unwanted characters)
     const cleanedText =  text
     .replace(/[^\w\s.,:;!?()+\-*/=<>^%]/g, '')  // allow common math symbols
     .replace(/\s+/g, ' ')  // normalize spaces
     .trim();

     console.log('Cleaned Text for GROQ:', cleanedText);


    // Respond with the extracted text
    res.status(200).json({ success: true, extractedText: cleanedText });
    
  } catch (err) {
    console.error('OCR Error:', err);
    res.status(500).json({ success: false, message: 'Failed to extract text' });
  }
};



const getAnswer = async (req, res) => {
  try {
    const { prompt,subject = 'general'  } = req.body; // Accept the subject along with the prompt

    // Log the user prompt and subject
    console.log('User Prompt:', prompt);
    console.log('Subject:', subject);

    // Log the user prompt to the console
    console.log('User Prompt:', prompt);

    if (!prompt) {
      return res.status(400).json({ error: 'Prompt is required' });
    }

    // Send back the AI response
    const response = await askGROQ(prompt, subject);
    res.json({ answer: response });
    
  } catch (error) {
    res.status(500).json({ error: 'GROQ API Error', details: error.message });
  }
};

// Controller for registering a new user
const signupUser = async (req, res) => {
  const { name, email, password } = req.body;

  // Basic validation
  if (!name || !email || !password) {
    return res.status(400).json({ message: "Please fill all fields" });
  }
  console.log("📦 Incoming Data:", req.body);
  try {
    const user = await createUser(name, email, password);
    res.status(200).json({ message: "User created successfully", user });
  } catch (err) {
    console.error(err);
    res.status(400).json({ message: err.message });
  }
};

// Controller for logging in an existing user
const loginUserController = async (req, res) => {
  try {
    const { email, password } = req.body;
    const { user, token } = await loginUser(email, password);
    if (user) {
      return res.status(200).json({
        status: true,
        message: 'Login successful',
        token: token // Return token to frontend
      });
    } else {
      return res.status(400).json({
        status: false,
        message: 'Invalid email or password'
      });
    }
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      status: false,
      message: 'Server error'
    });
  }
};

module.exports = {
  extractTextFromImage,
  getAnswer,
  signupUser,
  loginUserController
};

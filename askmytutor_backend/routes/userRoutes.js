const express = require('express');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const { extractTextFromImage,getAnswer,signupUser,loginUserController,forgotPassword } = require('../controllers/userController');

const router = express.Router();


// ✅ Resolve absolute path to root-level uploads folder
const uploadDir = path.join(__dirname, '..', 'uploads');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// Multer setup for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir); // points outside `src`
  },
  filename: (req, file, cb) => cb(null, Date.now() + '-' + file.originalname),
});

const upload = multer({ storage });

// POST route for image upload and OCR
router.post('/upload-image', upload.single('image'), extractTextFromImage);

// POST route for getting answer from GROQ
router.post('/ask', getAnswer);

// POST route for getting User Details
router.post('/signup', signupUser);

// Route to handle user login
router.post('/login', loginUserController);

router.post("/forgot-password", forgotPassword);

router.get('/user', async (req, res) => {
  const email = req.query.email;
  // fetch and return user details using email
});



module.exports = router;

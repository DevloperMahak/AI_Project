const express = require('express');
const multer = require('multer');
const { extractTextFromImage,getAnswer } = require('../controllers/userController');

const router = express.Router();

// Multer setup for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + '-' + file.originalname),
});

const upload = multer({ storage });

// POST route for image upload and OCR
router.post('/upload-image', upload.single('image'), extractTextFromImage);

// POST route for getting answer from GROQ
router.post('/ask', getAnswer);


module.exports = router;

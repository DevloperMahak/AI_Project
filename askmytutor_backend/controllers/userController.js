const { performOCR , askGROQ } = require('../services/userServices');

const extractTextFromImage = async (req, res) => {
  try {
    const imagePath = req.file.path;
    const text = await performOCR(imagePath);
    res.status(200).json({ success: true, extractedText: text });
  } catch (err) {
    console.error('OCR Error:', err);
    res.status(500).json({ success: false, message: 'Failed to extract text' });
  }
};



const getAnswer = async (req, res) => {
  try {
    const { prompt } = req.body;

    // Log the user prompt to the console
    console.log('User Prompt:', prompt);

    // Send back the AI response
    const response = await askGROQ(prompt);
    res.json({ answer: response });
    
  } catch (error) {
    res.status(500).json({ error: 'GROQ API Error', details: error.message });
  }
};

module.exports = {
  extractTextFromImage,
  getAnswer,
};

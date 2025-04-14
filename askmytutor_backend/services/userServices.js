const Tesseract = require('tesseract.js');
const path = require('path');
const axios = require('axios');

const performOCR = async (imagePath) => {
  const fullPath = path.resolve(imagePath);
  const result = await Tesseract.recognize(fullPath, 'eng', {
    logger: m => console.log(m), // Optional: Logs OCR progress
  });
  return result.data.text;
};





async function askGROQ(prompt) {
  console.log("Using API Key:", process.env.GROQ_API_KEY); // Just to debug (remove later)
  
  try {
  const response = await axios.post(
    'https://api.groq.com/openai/v1/chat/completions',
    {
      model: 'llama-3.3-70b-versatile',
      messages: [{ role: 'user', content: prompt }],
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

module.exports = { performOCR, askGROQ };

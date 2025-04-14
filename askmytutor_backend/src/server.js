const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });
const express = require('express');
const cors = require('cors');
const userRoutes = require('../routes/userRoutes');

const app = express();
const PORT = process.env.PORT || 5001;

app.use(express.json());// Parses incoming JSON bodies
app.use(cors());// Enables cross-origin requests
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/api/user', userRoutes);


app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`); //This allows access from other devices in the network.
});


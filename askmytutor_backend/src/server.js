
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });
const http = require('http');
const { Server } = require('socket.io');
const express = require('express');
const connectDB = require('../config/db');
const cors = require('cors');
const userRoutes = require('../routes/userRoutes');

// Create express app first ✅
const app = express();

// Then create HTTP server using the app ✅
const server = http.createServer(app);

// Then setup Socket.IO ✅
const io = new Server(server, {
  cors: {
    origin: "*",
  }
});

io.on('connection', (socket) => {
  console.log('A user connected: ' + socket.id);

  socket.on('send_message', (data) => {
    io.emit('receive_message', data);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected: ' + socket.id);
  });
});

connectDB();
const PORT = process.env.PORT || 10000;

app.get('/', (req, res) => {
  res.send('Server is running');
});


app.use(express.json());// Parses incoming JSON bodies

// Allow requests from your frontend URL
app.use(cors(
  {
    origin: 'https://askmytutor-l6m0nu1np-devlopermahaks-projects.vercel.app ',  // replace with your frontend URL
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
  credentials: true
  }
));// Enables cross-origin requests

// ✅ Serve uploads statically from root-level path
app.use('/uploads', express.static(path.join(__dirname, '..', 'uploads')));

app.use('/api/user', userRoutes);


server.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`); //This allows Run both Express and Socket.IO properly from other devices in the network.
});


const express = require('express');
const http = require('http');
const mongoose = require('mongoose');
const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
const Room = require('./models/room');
// const Room1 = require('./models/room1');
const usermodel = require('./models/user_model');
var io = require('socket.io')(server);
app.use(express.json());
const cors = require('cors');
const players = require('./models/player');
const Tournament = require('./models/tournament');
app.use(cors());

const DB = "mongodb+srv://Reetinder:reet12345@cluster0.qigfhyu.mongodb.net/?retryWrites=true&w=majority";

io.on("connection", (socket) => {
  console.log("connected!");

  socket.on("createroom", async ({ username }) => {
    console.log(username);
    try {
      let room = new Room();
      let player = {
        socketID: socket.id,
        username: username,
        playerType: 'X',
        points: 0,
      };
      room.players.push(player);
      room.turn = player;
      room = await room.save();
      // mongo db itself create room id
      const roomId = room._id.toString();
      socket.join(roomId);
      console.log(room);
      // io ->send data to server and goes to everyone
      // socket->send data to yourself
      // the server send a success message to everyone in room
      io.to(roomId).emit('createroomsuccess', room);

    } catch (e) {
      console.log(e);
    }
  });

  socket.on("createuser", async ({ username, email, password }) => {
    try {
      if (!email.match((/^[^\s@]+@[^\s@]+\.[^\s@]+$/))) {
        socket.emit('errorOccurred', 'Invalid email address.');
        return;
      }
      let users = new usermodel();
      let player = {
        username: username,
        email: email,
        password: password,
        socketID: socket.id,
      }
      users.user.push(player);
      users = await users.save();
      const userid = users._id.toString();
      socket.join(userid);
      console.log(users);
      io.to(userid).emit('usercreatesuccess', users);
    } catch (e) {
      console.log(e);
    }
  });
  socket.on('loginuser', async ({ username1, password }) => {
    try {
      const user = await usermodel.findOne({ 'user.username': username1 });

      if (user) {
        if (password === user.user[0].password) {

          io.to(socket.id).emit('loginsuccess', user);
        } else {
          io.to(socket.id).emit('loginError', 'Invalid credentials');
        }
      } else {

        io.to(socket.id).emit('loginError', 'User not found');
      }
    } catch (e) {
      console.log(e);
      io.to(socket.id).emit('loginError', 'An error occurred during login');
    }
  });


  socket.on('joinroom', async ({ username, roomId }) => {
    try {
      if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
        socket.emit('errorOccurred', 'Please enter valid room Id.');
        return;
      }
      let room = await Room.findById(roomId);
      if (room.isjoin) {
        let player = {
          username: username,
          socketID: socket.id,
          playerType: "O",
        }
        socket.join(roomId);
        room.players.push(player);
        room.isjoin = false;
        room = await room.save();
        io.to(roomId).emit('joinroomsuccess', room);
        // we create update players so we donot have to manually wpdate the
        // players in our app 
        io.to(roomId).emit('updateplayers', room.players);
        io.to(roomId).emit('updateroom', room);
      } else {
        socket.emit('errorOccurred', 'Try Again Later.');
      }
    } catch (e) {
      console.log(e);
    }
  })
  socket.on('tap', async ({ index, roomId }) => {
    try {
      let room = await Room.findById(roomId);
      let choice = room.turn.playerType;
      if (room.turnIndex == 0) {
        room.turn = room.players[1];
        room.turnIndex = 1;
      } else {
        room.turn = room.players[0];
        room.turnIndex = 0;
      }
      room = await room.save();
      io.to(roomId).emit('tapped', {
        index, choice, room
      })
    } catch (e) {
      console.log(e);
    }
  });
  socket.on('winner', async ({ winnerSocketId, roomId }) => {
    try {
      let room = await Room.findById(roomId);
      let player = room.players.find((playerr) => playerr.socketID == winnerSocketId);
      player.points = player.points + 1;
      room = await room.save();
      if (player.points == room.maxRounds) {
        io.to(roomId).emit('endgame', player);
      } else {
        io.to(roomId).emit('increasepoint', player);
      }

    } catch (e) {
      console.log(e);
    }
  });

  //  ??TOURNAMENT

  // let createdRoomCount = 0;
  // const maxPlayersPerRoom = 2;
  // const totalRoomsInTournament = 4;

  // socket.on('joinTournamentRoom', async ({ username }) => {
  //   try {
  //     // Find an available tournament or create a new one
  //     let tournament = await Tournament.findOne({ isFull: false });

  //     if (!tournament) {
  //       tournament = new Tournament();
  //     }

  //     // Find or create a room for the player
  //     let room = await Room1.findOne({ tournament: tournament._id, isFull: false });

  //     if (!room) {
  //       room = new Room1({ tournament: tournament._id });
  //     }

  //     let player = {
  //       socketID: socket.id,
  //       username: username,
  //       playerType: room.players.length === 0 ? 'X' : 'O', // Assign 'X' or 'O'
  //     }

  //     room.players.push(player);
  //     room.turn = player;
  //     await room.save();
  //     console.log(room);

  //     socket.join(room._id.toString());
  //     io.to(room._id.toString()).emit('joinTournamentRoomSuccess', room);

  //     // Check if the room is now full
  //     if (room.players.length === maxPlayersPerRoom) {
  //       room.isFull = true;
  //       await room.save();
  //       io.to(room._id.toString()).emit('startGame', room);

  //       // Check if all rooms in the tournament are full
  //       const tournamentRooms = await Room1.find({ tournament: tournament._id });
  //       if (tournamentRooms.every((r) => r.isFull)) {
  //         tournament.isFull = true;
  //         await tournament.save();
  //         io.emit('startTournament', tournament);
  //       }
  //     }
  //   } catch (e) {
  //     console.error(e);
  //     socket.emit('joinTournamentRoomError', 'An error occurred while joining the tournament room.');
  //   }
  // });

  // // Add other game-related socket events (e.g., tap, winner) here

  // socket.on('disconnect', () => {
  //   console.log('Player disconnected:', socket.id);
  //   // Implement logic to handle player disconnection if needed
  // });
});



mongoose.connect(DB).then(() => {
  console.log("Connection to MongoDB successful");
}).catch((e) => {
  console.log(e);
});

server.listen(port, '0.0.0.0', () => {
  console.log(`Server started at port ${port}`);
});

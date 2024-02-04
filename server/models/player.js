const mongoose = require('mongoose');

const player = new mongoose.Schema({
    username: {
        type: String,
        trim: true,
    },
    socketID: {
        type: String,
    },
    points: {
        type: Number,
        default: 0,
    },
    playerType: {
        required: true,
        type: String,
    },
    email: {
        type: String,
        unique: true
    },
    password: {
        type: String,
    }

});
module.exports = player;
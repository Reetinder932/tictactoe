const mongoose = require("mongoose");
const player = require("./player");

const room = new mongoose.Schema({
    occupancy: {
        type: Number,
        default: 2,
    },
    maxRounds: {
        type: Number,
        default: 3,
    },
    currentround: {
        required: true,
        type: Number,
        default: 1,
    },
    players: [player],
    isjoin: {
        type: Boolean,
        default: true,
    },
    turn: player,
    // use for turn record
    turnIndex: {
        type: Number,
        default: 0,
    },
});
// convert to model so that we can use in pages and database
const roomModel = mongoose.model('Room', room);
module.exports = roomModel;
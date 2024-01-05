const mongoose = require('mongoose');

const serviceProviderSchema = new mongoose.Schema({
    name: {
        type: String
    },
    email: {
        required: true,
        unique: true,
        type: String,
        trim: true,
    },
    mobile: {
        unique: true,
        required: true,
        type: String
    },
    password: {
        type: String
    }
});
module.exports = mongoose.model("ServiceProvider", serviceProviderSchema);
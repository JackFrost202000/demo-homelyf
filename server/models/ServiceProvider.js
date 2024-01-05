const mongoose = require('mongoose');

const serviceProviderSchema = new mongoose.Schema({
    name: {
        type: String
    },
    email: {
        type: String,
        required: true,
    },
    password: {
        type: String
    }
});
module.exports = mongoose.model("ServiceProvider", serviceProviderSchema);
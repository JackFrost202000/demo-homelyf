const mongoose = require('mongoose');
const { generateOTP, sendEmail } = require('../services/util');

const otpSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
    },
    otp: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
        expires: 60 * 5,
    },
});

otpSchema.pre("save", async function (next) {
    console.log("New document saved to the database");
    if (this.isNew) {
        // await sendVerificationEmail(this.email, this.otp);
        const message = `Verfication code is ${this.otp}`
        await sendEmail(this.email, "", "", message);
    }
    next();
});
module.exports = mongoose.model("OTP", otpSchema);
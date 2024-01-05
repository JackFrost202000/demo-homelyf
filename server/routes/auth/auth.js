const express = require("express");
const User = require("../../models/user");
const bcryptjs = require("bcryptjs");

const authRouter = express.Router();
const jwt = require("jsonwebtoken");

const auth = require("../../middlewares/auth");
const { sendEmail, generateOTP } = require("../../services/util");
const otpVerification = require("../../models/otpVerification");
const googleAuthRouter = require("./googleAuth");

authRouter.use(googleAuthRouter);

authRouter.post("/api/sendEmail-otp", async (req, res) => {
  const { email } = req.body;

  try {
    const OTP = generateOTP();
    const otpBody = await otpVerification.create({ email: email, otp: OTP });
    console.log(otpBody);

    res.status(200).json({ msg: "OTP sent succesfully" })
  } catch (error) {
    console.log(error);
    res.status(401).json({ msg: "Failed to send OTP." })
  }
});

// authRouter.post("/api/verify-otp", async (req, res) => {
//   try {
//     const { email, otp } = req.body;

//     // Fetch the latest OTP from the database
//     const latestOTP = await otpVerification
//       .find({ email })
//       .sort({ createdAt: -1 })
//       .limit(1);

//     if (latestOTP.length === 0 || otp !== latestOTP[0].otp) {
//       return res.status(400).json({
//         success: false,
//         message: "Invalid OTP.",
//       });
//     }

//     // OTP is valid, you can proceed with user authentication
//     res.json({ success: true, message: "OTP verified successfully." });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }
// });

authRouter.post('/api/verify-otp', async (req, res) => {
  const { email, otp } = req.body;

  try {
    const response = await otpVerification.find({ email }).sort({ createdAt: -1 }).limit(1);

    if (response.length === 0 || otp !== response[0].otp) {
      return res.status(400).json({
        success: false,
        message: "The OTP is not valid",
      });
    }

    // OTP is valid, you can perform additional actions here if needed
    console.log(email);
    console.log(otp);
    return res.status(200).json({
      success: true,
      message: "OTP verification successful",
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

// SIGN UP
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }

    let user = new User({
      email,
      password,
      name,
    });
    user = await user.save();
    await sendEmail(email, "", "", "welcome to our platform test email asdnsadijasdn.");
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Sign In Route
// Exercise
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// get user data
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
});

module.exports = authRouter;
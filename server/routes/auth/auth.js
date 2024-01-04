const express = require("express");
const User = require("../../models/user");
const bcryptjs = require("bcryptjs");

const authRouter = express.Router();
const jwt = require("jsonwebtoken");

const auth = require("../../middlewares/auth");
const { sendEmail, generateOTP } = require("../../services/util");
const otpVerification = require("../../models/Otp");
const googleAuthRouter = require("./googleAuth");

authRouter.use(googleAuthRouter);

// SIGN UP
authRouter.post("/api/sendEmail-otp", async (req, res) => {
  const { email } = req.body;
  if (email == null || email == undefined) {
    res.status(401).json({ msg: "Failed to send OTP." })
  }
  try {
    const OTP = generateOTP();
    const otpBody = await otpVerification.create({ email: email, otp: OTP });
    console.log(otpBody);

    res.status(200).json({ msg: "OTP sent succesfully" })
  } catch (error) {
    console.log(error.message);
    res.status(401).json({ msg: "Failed to send OTP." })
  }
})

authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, mobile, password, otp } = req.body;
    console.log(req.body, typeof otp);

    const existingUser = await User.findOne({
      $or: [
        { email: email },
        { mobile: mobile }
      ]
    });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email or mobile already exists!" });
    }

    const response = await otpVerification.find({ email }).sort({ createdAt: -1 }).limit(1);
    console.log("otp is :", response);
    if (response.length === 0) {
      return res.status(400).json({
        success: false,
        msg: "The OTP is not valid",
      });
    } else if (otp != response[0].otp) {
      return res.status(400).json({
        success: false,
        msg: "The OTP is not valid",
      });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      email,
      mobile,
      password: hashedPassword,
      name,
    });
    user = await user.save();
    await sendEmail(email, "", "", "welcome to homeLyf services.")

    const token = jwt.sign({ id: user.email }, "passwordKey");

    res.json({ user, token });
  } catch (e) {
    console.log(e);
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

    const token = jwt.sign({ id: user.email }, "passwordKey");
    // req.user = {
    //   provider:"simple",
    //   displayName:user.name,
    //   email:user.email
    // }

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
authRouter.get("/test", async (req, res) => {
  res.json({ user: req.user });
});


module.exports = authRouter;

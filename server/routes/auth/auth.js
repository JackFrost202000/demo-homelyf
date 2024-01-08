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

const swaggerJSDoc = require("swagger-jsdoc");
const swaggerUI = require("swagger-ui-express");

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'HomeLyf API Testing',
      version: '1.0.0',
    },
    servers: [
      {
        url: 'https://homelyf-demo.onrender.com'
      }
    ]
  },
  apis: ['./auth.js'], // files containing annotations as above
};

const swaggerSpec = swaggerJSDoc(options);
authRouter.use('/api-docs', swaggerUI.serve, swaggerUI.setup(swaggerSpec));


/**
 * @swagger
 * /api/sendEmail-otp:
 *   post:
 *     summary: Send OTP via email
 *     description: Send OTP to the provided email address for verification.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *     responses:
 *       200:
 *         description: OTP sent successfully
 *       401:
 *         description: Failed to send OTP
 */
authRouter.post("/api/sendEmail-otp", async (req, res) => {
  try {
    const { email, mobile } = req.body;
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
    } else {
      const OTP = generateOTP();
      const otpBody = await otpVerification.create({ email: email, otp: OTP });
      console.log(otpBody);

      res.status(200).json({ msg: "OTP sent succesfully" })
    }
  } catch (error) {
    console.log(error);
    res.status(401).json({ msg: "Failed to send OTP." })
  }
});

authRouter.post("/api/sendEmail-forgotPassword-otp", async (req, res) => {
  try {
    const { email, mobile } = req.body;

    const OTP = generateOTP();
    const otpBody = await otpVerification.create({ email: email, mobile: mobile, otp: OTP });
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

/**
 * @swagger
 * /api/verify-otp:
 *   post:
 *     summary: Verify OTP
 *     description: Verify the OTP sent to the user's email address.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               otp:
 *                 type: string
 *     responses:
 *       200:
 *         description: OTP verified successfully
 *       400:
 *         description: Invalid OTP
 */
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

/**
 * @swagger
 * /api/signup:
 *   post:
 *     summary: User Sign Up
 *     description: Register a new user account.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               email:
 *                 type: string
 *               mobile:
 *                 type: string
 *               password:
 *                 type: string
 *               otp:
 *                 type: string
 *     responses:
 *       200:
 *         description: User signed up successfully
 *       400:
 *         description: Invalid data or user already exists
 */
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

    const token = jwt.sign({ id: user.email }, process.env.JWT_KEY);

    res.json({ token, ...user._doc });
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});

/**
 * @swagger
 * /api/signin:
 *   post:
 *     summary: User Sign In
 *     description: Authenticate a user and generate an access token.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: User signed in successfully
 *       400:
 *         description: Incorrect email or password
 */
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
    console.log(process.env.JWT_KEY);
    const token = jwt.sign({ id: user._id }, process.env.JWT_KEY);
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

/**
 * @swagger
 * /api/forgotpassword:
 *   post:
 *     summary: Forgot Password
 *     description: Reset the user's password using OTP.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               newPassword:
 *                 type: string
 *               otp:
 *                 type: string
 *     responses:
 *       200:
 *         description: Password updated successfully
 *       400:
 *         description: Invalid email, OTP, or failed to update password
 */
authRouter.post("/api/forgotpassword", async (req, res) => {
  try {
    const { email, newPassword, otp } = req.body;
    console.log(email, newPassword, otp);
    if (!email || !newPassword || !otp) {
      return res.status(400).json({ msg: "Enter valid email or password." })
    }

    const existingUser = await User.findOne({
      $or: [
        { email: email }
      ]
    });
    console.log(existingUser);
    if (existingUser == null || existingUser.length == 0) {
      return res.status(400).json({ msg: "User with email does not exist.." });
    }

    const response = await otpVerification.find({ email }).sort({ createdAt: -1 }).limit(1);
    console.log("otp is :", response);
    if (!response || response.length == 0 || response[0].otp !== otp) {
      return res.status(400).json({ msg: "Failed to verify otp." })
    }

    const hashedPassword = await bcryptjs.hash(newPassword, 8);
    let doc = await User.findOneAndUpdate({ email: email }, { password: hashedPassword });
    console.log("updated : ", doc);
    if (!doc || doc.length == 0) {
      return res.status(400).json({ msg: "Failed to update password." });
    }

    return res.status(200).json({ msg: "Password updated successfully." })
  } catch (error) {
    console.log(error);
    return res.status(400).json({ msg: "Failed to update password" })
  }
})

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, process.env.JWT_KEY);
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

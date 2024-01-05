// IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const session = require('express-session');
const passport = require('passport');

const app = express();

// IMPORTS FROM OTHER FILES
const adminRouter = require("./routes/admin");
const authRouter = require("./routes/auth/auth");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");

// middleware
app.use(cors());
app.use(express.json());
app.use(session({ secret: 'cats', resave: false, saveUninitialized: true }));
app.use(passport.initialize());
app.use(passport.session());

app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

// INIT
const PORT = process.env.PORT || 3000;

const DB =
  "mongodb+srv://jackfrost2001:EhOLjUkP877mRXHs@cluster0.wnjkzcd.mongodb.net/?retryWrites=true&w=majority";



// Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});

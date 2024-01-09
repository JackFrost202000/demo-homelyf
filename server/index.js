// IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const session = require('express-session');
const passport = require('passport');
require('dotenv').config();

//SWAGGER DOCS
const swaggerJSDoc = require("swagger-jsdoc");
const swaggerUI = require("swagger-ui-express");

const app = express();

// IMPORTS FROM OTHER FILES
const adminRouter = require("./routes/admin");
const authRouter = require("./routes/auth/auth");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user/user");

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

const DB = process.env.MONGO_URI;



// Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

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
  apis: ['./routes/auth/*.js'],
};

const swaggerSpec = swaggerJSDoc(options);
app.use("/api-docs", swaggerUI.serve, swaggerUI.setup(swaggerSpec));

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});

const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth2').Strategy;
const express = require("express");
const jwt = require("jsonwebtoken");

// const ServiceProviderModel = require('../../models/ServiceProvider');
const router = express.Router();

passport.use(new GoogleStrategy({
    clientID: process.env.GOOGLEAUTH_CLIENT_ID,
    clientSecret: process.env.GOOGLEAUTH_CLIENT_SECRET,
    callbackURL: process.env.GOOGLEAUTH_CALLBACK_URL,
    passReqToCallback: true,
},
    async function (request, accessToken, refreshToken, profile, done) {
        console.log("in callback, ", profile.displayName, profile.email);
        console.log(accessToken, refreshToken);
        const existingUser = await ServiceProviderModel.find({ email: profile.email });
        console.log("ex : ", existingUser);
        if (!existingUser || existingUser.length == 0) {
            let user = new ServiceProviderModel({
                name: profile.displayName,
                email: profile.email,
            });
            await user.save();
        }
        return done(null, profile);
    })
);

passport.serializeUser(function (user, done) {
    done(null, user);
});

passport.deserializeUser(function (user, done) {
    done(null, user);
});

router.get('/googlelogin', (req, res) => {
    res.send('<a href="/auth/google">Authenticate with Google</a>');
});

router.get('/auth/google',
    passport.authenticate('google', { scope: ['email', 'profile'] }
    ));

router.get('/auth/google/callback',
    passport.authenticate('google', {
        successRedirect: '/protected',
        failureRedirect: '/auth/google/failure'
    })
);

router.get('/protected', (req, res) => {

    console.log(req.user.displayName);
    try {
        const { displayName, email } = req.user;
        const token = jwt.sign({ id: req.user.email }, process.env.JWT_KEY);
        res.status(200).json({ token, name: displayName, email: email })
    } catch (error) {
        console.log(error);
        res.status(500).json({ msg: "something went wrong" })
    }

});

// router.get('/logout', (req, res) => {
//   req.logout();
//   res.send('Goodbye!');
// });

router.get('/auth/google/failure', (req, res) => {
    res.status(401).json({ msg: 'Failed to authenticate.' });
});

module.exports = router;
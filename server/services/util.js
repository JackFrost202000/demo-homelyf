const nodemailer = require("nodemailer");

const sendEmail = async (to, subject, text, html) => {
    console.log(html);
    try {
        const transporter = nodemailer.createTransport({
            service: "gmail",
            auth: {
                user: process.env.SEND_EMAIL_USER,
                pass: process.env.SEND_EMAIL_PASS,
            },
        });
        const info = await transporter.sendMail({
            from: 'amitpotdukhe0@gmail.com',
            to: to,
            subject: "Hello ",
            text: html,
            html: html,
        });

        return true;
    } catch (error) {

        console.log(error);
        return false;
    }
}

const generateOTP = () => {
    const randomNum = Math.random() * 9000
    return Math.floor(1000 + randomNum)
}

module.exports = { sendEmail, generateOTP }
const { Vonage } = require('@vonage/server-sdk')

const vonage = new Vonage({
    apiKey: "6a8ca6ac",
    apiSecret: "lDp5m7OClc9mcq5h"
})

const from = "Vonage APIs"
const to = "+919359846977"
const text = 'A text message sent using the Vonage SMS API'

// async function sendSMS() {
//     await vonage.sms.send({to, from, text})
//         .then(resp => { console.log('Message sent successfully'); console.log(resp); })
//         .catch(err => { console.log('There was an error sending the messages.'); console.error(err); });
// }

// sendSMS();

const sendMsg = async () => {
    await vonage.sms.send({ to, from, text })
        .then(resp => { console.log('Message sent successfully'); console.log(resp); })
        .catch(err => { console.log('There was an error sending the messages.'); console.error(err); });

}

module.exports = { sendMsg }
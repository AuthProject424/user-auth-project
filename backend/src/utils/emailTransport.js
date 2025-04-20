const nodemailer = require('nodemailer');

// Create a transporter object using SMTP transport
const transporter = nodemailer.createTransport({
    service: 'gmail', // Using Gmail as the email service
    auth: {
        user: process.env.EMAIL_USER, // Email address
        pass: process.env.EMAIL_PASSWORD // App password
    }
});

// Generic email template
const createEmailContent = (link) => ({
    subject: 'Auth424: Finish your sign up',
    text: 'Please finish your sign up by clicking the link here: ' + link,
    html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2>Auth424: Finish your sign up</h2>
            <p>Please finish your sign up by clicking the button below:</p>
            <a href="${link}" 
               style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin: 20px 0;">
                Complete Sign Up
            </a>
        </div>
    `
});

// Function to send email
const sendEmail = async (to, link) => {
    try {
        const { subject, text, html } = createEmailContent(link);
        
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to,
            subject,
            text,
            html
        };

        const info = await transporter.sendMail(mailOptions);
        console.log('Email sent:', info.messageId);
        return info;
    } catch (error) {
        console.error('Error sending email:', error);
        throw error;
    }
};

module.exports = {
    sendEmail
}; 
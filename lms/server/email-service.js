const nodemailer = require('nodemailer');
const dotenv = require('dotenv');
dotenv.config();

// Email templates
const EMAIL_TEMPLATES = {
  ACTIVATION: (activationToken) => ({
    subject: 'Activate Your LMS Account',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;">
        <h2 style="color: #333;">Welcome to our Learning Management System!</h2>
        <p>Thank you for registering. Please click the button below to activate your account:</p>
        <a href="${process.env.FRONTEND_URL}/activate-account?token=${activationToken}" 
           style="display: inline-block; background-color: #4CAF50; color: white; padding: 10px 20px; 
                  text-decoration: none; border-radius: 5px; margin: 20px 0;">
           Activate Account
        </a>
        <p>Or copy and paste this activation link in your browser:</p>
        <p>${process.env.FRONTEND_URL}/activate-account?token=${activationToken}</p>
        <p>This link will expire in 24 hours.</p>
        <p>If you did not register for an account, please ignore this email.</p>
      </div>
    `
  }),
  
  PASSWORD_RESET: (resetToken) => ({
    subject: 'Reset Your LMS Password',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;">
        <h2 style="color: #333;">Password Reset Request</h2>
        <p>We received a request to reset your password. Please click the button below to create a new password:</p>
        <a href="${process.env.FRONTEND_URL}/reset-password?token=${resetToken}" 
           style="display: inline-block; background-color: #2196F3; color: white; padding: 10px 20px; 
                  text-decoration: none; border-radius: 5px; margin: 20px 0;">
           Reset Password
        </a>
        <p>Or copy and paste this reset link in your browser:</p>
        <p>${process.env.FRONTEND_URL}/reset-password?token=${resetToken}</p>
        <p>This link will expire in 1 hour.</p>
        <p>If you did not request a password reset, please ignore this email.</p>
      </div>
    `
  }),
  
  ENROLLMENT: (courseName, orderNumber) => ({
    subject: `Enrollment Confirmation: ${courseName}`,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;">
        <h2 style="color: #333;">Course Enrollment Confirmation</h2>
        <p>Thank you for enrolling in <strong>${courseName}</strong>!</p>
        <p>Your order number is: <strong>${orderNumber}</strong></p>
        <p>You can now access your course materials by logging into your account and navigating to "My Courses".</p>
        <a href="${process.env.FRONTEND_URL}/my-courses" 
           style="display: inline-block; background-color: #FF5722; color: white; padding: 10px 20px; 
                  text-decoration: none; border-radius: 5px; margin: 20px 0;">
           Start Learning
        </a>
        <p>If you have any questions, please contact our support team.</p>
      </div>
    `
  }),
  
  GENERIC: (subject, body) => ({
    subject,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;">
        <h2 style="color: #333;">${subject}</h2>
        <div>${body}</div>
      </div>
    `
  })
};

// Create Nodemailer transporter
const createTransporter = async () => {
  // For Gmail, it's recommended to use OAuth2 or an App Password if 2FA is enabled
  // For this example, we'll use simple authentication but in production, use more secure methods
  const transporter = nodemailer.createTransport({
    host: process.env.EMAIL_HOST || 'smtp.gmail.com',
    port: parseInt(process.env.EMAIL_PORT || '587'),
    secure: process.env.EMAIL_SECURE === 'true',
    auth: {
      user: process.env.EMAIL_USER,
      // If using Gmail with 2FA, use an App Password instead of your regular password
      pass: process.env.EMAIL_PASSWORD,
    },
    tls: {
      // Do not fail on invalid certificates
      rejectUnauthorized: false
    }
  });
  
  return transporter;
};

// Main email sending function
const sendEmail = async (options) => {
  try {
    const { to, subject, html, text } = options;
    
    console.log(`Attempting to send email to: ${to}`);
    
    const transporter = await createTransporter();
    
    // Send mail with defined transport object
    const info = await transporter.sendMail({
      from: `"${process.env.EMAIL_FROM_NAME || 'LMS Support'}" <${process.env.EMAIL_FROM || process.env.EMAIL_USER}>`,
      to,
      subject,
      text: text || subject,
      html: html || `<p>${text || subject}</p>`,
    });
    
    console.log(`Message sent: ${info.messageId}`);
    return { success: true, messageId: info.messageId };
  } catch (error) {
    console.error('Error sending email:', error);
    return { success: false, error: error.message };
  }
};

// Handle different email types
const handleEmailRequest = async (req, res) => {
  try {
    const { email, emailType, activationToken, resetToken, courseName, orderNumber, subject, body } = req.body;
    
    if (!email) {
      return res.status(400).json({ success: false, message: 'Email address is required' });
    }
    
    let emailOptions = {
      to: email,
    };
    
    // Get the appropriate template based on emailType
    switch(emailType) {
      case 'ACTIVATION':
        if (!activationToken) {
          return res.status(400).json({ success: false, message: 'Activation token is required' });
        }
        
        const activationTemplate = EMAIL_TEMPLATES.ACTIVATION(activationToken);
        emailOptions.subject = activationTemplate.subject;
        emailOptions.html = activationTemplate.html;
        break;
        
      case 'PASSWORD_RESET':
        if (!resetToken) {
          return res.status(400).json({ success: false, message: 'Reset token is required' });
        }
        
        const resetTemplate = EMAIL_TEMPLATES.PASSWORD_RESET(resetToken);
        emailOptions.subject = resetTemplate.subject;
        emailOptions.html = resetTemplate.html;
        break;
        
      case 'ENROLLMENT':
        if (!courseName || !orderNumber) {
          return res.status(400).json({ 
            success: false, 
            message: 'Course name and order number are required for enrollment emails' 
          });
        }
        
        const enrollmentTemplate = EMAIL_TEMPLATES.ENROLLMENT(courseName, orderNumber);
        emailOptions.subject = enrollmentTemplate.subject;
        emailOptions.html = enrollmentTemplate.html;
        break;
        
      case 'GENERIC':
        if (!subject || !body) {
          return res.status(400).json({ 
            success: false, 
            message: 'Subject and body are required for generic emails' 
          });
        }
        
        const genericTemplate = EMAIL_TEMPLATES.GENERIC(subject, body);
        emailOptions.subject = genericTemplate.subject;
        emailOptions.html = genericTemplate.html;
        break;
        
      default:
        return res.status(400).json({ success: false, message: 'Invalid email type' });
    }
    
    // Send the email
    const result = await sendEmail(emailOptions);
    
    if (result.success) {
      return res.status(200).json({ success: true, messageId: result.messageId });
    } else {
      return res.status(500).json({ success: false, error: result.error });
    }
  } catch (error) {
    console.error('Error handling email request:', error);
    return res.status(500).json({ success: false, error: error.message });
  }
};

module.exports = {
  sendEmail,
  handleEmailRequest
};

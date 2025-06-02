const express = require('express');
const router = express.Router();
const sendMail = require('../utils/sendMail');
const { isAuthenticated, authorizeRoles } = require('../middleware/auth');
const { createError } = require('../utils/error');

// Send email route
router.post('/send-email', isAuthenticated, async (req, res, next) => {
  try {
    const { to, subject, html, text } = req.body;
    
    if (!to || !subject || (!html && !text)) {
      return next(createError(400, 'Missing required fields'));
    }
    
    await sendMail({
      email: to,
      subject,
      html,
      text
    });
    
    res.status(200).json({
      success: true,
      message: 'Email sent successfully'
    });
  } catch (error) {
    return next(createError(500, `Error sending email: ${error.message}`));
  }
});

// Test email configuration route (admin only)
router.post('/test-email-config', isAuthenticated, authorizeRoles('admin'), async (req, res, next) => {
  try {
    const { email } = req.body;
    
    if (!email) {
      return next(createError(400, 'Email address is required'));
    }
    
    await sendMail({
      email,
      subject: 'Email Configuration Test',
      text: 'This is a test email to verify your email configuration is working correctly.',
      html: '<p>This is a test email to verify your email configuration is working correctly.</p>'
    });
    
    res.status(200).json({
      success: true,
      message: 'Test email sent successfully'
    });
  } catch (error) {
    return next(createError(500, `Error sending test email: ${error.message}`));
  }
});

module.exports = router;

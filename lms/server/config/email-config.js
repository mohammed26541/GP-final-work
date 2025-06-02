const nodemailer = require('nodemailer');
const dotenv = require('dotenv');
dotenv.config();

// Load email configuration from environment variables
const emailConfig = {
  // Main email service settings
  service: process.env.EMAIL_SERVICE || 'mailgun', // Default to mailgun as it's more reliable for transactional emails
  host: process.env.EMAIL_HOST || 'smtp.mailgun.org',
  port: parseInt(process.env.EMAIL_PORT || '587'),
  secure: process.env.EMAIL_SECURE === 'true',
  auth: {
    user: process.env.EMAIL_USER || 'postmaster@your-domain.com',
    pass: process.env.EMAIL_PASSWORD || 'your-mailgun-password',
  },
  
  // Fallback service - use a different provider like SendGrid if primary fails
  fallbackService: process.env.FALLBACK_EMAIL_SERVICE || 'sendgrid',
  fallbackHost: process.env.FALLBACK_EMAIL_HOST || 'smtp.sendgrid.net',
  fallbackPort: parseInt(process.env.FALLBACK_EMAIL_PORT || '587'),
  fallbackSecure: process.env.FALLBACK_EMAIL_SECURE === 'true',
  fallbackAuth: {
    user: process.env.FALLBACK_EMAIL_USER || 'apikey',
    pass: process.env.FALLBACK_EMAIL_PASSWORD || 'your-sendgrid-api-key',
  },
  
  // Email sender details
  fromName: process.env.EMAIL_FROM_NAME || 'LMS Support',
  fromEmail: process.env.EMAIL_FROM || 'support@your-domain.com',
  
  // Email templates configuration
  templateDir: process.env.EMAIL_TEMPLATE_DIR || './email-templates',
  
  // Rate limiting
  maxEmailsPerHour: parseInt(process.env.MAX_EMAILS_PER_HOUR || '100'),
  
  // Retry configuration
  maxRetries: parseInt(process.env.EMAIL_MAX_RETRIES || '3'),
  retryDelay: parseInt(process.env.EMAIL_RETRY_DELAY || '1000'), // milliseconds
};

// Create primary transporter
const createPrimaryTransporter = () => {
  return nodemailer.createTransport({
    service: emailConfig.service,
    host: emailConfig.host,
    port: emailConfig.port,
    secure: emailConfig.secure,
    auth: {
      user: emailConfig.auth.user,
      pass: emailConfig.auth.pass,
    },
    tls: {
      rejectUnauthorized: false
    }
  });
};

// Create fallback transporter
const createFallbackTransporter = () => {
  return nodemailer.createTransport({
    service: emailConfig.fallbackService,
    host: emailConfig.fallbackHost,
    port: emailConfig.fallbackPort,
    secure: emailConfig.fallbackSecure,
    auth: {
      user: emailConfig.fallbackAuth.user,
      pass: emailConfig.fallbackAuth.pass,
    },
    tls: {
      rejectUnauthorized: false
    }
  });
};

// Function to send email with retry and fallback logic
const sendEmail = async (options) => {
  const { to, subject, html, text } = options;
  let error;
  
  // Try primary email service with retries
  for (let attempt = 0; attempt < emailConfig.maxRetries; attempt++) {
    try {
      console.log(`Sending email to ${to} using primary service, attempt ${attempt + 1}`);
      
      const transporter = createPrimaryTransporter();
      
      const info = await transporter.sendMail({
        from: `"${emailConfig.fromName}" <${emailConfig.fromEmail}>`,
        to,
        subject,
        text: text || subject,
        html: html || `<p>${text || subject}</p>`,
      });
      
      console.log(`Email sent successfully: ${info.messageId}`);
      return { success: true, messageId: info.messageId };
    } catch (err) {
      console.error(`Primary email service failed attempt ${attempt + 1}:`, err);
      error = err;
      
      // Wait before retry
      if (attempt < emailConfig.maxRetries - 1) {
        await new Promise(resolve => setTimeout(resolve, emailConfig.retryDelay));
      }
    }
  }
  
  // Try fallback email service
  try {
    console.log(`Primary email service failed, trying fallback service`);
    
    const fallbackTransporter = createFallbackTransporter();
    
    const info = await fallbackTransporter.sendMail({
      from: `"${emailConfig.fromName}" <${emailConfig.fromEmail}>`,
      to,
      subject,
      text: text || subject,
      html: html || `<p>${text || subject}</p>`,
    });
    
    console.log(`Email sent successfully with fallback: ${info.messageId}`);
    return { success: true, messageId: info.messageId, usedFallback: true };
  } catch (fallbackErr) {
    console.error('Fallback email service also failed:', fallbackErr);
    
    // If both primary and fallback fail, return the original error
    return { 
      success: false, 
      error: error.message || 'Failed to send email',
      details: error
    };
  }
};

// Test the email configuration
const testEmailConfiguration = async () => {
  try {
    console.log('Testing email configuration...');
    
    // First test the connection without sending an email
    const transporter = createPrimaryTransporter();
    await transporter.verify();
    
    console.log('Primary email service connection verified');
    
    // Now send a test email
    const result = await sendEmail({
      to: emailConfig.fromEmail, // Send to ourselves
      subject: 'LMS Email Configuration Test',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 5px;">
          <h2 style="color: #333;">Email Configuration Test</h2>
          <p>This is a test email to verify that your email service is configured correctly.</p>
          <p>Test completed at: ${new Date().toISOString()}</p>
        </div>
      `
    });
    
    return result;
  } catch (error) {
    console.error('Email configuration test failed:', error);
    return { 
      success: false, 
      error: error.message || 'Email configuration test failed',
      details: error
    };
  }
};

module.exports = {
  emailConfig,
  sendEmail,
  testEmailConfiguration
};

const User = require('../models/user.model');
const jwt = require('jsonwebtoken');
const sendMail = require('../utils/sendMail');
const { createError } = require('../utils/error');
const bcrypt = require('bcryptjs');

// Token options
const accessTokenOptions = {
  expires: new Date(Date.now() + 5 * 60 * 1000), // 5 minutes
  maxAge: 5 * 60 * 1000,
  httpOnly: true,
  sameSite: 'none',
  secure: process.env.NODE_ENV === 'production'
};

const refreshTokenOptions = {
  expires: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000), // 3 days
  maxAge: 3 * 24 * 60 * 60 * 1000,
  httpOnly: true,
  sameSite: 'none',
  secure: process.env.NODE_ENV === 'production'
};

// Send JWT token
const sendToken = (user, statusCode, res) => {
  const accessToken = user.signAccessToken();
  const refreshToken = user.signRefreshToken();

  // Set cookies
  res.cookie('access_token', accessToken, accessTokenOptions);
  res.cookie('refresh_token', refreshToken, refreshTokenOptions);

  // Remove password from response
  user.password = undefined;

  res.status(statusCode).json({
    success: true,
    user,
    accessToken
  });
};

// Register user
exports.register = async (req, res, next) => {
  try {
    const { name, email, password } = req.body;

    // Check if email already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return next(createError(400, 'Email already exists'));
    }

    // Create activation token
    const activationToken = createActivationToken({ name, email, password });
    const activationCode = activationToken.activationCode;

    // Create email data
    const data = {
      user: { name },
      activationCode
    };

    // Send activation email
    try {
      await sendMail({
        email,
        subject: 'Activate your account',
        template: 'activation-mail',
        data
      });

      res.status(201).json({
        success: true,
        message: `Please check your email: ${email} to activate your account!`,
        activationToken: activationToken.token
      });
    } catch (error) {
      return next(createError(400, `Error sending email: ${error.message}`));
    }
  } catch (error) {
    return next(createError(500, error.message));
  }
};

// Create activation token
const createActivationToken = (user) => {
  const activationCode = Math.floor(1000 + Math.random() * 9000).toString();

  const token = jwt.sign(
    { user, activationCode },
    process.env.JWT_SECRET || 'fallback_jwt_secret',
    { expiresIn: '5m' }
  );

  return { token, activationCode };
};

// Activate user
exports.activateUser = async (req, res, next) => {
  try {
    const { activation_token, activation_code } = req.body;

    // Verify token
    const decoded = jwt.verify(
      activation_token,
      process.env.JWT_SECRET || 'fallback_jwt_secret'
    );

    if (decoded.activationCode !== activation_code) {
      return next(createError(400, 'Invalid activation code'));
    }

    const { name, email, password } = decoded.user;

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return next(createError(400, 'Email already exists'));
    }

    // Create new user
    const user = await User.create({
      name,
      email,
      password,
      isVerified: true
    });

    res.status(201).json({
      success: true,
      message: 'Account activated successfully'
    });
  } catch (error) {
    return next(createError(500, error.message));
  }
};

// Login user
exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return next(createError(400, 'Please enter email and password'));
    }

    // Find user
    const user = await User.findOne({ email }).select('+password');

    if (!user) {
      return next(createError(400, 'Invalid email or password'));
    }

    // Check if password is correct
    const isPasswordMatch = await user.comparePassword(password);
    if (!isPasswordMatch) {
      return next(createError(400, 'Invalid email or password'));
    }

    // Send token
    sendToken(user, 200, res);
  } catch (error) {
    return next(createError(500, error.message));
  }
};

// Logout user
exports.logout = async (req, res, next) => {
  try {
    res.cookie('access_token', '', { maxAge: 1 });
    res.cookie('refresh_token', '', { maxAge: 1 });

    res.status(200).json({
      success: true,
      message: 'Logged out successfully'
    });
  } catch (error) {
    return next(createError(500, error.message));
  }
};

// Get user info (me)
exports.getUserInfo = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const user = await User.findById(userId);

    if (!user) {
      return next(createError(404, 'User not found'));
    }

    res.status(200).json({
      success: true,
      user
    });
  } catch (error) {
    return next(createError(500, error.message));
  }
};

// Update user info
exports.updateUserInfo = async (req, res, next) => {
  try {
    const { name, email } = req.body;
    const userId = req.user.id;

    const user = await User.findById(userId);

    if (email && user.email !== email) {
      const isEmailExist = await User.findOne({ email });
      if (isEmailExist) {
        return next(createError(400, 'Email already exists'));
      }
      user.email = email;
    }

    if (name) {
      user.name = name;
    }

    await user.save();

    res.status(200).json({
      success: true,
      user
    });
  } catch (error) {
    return next(createError(500, error.message));
  }
};

// Update user password
exports.updatePassword = async (req, res, next) => {
  try {
    const { oldPassword, newPassword } = req.body;
    const userId = req.user.id;

    if (!oldPassword || !newPassword) {
      return next(createError(400, 'Please enter old and new password'));
    }

    const user = await User.findById(userId).select('+password');

    const isPasswordMatch = await user.comparePassword(oldPassword);
    if (!isPasswordMatch) {
      return next(createError(400, 'Invalid old password'));
    }

    user.password = newPassword;
    await user.save();

    res.status(200).json({
      success: true,
      message: 'Password updated successfully'
    });
  } catch (error) {
    return next(createError(500, error.message));
  }
};

// Update user avatar
exports.updateAvatar = async (req, res, next) => {
  try {
    const { avatar } = req.body;
    const userId = req.user.id;

    const user = await User.findById(userId);

    if (avatar) {
      // Here you would normally delete the old avatar from storage
      // and upload the new one to a service like Cloudinary
      user.avatar = {
        public_id: `avatar_${userId}`,
        url: avatar
      };
    }

    await user.save();

    res.status(200).json({
      success: true,
      user
    });
  } catch (error) {
    return next(createError(500, error.message));
  }
};

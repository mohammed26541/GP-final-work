const jwt = require('jsonwebtoken');
const User = require('../models/user.model');
const { createError } = require('../utils/error');

// Middleware to authenticate user with JWT
exports.isAuthenticated = async (req, res, next) => {
  try {
    // Get token from cookies or headers
    const token = req.cookies.access_token || 
                 (req.headers.authorization && req.headers.authorization.split(' ')[1]);

    if (!token) {
      return next(createError(401, 'Please login to access this resource'));
    }

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback_jwt_secret');
    
    // Find user
    const user = await User.findById(decoded.id);
    if (!user) {
      return next(createError(401, 'User not found'));
    }

    // Set user in req object
    req.user = user;
    next();
  } catch (error) {
    return next(createError(401, 'Authentication failed'));
  }
};

// Middleware to check user role
exports.authorizeRoles = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return next(createError(403, `Role (${req.user.role}) is not allowed to access this resource`));
    }
    next();
  };
};

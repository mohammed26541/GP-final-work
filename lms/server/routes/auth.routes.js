const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const { isAuthenticated } = require('../middleware/auth');

// Public routes
router.post('/registration', authController.register);
router.post('/activate-user', authController.activateUser);
router.post('/login', authController.login);
router.get('/logout', authController.logout);

// Protected routes
router.get('/me', isAuthenticated, authController.getUserInfo);
router.put('/update-user-info', isAuthenticated, authController.updateUserInfo);
router.put('/update-user-password', isAuthenticated, authController.updatePassword);
router.put('/update-user-avatar', isAuthenticated, authController.updateAvatar);

module.exports = router;

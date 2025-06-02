# MERN LMS Platform

A Learning Management System built with the MERN stack (MongoDB, Express, React, Node.js).

## Setup Instructions

### Server Setup

1. Navigate to the server directory:
   ```
   cd server
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Create a `.env` file in the server directory with the following content:
   ```
   Note => This is a simple example to help you understand what to write in an .env file. If you find an .env file in the client and server folders, do nothing. Just run the project.
   PORT=5000
   CLIENT_URL=http://localhost:5173
   MONGO_URI=mongodb+srv://kaniso3534:kaniso35343030802025@cluster0.qegpy.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
   CLOUDINARY_CLOUD_NAME=dd1nk96y2
   CLOUDINARY_API_KEY=229536691891875
   CLOUDINARY_API_SECRET=2MFONGcXB0nItujJmMGwdWmnd3g
   JWT_SECRET=7b8f99b1d4e3a6c2f7e5d1a9b3c8e2f4

   # Cloudinary Configuration
   CLOUDINARY_CLOUD_NAME=your_cloud_name
   CLOUDINARY_API_KEY=your_api_key
   CLOUDINARY_API_SECRET=your_api_secret
   ```

   Replace the placeholder values with your actual MongoDB connection string and Cloudinary credentials.

4. Start the server:
   ```
   npm run dev
   ```

### Client Setup

1. Navigate to the client directory:
   ```
   cd client
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Start the client:
   ```
   npm run dev
   ```

## Features

- User authentication (register, login, JWT-based auth)
- Instructor dashboard
- Course creation and management
- Video upload via Cloudinary
- Student enrollment and course viewing
- Course progress tracking

## Troubleshooting

### Authentication Issues

If you encounter authentication issues:
1. Make sure your JWT_SECRET is properly set in the .env file
2. Check that the token is being properly stored in sessionStorage
3. Verify that the token is being included in API requests

### Media Upload Issues

If you encounter issues with media uploads:
1. Verify your Cloudinary credentials in the .env file
2. Ensure the uploads directory exists and is writable
3. Check that you're uploading valid video files
4. Look for detailed error messages in the server console

## API Endpoints

### Authentication
- POST /auth/register - Register a new user
- POST /auth/login - Login a user
- GET /auth/check-auth - Check if a user is authenticated

### Media
- POST /media/upload - Upload a single file
- POST /media/bulk-upload - Upload multiple files
- DELETE /media/delete/:id - Delete a file

### Instructor Courses
- GET /instructor/course/get - Get all courses for an instructor
- POST /instructor/course/add - Add a new course
- GET /instructor/course/get/details/:id - Get course details
- PUT /instructor/course/update/:id - Update a course

### Student Courses
- GET /student/course/get - Get all available courses
- GET /student/course/get/details/:id - Get course details
- GET /student/course/purchase-info/:courseId/:studentId - Check if a student has purchased a course
- POST /student/order/create - Create a new order
- POST /student/order/capture - Capture and finalize payment
- GET /student/courses-bought/get/:studentId - Get all courses bought by a student
- GET /student/course-progress/get/:userId/:courseId - Get course progress
- POST /student/course-progress/mark-lecture-viewed - Mark a lecture as viewed
- POST /student/course-progress/reset-progress - Reset course progress
# LMS

import { styles } from "@/app/styles/style";
import Image from "next/image";
import React, { useState } from "react";
import ReviewCard from "../Review/ReviewCard";
import { motion } from "framer-motion";
import { FaStar, FaQuoteLeft, FaQuoteRight, FaUserCircle } from "react-icons/fa";
import { HiOutlineChatAlt2, HiOutlineSparkles } from "react-icons/hi";
import { IoIosArrowBack, IoIosArrowForward } from "react-icons/io";

// Animation variants
const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1
    }
  }
};

const itemVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: {
    opacity: 1,
    y: 0,
    transition: {
      duration: 0.5,
      ease: 'easeOut'
    }
  }
};

// Review data with ratings added
export const reviews = [
  {
    name: "Gene Bates",
    avatar: "https://randomuser.me/api/portraits/men/1.jpg",
    profession: "Student | Cambridge university",
    rating: 5,
    date: "April 15, 2025",
    comment:
    "I had the pleasure of exploring Becodemy, a website that provides an extensive range of courses on various tech-related topics. I was thoroughly impressed with my experience, as the website offers a comprehensive selection of courses that cater to different skill levels and interests. If you're looking to enhance your knowledge and skills in the tech industry, I highly recommend checking out Becodemy!",
  },
  {
    name: "Verna Santos",
    avatar: "https://randomuser.me/api/portraits/women/1.jpg",
    profession: "Full stack developer | Quarter ltd.",
    rating: 5,
    date: "March 28, 2025",
    comment:
    "Thanks for your amazing programming tutorial channel! Your teaching style is outstanding, and the quality of your tutorials is top-notch. Your ability to break down complex topics into manageable parts, and cover diverse programming languages and topics is truly impressive. The practical applications and real-world examples you incorporate reinforce the theoretical knowledge and provide valuable insights. Your engagement with the audience fosters a supportive learning environment. Thank you for your dedication, expertise, and passion for teaching programming, and keep up the fantastic work!",
  },
  {
    name: "Jay Gibbs",
    avatar: "https://randomuser.me/api/portraits/men/2.jpg",
    profession: "Computer systems engineering student | Zimbabwe",
    rating: 4,
    date: "March 22, 2025",
    comment:
    "Thanks for your amazing programming tutorial channel! Your teaching style is outstanding, and the quality of your tutorials is top-notch. Your ability to break down complex topics into manageable parts, and cover diverse programming languages and topics is truly impressive. The practical applications and real-world examples you incorporate reinforce the theoretical knowledge and provide valuable insights. Your engagement with the audience fosters a supportive learning environment. Thank you for your dedication, expertise, and passion for teaching programming, and keep up the fantastic work!"},
  {
    name: "Mina Davidson",
    avatar: "https://randomuser.me/api/portraits/women/2.jpg",
    profession: "Junior Web Developer | Indonesia",
    rating: 4,
    date: "March 15, 2025",
    comment:
    "I had the pleasure of exploring Becodemy, a website that provides an extensive range of courses on various tech-related topics. I was thoroughly impressed with my experience",
  },
  {
    name: "Rosemary Smith",
    avatar: "https://randomuser.me/api/portraits/women/3.jpg",
    profession: "Full stack web developer | Algeria",
    rating: 5,
    date: "March 10, 2025",
    comment:
    "Your content is very special. The thing I liked the most is that the videos are so long, which means they cover everything in details. for that any person had beginner-level can complete an integrated project when he watches the videos. Thank you very much. Im very excited for the next videos Keep doing this amazing work",
  },
  {
    name: "Laura Mckenzie",
    avatar: "https://randomuser.me/api/portraits/women/4.jpg",
    profession: "Full stack web developer | Canada",
    rating: 5,
    date: "March 5, 2025",
    comment:
    "Join Becodemy! Becodemy focuses on practical applications rather than just teaching the theory behind programming languages or frameworks. I took a lesson on creating a web marketplace using React JS, and it was very helpful in teaching me the different stages involved in creating a project from start to finish. Overall, I highly recommend Becodemy to anyone looking to improve their programming skills and build practical projects. Becodemy is a great resource that will help you take your skills to the next level.",
  },
];

type Props = {};

const Reviews = (props: Props) => {
  // State for pagination
  const [currentPage, setCurrentPage] = useState(0);
  const reviewsPerPage = 3;
  const pageCount = Math.ceil(reviews.length / reviewsPerPage);
  
  // Get current reviews
  const currentReviews = reviews.slice(
    currentPage * reviewsPerPage, 
    (currentPage + 1) * reviewsPerPage
  );
  
  // Calculate overall rating
  const averageRating = reviews.reduce((acc, review) => acc + review.rating, 0) / reviews.length;
  
  // Handle pagination
  const handleNextPage = () => {
    setCurrentPage((prev) => (prev + 1) % pageCount);
  };
  
  const handlePrevPage = () => {
    setCurrentPage((prev) => (prev - 1 + pageCount) % pageCount);
  };

  return (
    <div className="relative py-16 overflow-hidden">
      {/* AI-inspired background elements */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none">
        {/* Subtle glow effects */}
        <div className="absolute top-1/4 left-1/4 w-64 h-64 bg-blue-500/5 dark:bg-blue-500/10 rounded-full blur-3xl"></div>
        <div className="absolute bottom-1/3 right-1/4 w-64 h-64 bg-indigo-500/5 dark:bg-indigo-500/10 rounded-full blur-3xl"></div>
      </div>
      
      <motion.div 
        variants={containerVariants}
        initial="hidden"
        animate="visible"
        className="w-[90%] 800px:w-[85%] m-auto relative z-10"
      >
        {/* Header section */}
        <motion.div 
          variants={itemVariants} 
          className="text-center mb-16"
        >
          
          {/* Decorative elements */}
          <div className="relative inline-block mb-8">
            <div className="absolute -top-10 -left-10 w-20 h-20 opacity-10 dark:opacity-20">
              <svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="50" cy="50" r="45" stroke="url(#headerGradient)" strokeWidth="2" />
                <path d="M25,50 Q50,25 75,50 Q50,75 25,50" stroke="url(#headerGradient)" strokeWidth="2" fill="none" />
                <defs>
                  <linearGradient id="headerGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" stopColor="#3b82f6" />
                    <stop offset="100%" stopColor="#8b5cf6" />
                  </linearGradient>
                </defs>
              </svg>
            </div>
            <div className="absolute -bottom-10 -right-10 w-20 h-20 opacity-10 dark:opacity-20">
              <svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M30,30 L70,70" stroke="url(#headerGradient2)" strokeWidth="2" />
                <path d="M30,70 L70,30" stroke="url(#headerGradient2)" strokeWidth="2" />
                <rect x="25" y="25" width="50" height="50" rx="10" stroke="url(#headerGradient2)" strokeWidth="2" fill="none" />
                <defs>
                  <linearGradient id="headerGradient2" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" stopColor="#3b82f6" />
                    <stop offset="100%" stopColor="#8b5cf6" />
                  </linearGradient>
                </defs>
              </svg>
            </div>
            
            <motion.h2 
              className="relative font-Poppins text-4xl 800px:text-5xl dark:text-white font-[700] tracking-tight mb-2"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6 }}
            >
              <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-600 via-indigo-500 to-purple-600 dark:from-blue-400 dark:via-indigo-400 dark:to-purple-400">
                Student Voices
              </span>
              <HiOutlineSparkles className="inline-block ml-2 text-blue-500 dark:text-blue-400 w-6 h-6 animate-pulse" />
            </motion.h2>
          </div>
          
          {/* Animated underline */}
          <motion.div 
            className="h-1 w-64 bg-gradient-to-r from-blue-500 via-indigo-500 to-purple-500 dark:from-blue-400 dark:via-indigo-400 dark:to-purple-400 rounded-full mx-auto"
            initial={{ width: 0, opacity: 0 }}
            animate={{ width: '16rem', opacity: 1 }}
            transition={{ delay: 0.3, duration: 0.8 }}
          />
          
          <motion.p 
            className="mt-6 text-gray-600 dark:text-gray-300 max-w-2xl mx-auto text-lg leading-relaxed"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.5, duration: 0.8 }}
          >
            Our students are the heart of our community. Their experiences and success stories 
            inspire us to continuously improve our learning platform.            
          </motion.p>
        </motion.div>
        
        {/* Stats section */}
        <motion.div 
          variants={containerVariants}
          className="flex flex-wrap justify-center gap-8 mb-16"
        >
          <motion.div 
            variants={itemVariants}
            whileHover={{ y: -5, transition: { duration: 0.2 } }}
            className="bg-gradient-to-br from-white/95 to-white/80 dark:from-gray-800/60 dark:to-gray-800/40 rounded-xl p-6 shadow-md backdrop-blur-sm border border-gray-200/60 dark:border-gray-700/40 flex items-center space-x-5 transform transition-all duration-300 hover:shadow-lg"
          >
            <div className="w-14 h-14 rounded-full bg-gradient-to-br from-yellow-400 to-yellow-500 dark:from-yellow-500 dark:to-yellow-600 flex items-center justify-center shadow-inner">
              <FaStar className="text-white text-xl" />
            </div>
            <div>
              <div className="text-3xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-yellow-600 to-amber-600 dark:from-yellow-400 dark:to-amber-400">{averageRating.toFixed(1)}/5</div>
              <div className="text-sm font-medium text-gray-600 dark:text-gray-300">Average Rating</div>
            </div>
          </motion.div>
          
          <motion.div 
            variants={itemVariants}
            whileHover={{ y: -5, transition: { duration: 0.2 } }}
            className="bg-gradient-to-br from-white/95 to-white/80 dark:from-gray-800/60 dark:to-gray-800/40 rounded-xl p-6 shadow-md backdrop-blur-sm border border-gray-200/60 dark:border-gray-700/40 flex items-center space-x-5 transform transition-all duration-300 hover:shadow-lg"
          >
            <div className="w-14 h-14 rounded-full bg-gradient-to-br from-blue-500 to-indigo-500 dark:from-blue-400 dark:to-indigo-400 flex items-center justify-center shadow-inner">
              <FaUserCircle className="text-white text-xl" />
            </div>
            <div>
              <div className="text-3xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400">{reviews.length}+</div>
              <div className="text-sm font-medium text-gray-600 dark:text-gray-300">Student Reviews</div>
            </div>
          </motion.div>
        </motion.div>
        
        {/* Image and reviews section */}
        <div className="flex flex-col lg:flex-row gap-12 items-center">
          {/* Image section */}
          <motion.div 
            variants={itemVariants}
            className="lg:w-[40%] w-full relative"
          >
            <div className="absolute -top-10 -left-10 w-32 h-32 bg-gradient-to-br from-blue-500/10 to-indigo-500/10 dark:from-blue-500/20 dark:to-indigo-500/20 rounded-full blur-xl"></div>
            <div className="absolute -bottom-10 -right-10 w-32 h-32 bg-gradient-to-br from-indigo-500/10 to-purple-500/10 dark:from-indigo-500/20 dark:to-purple-500/20 rounded-full blur-xl"></div>
            
            <motion.div 
              className="relative z-10 rounded-2xl overflow-hidden shadow-xl border border-gray-200/50 dark:border-gray-700/50 transform transition-all duration-300 hover:scale-[1.02]"
              whileHover={{ boxShadow: "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)" }}
            >
              <div className="absolute inset-0 bg-gradient-to-br from-blue-500/10 to-indigo-500/10 dark:from-blue-500/20 dark:to-indigo-500/20 z-0"></div>
              <Image
                src={require("../../../public/assests/business-img.png")}
                alt="Students learning"
                width={500}
                height={500}
                className="relative z-10"
              />
              
              {/* Quote overlay */}
              <motion.div 
                initial={{ opacity: 0, scale: 0.8 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.5, duration: 0.5 }}
                className="absolute -bottom-6 -right-6 bg-gradient-to-br from-white to-gray-50 dark:from-gray-800 dark:to-gray-900 p-4 rounded-xl shadow-lg border border-gray-200/80 dark:border-gray-700/80"
              >
                <FaQuoteLeft className="text-gradient-to-r from-blue-500 to-indigo-500 dark:from-blue-400 dark:to-indigo-400 text-4xl opacity-80" />
              </motion.div>
            </motion.div>
          </motion.div>
          
          {/* Reviews section - modern comment style */}
          <motion.div 
            variants={containerVariants}
            className="lg:w-[60%] w-full"
          >
            <div className="bg-gradient-to-br from-white/90 to-white/70 dark:from-gray-800/50 dark:to-gray-800/30 rounded-2xl shadow-lg backdrop-blur-sm border border-gray-200/60 dark:border-gray-700/40 p-8 relative overflow-hidden">
              {/* Background decorative elements */}
              <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-blue-500/5 to-indigo-500/5 dark:from-blue-500/10 dark:to-indigo-500/10 rounded-full blur-2xl"></div>
              <div className="absolute bottom-0 left-0 w-32 h-32 bg-gradient-to-br from-indigo-500/5 to-purple-500/5 dark:from-indigo-500/10 dark:to-purple-500/10 rounded-full blur-2xl"></div>
              
              <div className="flex items-center justify-between mb-8 relative z-10">
                <h3 className="text-xl font-bold text-gray-800 dark:text-gray-200 flex items-center">
                  <FaQuoteLeft className="text-blue-500 dark:text-blue-400 mr-3 opacity-80" />
                  <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400">Recent Feedback</span>
                </h3>
                
                {/* Pagination controls */}
                <div className="flex items-center space-x-3">
                  <button 
                    onClick={handlePrevPage}
                    className="p-2 rounded-full bg-gradient-to-r from-gray-50 to-gray-100 dark:from-gray-800 dark:to-gray-700 hover:from-blue-50 hover:to-blue-100 dark:hover:from-blue-900/20 dark:hover:to-blue-800/20 transition-all shadow-sm border border-gray-200/80 dark:border-gray-700/50"
                  >
                    <IoIosArrowBack className="text-gray-600 dark:text-gray-300" />
                  </button>
                  <span className="text-sm font-medium text-gray-600 dark:text-gray-300">
                    {currentPage + 1}/{pageCount}
                  </span>
                  <button 
                    onClick={handleNextPage}
                    className="p-2 rounded-full bg-gradient-to-r from-gray-50 to-gray-100 dark:from-gray-800 dark:to-gray-700 hover:from-blue-50 hover:to-blue-100 dark:hover:from-blue-900/20 dark:hover:to-blue-800/20 transition-all shadow-sm border border-gray-200/80 dark:border-gray-700/50"
                  >
                    <IoIosArrowForward className="text-gray-600 dark:text-gray-300" />
                  </button>
                </div>
              </div>
              
              {/* Reviews list */}
              <div className="space-y-6 relative z-10">
                {currentReviews.map((review, index) => (
                  <motion.div
                    key={index}
                    variants={itemVariants}
                    whileHover={{ y: -3, transition: { duration: 0.2 } }}
                    className="bg-white dark:bg-gray-800 rounded-xl p-5 shadow-md border border-gray-100/80 dark:border-gray-700/50 transition-all duration-300 hover:shadow-lg"
                  >
                    <div className="flex items-start gap-4">
                      {/* Avatar */}
                      <div className="flex-shrink-0">
                        <div className="relative">
                          <div className="absolute inset-0 rounded-full bg-gradient-to-r from-blue-500 to-indigo-500 blur-[1px]"></div>
                          <Image
                            src={review.avatar}
                            alt={review.name}
                            width={50}
                            height={50}
                            className="rounded-full border-2 border-white dark:border-gray-800 relative z-10"
                          />
                        </div>
                      </div>
                      
                      {/* Content */}
                      <div className="flex-1">
                        <div className="flex flex-wrap items-center justify-between gap-2 mb-2">
                          <h4 className="font-semibold text-gray-900 dark:text-gray-100">{review.name}</h4>
                          <div className="flex items-center bg-yellow-50 dark:bg-yellow-900/20 px-2 py-1 rounded-full">
                            {Array.from({ length: 5 }).map((_, i) => (
                              <FaStar 
                                key={i} 
                                className={`w-3.5 h-3.5 ${i < review.rating ? 'text-yellow-500' : 'text-gray-300 dark:text-gray-600'}`} 
                              />
                            ))}
                          </div>
                        </div>
                        
                        <p className="text-xs font-medium text-gray-500 dark:text-gray-400 mb-3 flex items-center">
                          <span className="inline-block w-2 h-2 rounded-full bg-blue-500 dark:bg-blue-400 mr-2"></span>
                          {review.profession} • {review.date}
                        </p>
                        
                        <p className="text-sm text-gray-700 dark:text-gray-300 leading-relaxed">
                          {review.comment.length > 150 
                            ? `${review.comment.substring(0, 150)}...` 
                            : review.comment
                          }
                        </p>
                        
                        {review.comment.length > 150 && (
                          <button className="mt-3 text-xs font-medium text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 transition-colors flex items-center">
                            Read more
                            <svg xmlns="http://www.w3.org/2000/svg" className="h-3 w-3 ml-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                            </svg>
                          </button>
                        )}
                      </div>
                    </div>
                  </motion.div>
                ))}
              </div>
              
              {/* View all button */}
              <div className="mt-8 text-center relative z-10">
                <button className="px-6 py-2.5 bg-gradient-to-r from-blue-500 to-indigo-500 hover:from-blue-600 hover:to-indigo-600 dark:from-blue-500 dark:to-indigo-500 dark:hover:from-blue-600 dark:hover:to-indigo-600 text-white rounded-full shadow-md hover:shadow-lg transition-all duration-300 text-sm font-medium">
                  View All {reviews.length} Reviews
                </button>
              </div>
            </div>
          </motion.div>
        </div>
      </motion.div>
    </div>
  );
};

export default Reviews;

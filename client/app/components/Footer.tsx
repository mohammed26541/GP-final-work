import Link from 'next/link'
import React from 'react'
import { motion } from 'framer-motion'
import { FaYoutube, FaInstagram, FaGithub, FaPhone, FaMapMarkerAlt, FaEnvelope } from 'react-icons/fa'

type Props = {}

const linkVariants = {
  initial: { x: 0 },
  hover: { x: 8, transition: { duration: 0.2 } }
}

const fadeInUp = {
  initial: { y: 20, opacity: 0 },
  animate: { y: 0, opacity: 1, transition: { duration: 0.5 } }
}

const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
      delayChildren: 0.3
    }
  }
}

const Footer = (props: Props) => {
  return (
    <motion.footer 
      className="pt-20 pb-10 relative dark:bg-[#111827] bg-gray-50"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.8 }}
    >
      {/* Simple subtle background */}
      <div className="absolute inset-0 bg-gradient-to-b from-transparent to-gray-100/50 dark:from-transparent dark:to-gray-900/30" />
      
      {/* Main content container */}
      <div className="w-[95%] 800px:w-full 800px:max-w-[85%] mx-auto px-4 sm:px-6 lg:px-8 relative">
        <motion.div 
          className="grid grid-cols-1 gap-10 sm:grid-cols-2 md:grid-cols-4"
          variants={containerVariants}
          initial="hidden"
          animate="visible"
        >
          {/* About section */}
          <motion.div variants={fadeInUp} className="space-y-5">
            <h3 className="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r dark:from-blue-400 dark:to-purple-600 from-blue-600 to-purple-800 pb-3 mb-4 border-b-2 border-gray-200 dark:border-gray-700">
              About
            </h3>
            <ul className="space-y-4">
              <motion.li
                initial="initial"
                whileHover="hover"
                className="transform transition-all duration-200"
              >
                <motion.div variants={linkVariants} className="flex items-center">
                  <div className="w-1.5 h-1.5 rounded-full bg-blue-500 mr-2"></div>
                  <Link
                    href="/about"
                    className="text-base font-medium text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors duration-200"
                  >
                    Our Story
                  </Link>
                </motion.div>
              </motion.li>
              <motion.li
                initial="initial"
                whileHover="hover"
                className="transform transition-all duration-200"
              >
                <motion.div variants={linkVariants} className="flex items-center">
                  <div className="w-1.5 h-1.5 rounded-full bg-blue-500 mr-2"></div>
                  <Link
                    href="/privacy-policy"
                    className="text-base font-medium text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors duration-200"
                  >
                    Privacy Policy
                  </Link>
                </motion.div>
              </motion.li>
              <motion.li
                initial="initial"
                whileHover="hover"
                className="transform transition-all duration-200"
              >
                <motion.div variants={linkVariants} className="flex items-center">
                  <div className="w-1.5 h-1.5 rounded-full bg-blue-500 mr-2"></div>
                  <Link
                    href="/faq"
                    className="text-base font-medium text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors duration-200"
                  >
                    FAQ
                  </Link>
                </motion.div>
              </motion.li>
            </ul>
          </motion.div>
          
          {/* Quick Links section */}
          <motion.div variants={fadeInUp} className="space-y-5">
            <h3 className="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r dark:from-blue-400 dark:to-purple-600 from-blue-600 to-purple-800 pb-3 mb-4 border-b-2 border-gray-200 dark:border-gray-700">
              Quick Links
            </h3>
            <ul className="space-y-4">
              <motion.li
                initial="initial"
                whileHover="hover"
                className="transform transition-all duration-200"
              >
                <motion.div variants={linkVariants} className="flex items-center">
                  <div className="w-1.5 h-1.5 rounded-full bg-blue-500 mr-2"></div>
                  <Link
                    href="/courses"
                    className="text-base font-medium text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors duration-200"
                  >
                    Courses
                  </Link>
                </motion.div>
              </motion.li>
              <motion.li
                initial="initial"
                whileHover="hover"
                className="transform transition-all duration-200"
              >
                <motion.div variants={linkVariants} className="flex items-center">
                  <div className="w-1.5 h-1.5 rounded-full bg-blue-500 mr-2"></div>
                  <Link
                    href="/profile"
                    className="text-base font-medium text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors duration-200"
                  >
                    My Account
                  </Link>
                </motion.div>
              </motion.li>
              <motion.li
                initial="initial"
                whileHover="hover"
                className="transform transition-all duration-200"
              >
                <motion.div variants={linkVariants} className="flex items-center">
                  <div className="w-1.5 h-1.5 rounded-full bg-blue-500 mr-2"></div>
                  <Link
                    href="/course-dashboard"
                    className="text-base font-medium text-gray-700 dark:text-gray-300 hover:text-blue-600 dark:hover:text-blue-400 transition-colors duration-200"
                  >
                    Course Dashboard
                  </Link>
                </motion.div>
              </motion.li>
            </ul>
          </motion.div>
          
          {/* Social Links section */}
          <motion.div variants={fadeInUp} className="space-y-5">
            <h3 className="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r dark:from-blue-400 dark:to-purple-600 from-blue-600 to-purple-800 pb-3 mb-4 border-b-2 border-gray-200 dark:border-gray-700">
              Social Links
            </h3>
            <ul className="space-y-4">
              <motion.li
                initial="initial"
                whileHover="hover"
                className="transform transition-all duration-200"
              >
                <motion.div variants={linkVariants} className="flex items-center">
                  <div className="p-2 rounded-full bg-red-500/10 mr-3">
                    <FaYoutube className="text-red-500 text-lg" />
                  </div>
                  <Link
                    href="https://www.youtube.com/channel/"
                    className="text-base font-medium text-gray-700 dark:text-gray-300 hover:text-red-500 dark:hover:text-red-400 transition-colors duration-200"
                  >
                    Youtube
                  </Link>
                </motion.div>
              </motion.li>
              <motion.li
                initial="initial"
                whileHover="hover"
                className="transform transition-all duration-200"
              >
                <motion.div variants={linkVariants} className="flex items-center">
                  <div className="p-2 rounded-full bg-pink-500/10 mr-3">
                    <FaInstagram className="text-pink-500 text-lg" />
                  </div>
                  <Link
                    href="https://www.instagram.com/"
                    className="text-base font-medium text-gray-700 dark:text-gray-300 hover:text-pink-500 dark:hover:text-pink-400 transition-colors duration-200"
                  >
                    Instagram
                  </Link>
                </motion.div>
              </motion.li>
              <motion.li
                initial="initial"
                whileHover="hover"
                className="transform transition-all duration-200"
              >
                <motion.div variants={linkVariants} className="flex items-center">
                  <div className="p-2 rounded-full bg-gray-500/10 mr-3">
                    <FaGithub className="text-gray-700 dark:text-gray-300 text-lg" />
                  </div>
                  <Link
                    href="https://www.github.com/"
                    className="text-base font-medium text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition-colors duration-200"
                  >
                    Github
                  </Link>
                </motion.div>
              </motion.li>
            </ul>
          </motion.div>
          
          {/* Contact Info section */}
          <motion.div variants={fadeInUp} className="space-y-5">
            <h3 className="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r dark:from-blue-400 dark:to-purple-600 from-blue-600 to-purple-800 pb-3 mb-4 border-b-2 border-gray-200 dark:border-gray-700">
              Contact Info
            </h3>
            <div className="space-y-4">
              <motion.div 
                className="flex items-center group cursor-pointer"
                initial="initial"
                whileHover="hover"
              >
                <div className="p-2 rounded-full bg-green-500/10 mr-3 group-hover:bg-green-500/20 transition-all duration-300">
                  <FaPhone className="text-green-500 text-lg" />
                </div>
                <motion.span 
                  variants={linkVariants}
                  className="text-base font-medium text-gray-700 dark:text-gray-300 group-hover:text-green-600 dark:group-hover:text-green-400 transition-colors duration-200"
                >
                  1-885-665-2022
                </motion.span>
              </motion.div>
              
              <motion.div 
                className="flex items-center group cursor-pointer"
                initial="initial"
                whileHover="hover"
              >
                <div className="p-2 rounded-full bg-blue-500/10 mr-3 group-hover:bg-blue-500/20 transition-all duration-300">
                  <FaMapMarkerAlt className="text-blue-500 text-lg" />
                </div>
                <motion.span 
                  variants={linkVariants}
                  className="text-base font-medium text-gray-700 dark:text-gray-300 group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors duration-200"
                >
                  7011 Vermont Ave, Los Angeles, CA 90044
                </motion.span>
              </motion.div>
              
              <motion.div 
                className="flex items-center group cursor-pointer"
                initial="initial"
                whileHover="hover"
              >
                <div className="p-2 rounded-full bg-purple-500/10 mr-3 group-hover:bg-purple-500/20 transition-all duration-300">
                  <FaEnvelope className="text-purple-500 text-lg" />
                </div>
                <motion.span 
                  variants={linkVariants}
                  className="text-base font-medium text-gray-700 dark:text-gray-300 group-hover:text-purple-600 dark:group-hover:text-purple-400 transition-colors duration-200"
                >
                  hello@elearning.com
                </motion.span>
              </motion.div>
            </div>
          </motion.div>
        </motion.div>
        
        {/* Copyright section */}
        <motion.div 
          className="mt-16 pt-8 border-t border-gray-200 dark:border-gray-700"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.8, duration: 0.5 }}
        >
          <p className="text-center text-gray-600 dark:text-gray-400 text-sm">
            Copyright © {new Date().getFullYear()} <span className="font-medium text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400">Elearning</span> | All Rights Reserved
          </p>
        </motion.div>
      </div>
    </motion.footer>
  )
}

export default Footer

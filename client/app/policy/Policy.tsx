import React, { useState } from "react";
import { styles } from "../styles/style";
import { motion, AnimatePresence } from "framer-motion";
import { HiChevronDown, HiOutlineShieldCheck, HiOutlineDocumentText } from 'react-icons/hi';
import { FaRegLightbulb } from 'react-icons/fa';

const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.15
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
      ease: "easeOut"
    }
  }
};

const policies = [
  {
    id: 1,
    title: "Terms of Use",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Facere blanditiis architecto quasi impedit in dicta nisi, asperiores voluptatum eos alias facilis assumenda ex beatae, culpa dignissimos accusantium quod numquam dolores!"
  },
  {
    id: 2,
    title: "Privacy Policy",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Facere blanditiis architecto quasi impedit in dicta nisi, asperiores voluptatum eos alias facilis assumenda ex beatae."
  },
  {
    id: 3,
    title: "User Guidelines",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Facere blanditiis architecto quasi impedit in dicta nisi, asperiores voluptatum eos alias facilis assumenda ex beatae, culpa dignissimos accusantium quod numquam dolores!"
  },
  {
    id: 4,
    title: "Content Usage Rights",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Facere blanditiis architecto quasi impedit in dicta nisi, asperiores voluptatum eos alias facilis assumenda."
  },
  {
    id: 5,
    title: "Payment Terms",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Facere blanditiis architecto quasi impedit in dicta nisi, asperiores voluptatum eos alias facilis assumenda ex beatae, culpa dignissimos accusantium."
  },
  {
    id: 6,
    title: "Refund Policy",
    content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Facere blanditiis architecto quasi impedit in dicta nisi, asperiores voluptatum eos alias facilis assumenda ex beatae, culpa dignissimos accusantium quod numquam dolores!"
  }
];

type Props = {};

const Policy = (props: Props) => {
  const [expandedId, setExpandedId] = useState<number | null>(null);

  const toggleExpand = (id: number) => {
    setExpandedId(expandedId === id ? null : id);
  };

  return (
    <motion.div
      initial="hidden"
      animate="visible"
      variants={containerVariants}
      className="min-h-screen bg-gradient-to-b from-transparent via-gray-50/50 to-gray-100/50 dark:via-gray-900/30 dark:to-gray-900/50 py-12 relative overflow-hidden"
    >
      {/* AI-inspired background elements */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none">
        {/* Glowing orbs */}
        <div className="absolute top-1/4 right-1/4 w-64 h-64 bg-blue-500/5 dark:bg-blue-500/10 rounded-full blur-3xl"></div>
        <div className="absolute bottom-1/3 left-1/4 w-80 h-80 bg-indigo-500/5 dark:bg-indigo-500/10 rounded-full blur-3xl"></div>
        
        {/* Neural network-like connections */}
        <div className="absolute top-0 left-0 w-full h-full opacity-10 dark:opacity-15">
          <svg className="w-full h-full" viewBox="0 0 1000 800" xmlns="http://www.w3.org/2000/svg">
            <path d="M100,100 Q300,50 500,100 T900,100" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M100,200 Q300,250 500,200 T900,200" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M100,300 Q300,350 500,300 T900,300" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M100,400 Q300,450 500,400 T900,400" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M100,500 Q300,550 500,500 T900,500" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M100,600 Q300,650 500,600 T900,600" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M200,50 Q250,200 200,350 T200,650" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M400,50 Q450,200 400,350 T400,650" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M600,50 Q650,200 600,350 T600,650" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M800,50 Q850,200 800,350 T800,650" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <defs>
              <linearGradient id="gradient1" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" stopColor="#3b82f6" stopOpacity="0.3" />
                <stop offset="100%" stopColor="#6366f1" stopOpacity="0.3" />
              </linearGradient>
            </defs>
          </svg>
        </div>

        {/* Digital circuit pattern */}
        <div className="absolute bottom-0 left-0 w-full h-64 opacity-5 dark:opacity-10">
          <svg className="w-full h-full" viewBox="0 0 1000 200" preserveAspectRatio="none">
            <path d="M0,100 L200,100 L220,80 L300,80 L320,100 L400,100 L420,120 L500,120 L520,100 L600,100 L620,80 L700,80 L720,100 L800,100" 
              stroke="#4f46e5" fill="none" strokeWidth="1" />
            <path d="M0,150 L100,150 L120,130 L200,130 L220,150 L300,150 L320,170 L400,170 L420,150 L500,150" 
              stroke="#4f46e5" fill="none" strokeWidth="1" />
            <path d="M700,150 L720,130 L800,130 L820,150 L900,150" 
              stroke="#4f46e5" fill="none" strokeWidth="1" />
            <circle cx="200" cy="100" r="3" fill="#4f46e5" />
            <circle cx="400" cy="100" r="3" fill="#4f46e5" />
            <circle cx="600" cy="100" r="3" fill="#4f46e5" />
            <circle cx="800" cy="100" r="3" fill="#4f46e5" />
            <circle cx="300" cy="150" r="3" fill="#4f46e5" />
            <circle cx="500" cy="150" r="3" fill="#4f46e5" />
            <circle cx="700" cy="150" r="3" fill="#4f46e5" />
          </svg>
        </div>
      </div>
      <motion.div 
        className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10"
        variants={containerVariants}
      >
        {/* Floating elements */}
        <div className="absolute -top-10 -left-10 w-20 h-20 bg-blue-500/10 dark:bg-blue-500/20 rounded-full blur-xl animate-pulse"></div>
        <div className="absolute -bottom-10 -right-10 w-20 h-20 bg-indigo-500/10 dark:bg-indigo-500/20 rounded-full blur-xl animate-pulse"></div>
        
        <motion.div 
          className="bg-white/80 dark:bg-gray-800/50 rounded-2xl p-8 shadow-lg border border-gray-100/80 dark:border-gray-700/50 backdrop-blur-sm relative overflow-hidden"
          variants={itemVariants}
        >
          {/* Hexagonal pattern background */}
          <div className="absolute inset-0 opacity-5 dark:opacity-10 pointer-events-none">
            <svg className="w-full h-full" preserveAspectRatio="none">
              <pattern id="hexagrid" width="30" height="30" patternUnits="userSpaceOnUse" patternTransform="rotate(30)">
                <path d="M15,0 L30,7.5 L30,22.5 L15,30 L0,22.5 L0,7.5 Z" fill="none" stroke="#3b82f6" strokeWidth="0.5" />
              </pattern>
              <rect width="100%" height="100%" fill="url(#hexagrid)" />
            </svg>
          </div>
          
          {/* Top border glow */}
          <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-blue-500/0 via-blue-500/30 dark:via-blue-500/50 to-blue-500/0"></div>
          <motion.div className="relative mb-10 text-center">
            <div className="absolute top-1/2 left-0 right-0 h-px bg-gradient-to-r from-transparent via-blue-500/20 dark:via-blue-500/30 to-transparent"></div>
            <motion.div 
              className="relative inline-block bg-white/50 dark:bg-gray-900/50 backdrop-blur-md px-3 py-1 rounded-full border border-blue-500/10 dark:border-blue-500/20 shadow-sm mb-4"
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
            >
              <span className="text-sm font-medium bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400">
                OFFICIAL DOCUMENTATION
              </span>
            </motion.div>
            
            <motion.h1 
              variants={itemVariants}
              className={`${styles.title} text-3xl md:text-4xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400 bg-clip-text text-transparent relative inline-block`}
            >
              <span className="relative">
                Platform Terms and Conditions
                <motion.span 
                  className="absolute -bottom-2 left-0 right-0 h-1 bg-gradient-to-r from-transparent via-blue-500/30 dark:via-blue-500/40 to-transparent rounded-full blur-sm"
                  initial={{ width: 0, left: '50%' }}
                  animate={{ width: '100%', left: '0%' }}
                  transition={{ duration: 1, delay: 0.5 }}
                />
              </span>
            </motion.h1>
            
            <div className="flex justify-center mt-4">
              <div className="flex items-center text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/20 px-3 py-1 rounded-full text-sm">
                <HiOutlineShieldCheck className="mr-1" />
                <span>Secure & Compliant</span>
              </div>
            </div>
          </motion.div>
          
          <motion.div 
            variants={containerVariants}
            className="space-y-4 text-gray-600 dark:text-gray-300"
          >
            {policies.map((policy) => (
              <motion.div
                key={policy.id}
                variants={itemVariants}
                className="bg-gradient-to-br from-white/90 to-gray-50/90 dark:from-gray-800/50 dark:to-gray-800/30 rounded-xl overflow-hidden border border-gray-100/80 dark:border-gray-700/50 backdrop-blur-sm relative group"
                whileHover={{ y: -2, boxShadow: "0 10px 25px -5px rgba(59, 130, 246, 0.1)" }}
              >
                {/* Subtle pattern background */}
                <div className="absolute inset-0 opacity-5 dark:opacity-10 pointer-events-none overflow-hidden">
                  <svg className="w-full h-full" preserveAspectRatio="none">
                    <pattern id={`dotgrid-${policy.id}`} width="20" height="20" patternUnits="userSpaceOnUse">
                      <circle cx="10" cy="10" r="1" fill="#3b82f6" />
                    </pattern>
                    <rect width="100%" height="100%" fill={`url(#dotgrid-${policy.id})`} />
                  </svg>
                </div>
                
                <motion.button
                  onClick={() => toggleExpand(policy.id)}
                  className="w-full px-6 py-5 flex items-center justify-between text-left hover:bg-blue-50/30 dark:hover:bg-blue-900/10 transition-colors relative"
                >
                  <div className="flex items-center">
                    <div className="mr-3 relative">
                      <div className="absolute inset-0 bg-gradient-to-r from-blue-500/20 to-indigo-500/20 dark:from-blue-500/30 dark:to-indigo-500/30 rounded-full blur-md animate-pulse"></div>
                      <div className="relative bg-white/20 dark:bg-gray-900/50 p-2 rounded-full border border-blue-500/30">
                        <HiOutlineDocumentText className="text-blue-500 dark:text-blue-400" size={18} />
                      </div>
                    </div>
                    <span className="text-lg font-semibold bg-gradient-to-r from-gray-900 to-gray-700 dark:from-gray-100 dark:to-gray-300 bg-clip-text text-transparent">
                      {policy.title}
                    </span>
                  </div>
                  <div className="flex items-center">
                    <span className="text-xs font-medium text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/20 px-2 py-1 rounded-full mr-3 opacity-80">
                      {expandedId === policy.id ? "Hide" : "View"}
                    </span>
                    <motion.div
                      animate={{ rotate: expandedId === policy.id ? 180 : 0, backgroundColor: expandedId === policy.id ? "rgba(59, 130, 246, 0.1)" : "transparent" }}
                      transition={{ duration: 0.3 }}
                      className="flex items-center justify-center w-8 h-8 rounded-full"
                    >
                      <HiChevronDown className="w-5 h-5 text-blue-500 dark:text-blue-400" />
                    </motion.div>
                  </div>
                </motion.button>

                <AnimatePresence>
                  {expandedId === policy.id && (
                    <motion.div
                      initial={{ height: 0, opacity: 0 }}
                      animate={{
                        height: "auto",
                        opacity: 1,
                        transition: {
                          height: { duration: 0.3 },
                          opacity: { duration: 0.3, delay: 0.1 }
                        }
                      }}
                      exit={{
                        height: 0,
                        opacity: 0,
                        transition: {
                          height: { duration: 0.3 },
                          opacity: { duration: 0.2 }
                        }
                      }}
                      className="overflow-hidden"
                    >
                      <div className="px-6 pb-6 pt-2 relative">
                        {/* Side accent line */}
                        <div className="absolute left-6 top-0 bottom-0 w-0.5 bg-gradient-to-b from-blue-500/30 to-indigo-500/30 dark:from-blue-500/40 dark:to-indigo-500/40 rounded-full"></div>
                        
                        <div className="pl-6 text-base leading-relaxed text-gray-600 dark:text-gray-300 relative">
                          {/* Subtle highlight effect */}
                          <div className="absolute top-0 left-0 right-0 h-8 bg-gradient-to-r from-blue-500/5 to-transparent dark:from-blue-500/10 rounded-md"></div>
                          
                          {/* Content with light bulb icon for important points */}
                          <div className="flex items-start space-x-2 mb-4">
                            <div className="flex-shrink-0 mt-1">
                              <FaRegLightbulb className="text-blue-500 dark:text-blue-400 w-4 h-4" />
                            </div>
                            <p>{policy.content}</p>
                          </div>
                          
                          {/* Additional info box */}
                          <div className="mt-4 bg-blue-50/50 dark:bg-blue-900/10 p-4 rounded-lg border border-blue-100 dark:border-blue-800/30">
                            <div className="flex items-center mb-2">
                              <HiOutlineShieldCheck className="text-blue-500 dark:text-blue-400 w-5 h-5 mr-2" />
                              <span className="font-medium text-blue-700 dark:text-blue-300">Important Note</span>
                            </div>
                            <p className="text-sm text-gray-600 dark:text-gray-400">
                              These terms are regularly updated to comply with the latest regulations. Please review them periodically.
                            </p>
                          </div>
                        </div>
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </motion.div>
            ))}
          </motion.div>

          <motion.div 
            variants={itemVariants}
            className="mt-10 pt-6 border-t border-gray-100 dark:border-gray-700/50 text-center relative"
          >
            {/* Decorative elements */}
            <div className="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
              <div className="bg-white dark:bg-gray-800 px-4 relative">
                <div className="w-8 h-8 rounded-full bg-gradient-to-r from-blue-500/10 to-indigo-500/10 dark:from-blue-500/20 dark:to-indigo-500/20 flex items-center justify-center border border-blue-100 dark:border-blue-800/30">
                  <div className="w-2 h-2 rounded-full bg-blue-500 dark:bg-blue-400 animate-pulse"></div>
                </div>
              </div>
            </div>
            
            <div className="flex flex-col items-center">
              <div className="mb-3 flex items-center space-x-2">
                <div className="h-px w-8 bg-gradient-to-r from-transparent to-blue-500/30 dark:to-blue-500/40"></div>
                <div className="text-xs font-medium text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/20 px-2 py-1 rounded-full">
                  OFFICIAL DOCUMENT
                </div>
                <div className="h-px w-8 bg-gradient-to-l from-transparent to-blue-500/30 dark:to-blue-500/40"></div>
              </div>
              
              <p className="text-sm text-gray-500 dark:text-gray-400 mb-1">
                Last updated: April 2025
              </p>
              
              <p className="text-xs text-gray-400 dark:text-gray-500">
                Document ID: LMS-TC-2025-04
              </p>
            </div>
          </motion.div>
        </motion.div>
      </motion.div>
    </motion.div>
  );
};

export default Policy;

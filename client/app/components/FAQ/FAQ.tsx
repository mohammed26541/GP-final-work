import { styles } from '@/app/styles/style';
import { useGetHeroDataQuery } from '@/redux/features/layout/layoutApi';
import React, { useEffect, useState } from 'react'
import { motion, AnimatePresence, useReducedMotion } from 'framer-motion';
import { HiMinus, HiPlus, HiOutlineLightBulb, HiOutlineInformationCircle } from 'react-icons/hi';
import { FiSearch, FiFilter } from 'react-icons/fi';
import { FaRobot, FaBrain, FaRegLightbulb } from 'react-icons/fa';

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
  },
  exit: {
    opacity: 0,
    y: -20,
    transition: {
      duration: 0.3
    }
  }
};

const searchVariants = {
  hidden: { opacity: 0, scale: 0.95 },
  visible: {
    opacity: 1,
    scale: 1,
    transition: {
      duration: 0.4,
      ease: 'easeOut'
    }
  }
};

type Props = {}

const TypedText = ({ text }: { text: string }) => {
  const [displayedText, setDisplayedText] = useState('');
  const [isTypingComplete, setIsTypingComplete] = useState(false);

  useEffect(() => {
    let currentIndex = 0;
    const typingInterval = setInterval(() => {
      if (currentIndex <= text.length) {
        setDisplayedText(text.slice(0, currentIndex));
        currentIndex++;
      } else {
        setIsTypingComplete(true);
        clearInterval(typingInterval);
      }
    }, 50); // Adjust typing speed here

    return () => clearInterval(typingInterval);
  }, [text]);

  return (
    <motion.div className="inline-flex items-center">
      <motion.span>{displayedText}</motion.span>
      <motion.span
        animate={{
          opacity: isTypingComplete ? [1, 0] : [0, 1],
          transition: {
            duration: 0.5,
            repeat: Infinity,
            repeatType: 'reverse'
          }
        }}
        className="ml-1 inline-block w-[2px] h-[1.2em] bg-blue-500 dark:bg-blue-400"
      />
    </motion.div>
  );
};

const FAQ = (props: Props) => {
  const shouldReduceMotion = useReducedMotion();
  const { data } = useGetHeroDataQuery("FAQ", {});
  const [activeQuestion, setActiveQuestion] = useState(null);
  const [questions, setQuestions] = useState<any[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [filteredQuestions, setFilteredQuestions] = useState<any[]>([]);
  
  // Add fixed dot positions to prevent random regeneration on each render
  const dotPositions = React.useMemo(() => Array.from({ length: 3 }).map(() => ({
    top: `${20 + Math.random() * 60}%`,
    left: `${20 + Math.random() * 60}%`,
  })), []);

  useEffect(() => {
    if (data) {
      setQuestions(data.layout?.faq);
      setFilteredQuestions(data.layout?.faq);
    }
  }, [data]);

  useEffect(() => {
    const filtered = questions.filter(q =>
      q.question.toLowerCase().includes(searchQuery.toLowerCase()) ||
      q.answer.toLowerCase().includes(searchQuery.toLowerCase())
    );
    setFilteredQuestions(filtered);
  }, [searchQuery, questions]);

  const toggleQuestion = (id: any) => {
    setActiveQuestion(activeQuestion === id ? null : id);
  };

  return (
    <motion.div 
      initial="hidden"
      animate="visible"
      className="min-h-screen py-12 bg-gradient-to-b from-transparent to-gray-50 dark:to-gray-900/30 relative overflow-hidden"
    >
      {/* Minimal AI-inspired background elements */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none">
        {/* Subtle neural network pattern */}
        <div className="absolute top-0 left-0 w-full h-full opacity-5 dark:opacity-10">
          <svg className="w-full h-full" viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
            <path d="M100,100 L300,150 L500,100 L700,150" stroke="#4f46e5" strokeWidth="0.5" fill="none" />
            <path d="M100,200 L300,250 L500,200 L700,250" stroke="#4f46e5" strokeWidth="0.5" fill="none" />
            <path d="M100,300 L300,350 L500,300 L700,350" stroke="#4f46e5" strokeWidth="0.5" fill="none" />
            <path d="M100,400 L300,450 L500,400 L700,450" stroke="#4f46e5" strokeWidth="0.5" fill="none" />
            <path d="M100,100 L100,400" stroke="#4f46e5" strokeWidth="0.5" fill="none" />
            <path d="M300,150 L300,450" stroke="#4f46e5" strokeWidth="0.5" fill="none" />
            <path d="M500,100 L500,400" stroke="#4f46e5" strokeWidth="0.5" fill="none" />
            <path d="M700,150 L700,450" stroke="#4f46e5" strokeWidth="0.5" fill="none" />
            <circle cx="100" cy="100" r="3" fill="#4f46e5" />
            <circle cx="100" cy="200" r="3" fill="#4f46e5" />
            <circle cx="100" cy="300" r="3" fill="#4f46e5" />
            <circle cx="100" cy="400" r="3" fill="#4f46e5" />
            <circle cx="300" cy="150" r="3" fill="#4f46e5" />
            <circle cx="300" cy="250" r="3" fill="#4f46e5" />
            <circle cx="300" cy="350" r="3" fill="#4f46e5" />
            <circle cx="300" cy="450" r="3" fill="#4f46e5" />
            <circle cx="500" cy="100" r="3" fill="#4f46e5" />
            <circle cx="500" cy="200" r="3" fill="#4f46e5" />
            <circle cx="500" cy="300" r="3" fill="#4f46e5" />
            <circle cx="500" cy="400" r="3" fill="#4f46e5" />
            <circle cx="700" cy="150" r="3" fill="#4f46e5" />
            <circle cx="700" cy="250" r="3" fill="#4f46e5" />
            <circle cx="700" cy="350" r="3" fill="#4f46e5" />
            <circle cx="700" cy="450" r="3" fill="#4f46e5" />
          </svg>
        </div>
        
        {/* Subtle glow effects */}
        <div className="absolute top-1/4 left-1/4 w-64 h-64 bg-blue-500/5 dark:bg-blue-500/10 rounded-full blur-3xl"></div>
        <div className="absolute bottom-1/3 right-1/4 w-64 h-64 bg-indigo-500/5 dark:bg-indigo-500/10 rounded-full blur-3xl"></div>
      </div>

      <motion.div 
        variants={containerVariants}
        className="w-[90%] 800px:w-[80%] max-w-4xl mx-auto space-y-10">
        {/* Header section */}
        <div className="text-center space-y-5 relative">
          
          <motion.h1
            variants={itemVariants}
            className="relative inline-block"
          >
            <span className={`${styles.title} text-3xl 800px:text-[40px] bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400`}>
              Frequently Asked Questions
            </span>
            {/* Simple underline */}
            <div className="h-1 w-full bg-gradient-to-r from-blue-500 to-indigo-500 dark:from-blue-400 dark:to-indigo-400 rounded-full mt-2"></div>
          </motion.h1>
          
          <motion.div
            variants={itemVariants}
            className="text-gray-700 dark:text-gray-300 max-w-2xl mx-auto text-lg font-medium"
          >
            <TypedText text="Find answers to common questions about our platform" />
          </motion.div>
        </div>

        {/* Enhanced search section */}
        <motion.div
          variants={searchVariants}
          className="relative max-w-2xl mx-auto bg-white/80 dark:bg-gray-800/40 rounded-lg border border-gray-200/80 dark:border-gray-700/50 shadow-sm p-4 backdrop-blur-sm"
        >
          <div className="flex items-center mb-2">
            <div className="w-1 h-4 bg-blue-500 dark:bg-blue-400 rounded-full mr-2"></div>
            <span className="text-xs font-medium text-gray-600 dark:text-gray-400 uppercase tracking-wider">Search Knowledge Base</span>
          </div>
          
          <div className="relative">
            {/* Search icon */}
            <div className="absolute left-3 top-1/2 transform -translate-y-1/2 flex items-center justify-center">
              <FiSearch className="text-blue-500 dark:text-blue-400 text-lg" />
            </div>
            
            {/* AI badge */}
            <div className="absolute right-3 top-1/2 transform -translate-y-1/2 flex items-center">
              <div className="flex items-center space-x-1 px-2 py-1 rounded-full bg-blue-50 dark:bg-blue-900/20 border border-blue-100 dark:border-blue-800/30">
                <FaRobot className="text-blue-500 dark:text-blue-400 text-xs" />
                <span className="text-xs font-medium text-blue-600 dark:text-blue-400">AI</span>
              </div>
            </div>
            
            <input
              type="text"
              placeholder="Search questions..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-16 py-3 rounded-md bg-white/90 dark:bg-gray-800/60 border border-gray-200/80 dark:border-gray-700/50 focus:outline-none focus:ring-1 focus:ring-blue-500/50 focus:border-blue-300 dark:focus:border-blue-700 transition-all duration-300 text-gray-800 dark:text-gray-200 placeholder-gray-500 dark:placeholder-gray-400"
            />
          </div>
          
          {/* Search info */}
          <div className="mt-2 flex items-center justify-end">
            <div className="flex items-center text-xs text-gray-500 dark:text-gray-400">
              <HiOutlineLightBulb className="mr-1 text-blue-500 dark:text-blue-400" />
              <span>{filteredQuestions.length} results found</span>
            </div>
          </div>
        </motion.div>
        <motion.div 
          variants={containerVariants}
          className="space-y-4 relative">
          
          {/* Section header */}
          <div className="flex items-center mb-4">
            <div className="w-1 h-5 bg-gradient-to-b from-blue-500 to-indigo-500 rounded-full mr-3"></div>
            <h3 className="text-base font-medium text-gray-700 dark:text-gray-300">Frequently Asked Questions ({filteredQuestions.length})</h3>
          </div>
          
          <AnimatePresence mode="popLayout">
            {filteredQuestions.map((q) => (
              <motion.div
                key={q._id}
                variants={itemVariants}
                layout={!shouldReduceMotion}
                className="bg-white/90 dark:bg-gray-800/40 rounded-lg shadow-sm hover:shadow-md transition-all duration-300 border border-gray-200/80 dark:border-gray-700/50 hover:border-blue-200 dark:hover:border-blue-800/50 overflow-hidden backdrop-blur-sm group"
                whileHover={{ y: -2, transition: { duration: 0.2 } }}
              >
                {/* Minimal dot pattern for AI aesthetic */}
                <div className="absolute inset-0 overflow-hidden opacity-5 dark:opacity-10 pointer-events-none">
                  {dotPositions.map((position, i) => (
                    <div 
                      key={`dot-${q._id}-${i}`} 
                      className="absolute w-1.5 h-1.5 rounded-full bg-blue-500"
                      style={{
                        top: position.top,
                        left: position.left,
                      }}
                    />
                  ))}
                </div>
                
                <button
                  className="w-full px-5 py-4 text-left focus:outline-none group hover:bg-blue-50/50 dark:hover:bg-blue-900/10 transition-colors rounded-lg"
                  onClick={() => toggleQuestion(q._id)}
                >
                  <div className="flex items-center justify-between gap-4">
                    <div className="flex items-center gap-3">
                      {/* Minimal Q badge */}
                      <div className="relative flex-shrink-0">
                        <span className="flex-shrink-0 w-7 h-7 flex items-center justify-center rounded-full bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 font-medium text-xs border border-blue-100 dark:border-blue-800/30">
                          Q
                        </span>
                      </div>
                      
                      {/* Question text */}
                      <span className="font-medium text-gray-800 dark:text-gray-200 text-base group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                        {q.question}
                      </span>
                    </div>
                    
                    {/* Toggle button */}
                    <div className="flex items-center">
                      <span className="text-xs mr-2 text-gray-500 dark:text-gray-400 group-hover:text-blue-500 dark:group-hover:text-blue-400 transition-colors">
                        {activeQuestion === q._id ? 'Hide' : 'View'}
                      </span>
                      <motion.div
                        animate={{ rotate: activeQuestion === q._id ? 180 : 0 }}
                        transition={{ duration: 0.3 }}
                        className="flex-shrink-0 w-5 h-5 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center group-hover:bg-blue-100 dark:group-hover:bg-blue-900/30 transition-colors"
                      >
                        {activeQuestion === q._id ? (
                          <HiMinus className="h-3 w-3 text-gray-500 dark:text-gray-400 group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors" />
                        ) : (
                          <HiPlus className="h-3 w-3 text-gray-500 dark:text-gray-400 group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors" />
                        )}
                      </motion.div>
                    </div>
                  </div>
                </button>
                
                <AnimatePresence>
                  {activeQuestion === q._id && (
                    <motion.div
                      initial={{ height: 0, opacity: 0 }}
                      animate={{ 
                        height: "auto", 
                        opacity: 1,
                        transition: {
                          height: { duration: 0.3, ease: 'easeOut' },
                          opacity: { duration: 0.2, delay: 0.1 }
                        }
                      }}
                      exit={{ 
                        height: 0, 
                        opacity: 0,
                        transition: {
                          height: { duration: 0.3, ease: 'easeIn' },
                          opacity: { duration: 0.2 }
                        }
                      }}
                      className="overflow-hidden"
                    >
                      <div className="px-5 pb-4 relative">
                        {/* Subtle separator line */}
                        <div className="h-px w-full bg-gray-100 dark:bg-gray-700/50 mb-3"></div>
                        
                        <div className="flex gap-3 items-start">
                          {/* Minimal A badge */}
                          <div className="relative flex-shrink-0 mt-1">
                            <span className="flex-shrink-0 w-7 h-7 flex items-center justify-center rounded-full bg-green-50 dark:bg-green-900/30 text-green-600 dark:text-green-400 font-medium text-xs border border-green-100 dark:border-green-800/30">
                              A
                            </span>
                          </div>
                          
                          <div className="space-y-3 flex-1">
                            {/* Answer text with lightbulb icon */}
                            <p className="text-base text-gray-700 dark:text-gray-300 leading-relaxed">
                              <FaRegLightbulb className="inline-block mr-2 text-green-500 dark:text-green-400 h-4 w-4 align-text-bottom" />
                              {q.answer}
                            </p>
                            
                            {/* AI-powered info box - minimal version */}
                            <div className="mt-2 bg-blue-50/50 dark:bg-blue-900/10 p-3 rounded-md border border-blue-100/80 dark:border-blue-800/20">
                              <div className="flex items-center mb-1">
                                <FaRobot className="text-blue-500 dark:text-blue-400 w-3 h-3 mr-2" />
                                <span className="font-medium text-blue-700 dark:text-blue-300 text-xs">AI Insight</span>
                              </div>
                              <p className="text-xs text-gray-600 dark:text-gray-400">
                                This answer is regularly updated based on user feedback and platform changes.
                              </p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </motion.div>
            ))}
          </AnimatePresence>
          
          {/* Empty state when no results */}
          {filteredQuestions.length === 0 && (
            <motion.div 
              variants={itemVariants}
              className="bg-white/90 dark:bg-gray-800/40 rounded-lg p-6 text-center border border-gray-200/80 dark:border-gray-700/50 backdrop-blur-sm"
            >
              <HiOutlineInformationCircle className="w-10 h-10 text-blue-500/70 dark:text-blue-400/70 mx-auto mb-3" />
              <h3 className="text-gray-700 dark:text-gray-300 font-medium mb-1">No matching questions found</h3>
              <p className="text-gray-500 dark:text-gray-400 text-sm">Try adjusting your search query</p>
            </motion.div>
          )}
        </motion.div>
        
        {/* Minimal AI-inspired footer */}
        <motion.div
          variants={itemVariants}
          className="mt-12 pt-6 border-t border-gray-200/50 dark:border-gray-700/30 text-center relative"
        >
          {/* Decorative element */}
          <div className="absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
            <div className="bg-white dark:bg-gray-900 px-4">
              <div className="w-6 h-6 rounded-full bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-blue-900/20 dark:to-indigo-900/20 flex items-center justify-center border border-blue-100 dark:border-blue-800/30">
                <div className="w-1.5 h-1.5 rounded-full bg-blue-500 dark:bg-blue-400"></div>
              </div>
            </div>
          </div>
          
          <div className="flex flex-col items-center space-y-2">
            <div className="flex items-center space-x-2 text-xs text-gray-500 dark:text-gray-400">
              <FaRobot className="text-blue-500/70 dark:text-blue-400/70 w-3 h-3" />
              <span>AI-powered answers updated regularly</span>
            </div>
            
            <p className="text-xs text-gray-400 dark:text-gray-500">
              Last updated: May 2025
            </p>
          </div>
        </motion.div>
      </motion.div> 
    </motion.div>
  )
}

export default FAQ
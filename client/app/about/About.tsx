import React, { useEffect, useRef } from "react";
import { styles } from "../styles/style";
import { motion } from "framer-motion";
import { FaGithub, FaLinkedin, FaCode, FaUsers, FaRocket, FaAward } from 'react-icons/fa';
import { HiOutlineSparkles } from "react-icons/hi";
import Typed from 'typed.js';

interface TypedHeadingProps {
  text: string;
  gradientFrom: string;
  gradientTo: string;
}

const TypedHeading: React.FC<TypedHeadingProps> = ({ text, gradientFrom, gradientTo }) => {
  const el = useRef(null);

  useEffect(() => {
    const typed = new Typed(el.current, {
      strings: [text],
      typeSpeed: 20,
      showCursor: true,
      cursorChar: '|',
      loop: false
    });

    return () => typed.destroy();
  }, [text]);

  return (
    <h2 className={`text-2xl font-bold mb-4 bg-gradient-to-r ${gradientFrom} ${gradientTo} bg-clip-text text-transparent`}>
      <span ref={el}></span>
    </h2>
  );
};

const teamMembers = [
  {
    id: 1,
    name: "Hossam Ahmed Ragab",
    role: "Team Lead & Full Stack Developer",
    image: "/assests/Hossam.jpg",
    bio: "Leading the development team with expertise in React, Node.js, and system architecture. Passionate about creating scalable educational platforms.",
    github: "https://github.com/ahmad-hassan",
    linkedin: "https://linkedin.com/in/ahmad-hassan"
  },
  {
    id: 2,
    name: "Mohamed Saeed Ibrahim",
    role: "Frontend Developer",
    image: "/assests/Saeed.jpg",
    bio: "UI/UX specialist with a focus on creating intuitive and accessible user interfaces using React and modern CSS frameworks.",
    github: "https://github.com/sarah-khan",
    linkedin: "https://linkedin.com/in/sarah-khan"
  },
  {
    id: 3,
    name: "Mohamed Hany Mohamed",
    role: "Backend Developer",
    image: "/assests/Hany.jpg",
    bio: "Database expert specializing in MongoDB and Express.js. Focused on building robust and secure API architectures.",
    github: "https://github.com/mohammed-ali",
    linkedin: "https://linkedin.com/in/mohammed-ali"
  },
  {
    id: 4,
    name: "Mohamed Sabry Abdelrahman",
    role: "AI/ML Engineer",
    image: "/assests/Sabry.jpg",
    bio: "AI specialist working on chatbot implementation and natural language processing features for enhanced learning experiences.",
    github: "https://github.com/fatima-zahra",
    linkedin: "https://linkedin.com/in/fatima-zahra"
  },
  {
    id: 5,
    name: "Mahmoud Adel Hussein Elbaz",
    role: "DevOps Engineer",
    image: "/assests/Baz.jpg",
    bio: "Managing deployment pipelines and infrastructure. Expert in Docker, AWS, and continuous integration/deployment practices.",
    github: "https://github.com/omar-yusuf",
    linkedin: "https://linkedin.com/in/omar-yusuf"
  },
  {
    id: 6,
    name: "Mahmoud Ibrahim",
    role: "QA Engineer",
    image: "/assests/Hoda.jpg",
    bio: "Ensuring product quality through comprehensive testing strategies. Specialized in automated testing and quality assurance processes.",
    github: "https://github.com/zainab-ahmed",
    linkedin: "https://linkedin.com/in/zainab-ahmed"
  },
  {
    id: 7,
    name: "Esraa Ibrahim",
    role: "UI/UX Designer",
    image: "/assests/Esraa.jpg",
    bio: "Creative designer focused on user experience and interface design. Bringing modern and intuitive design solutions to our platform.",
    github: "https://github.com/yusuf-ibrahim",
    linkedin: "https://linkedin.com/in/yusuf-ibrahim"
  },
  {
    id: 8,
    name: "Abrar Mohamed Youssef",
    role: "Content Strategist",
    image: "/assests/Abrar.jpg",
    bio: "Developing educational content strategy and ensuring high-quality learning materials across the platform.",
    github: "https://github.com/aisha-rahman",
    linkedin: "https://linkedin.com/in/aisha-rahman"
  }
];

const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.2
    }
  }
};

const itemVariants = {
  hidden: { y: 20, opacity: 0 },
  visible: {
    y: 0,
    opacity: 1,
    transition: {
      duration: 0.5,
      ease: "easeOut"
    }
  }
};

const About = () => {
  return (
    <motion.div
      initial="hidden"
      animate="visible"
      variants={containerVariants}
      className="min-h-screen py-12 text-black dark:text-white relative overflow-hidden"
    >
      {/* AI-inspired background elements */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none">
        {/* Glowing orbs */}
        <div className="absolute top-1/4 left-1/4 w-64 h-64 bg-blue-500/5 dark:bg-blue-500/10 rounded-full blur-3xl"></div>
        <div className="absolute bottom-1/3 right-1/4 w-80 h-80 bg-purple-500/5 dark:bg-purple-500/10 rounded-full blur-3xl"></div>
        
        {/* Neural network-like connections */}
        <div className="absolute top-0 left-0 w-full h-full opacity-10">
          <svg className="w-full h-full" viewBox="0 0 1000 800" xmlns="http://www.w3.org/2000/svg">
            <path d="M50,250 Q200,150 350,250 T650,250" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M50,350 Q200,450 350,350 T650,350" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M200,50 Q300,200 200,350 T200,550" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M400,50 Q500,200 400,350 T400,550" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <path d="M600,50 Q700,200 600,350 T600,550" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
            <defs>
              <linearGradient id="gradient1" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" stopColor="#3b82f6" stopOpacity="0.3" />
                <stop offset="100%" stopColor="#8b5cf6" stopOpacity="0.3" />
              </linearGradient>
            </defs>
          </svg>
        </div>
      </div>
      {/* Hero Section with AI-inspired design */}
      <motion.div variants={itemVariants} className="text-center mb-16 relative z-10">
        <motion.div 
          className="w-20 h-20 mx-auto mb-6 relative"
          animate={{ 
            scale: [1, 1.05, 1],
            transition: { duration: 4, repeat: Infinity, ease: "easeInOut" }
          }}
        >
          <div className="absolute inset-0 bg-gradient-to-r from-blue-500/20 to-purple-500/20 dark:from-blue-500/30 dark:to-purple-500/30 rounded-full blur-xl"></div>
          <div className="relative bg-white/10 dark:bg-gray-900/50 backdrop-blur-md rounded-full border border-blue-500/30 h-full w-full flex items-center justify-center">
            <FaRocket className="text-blue-500 dark:text-blue-400 w-8 h-8" />
          </div>
          <div className="absolute -bottom-2 -right-2 w-6 h-6 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full flex items-center justify-center">
            <HiOutlineSparkles className="text-white w-3 h-3" />
          </div>
        </motion.div>
        
        <h1 className={`${styles.title} 800px:!text-[45px] mb-6 relative inline-block`}>
          <span className="relative">
            What is <span className="text-gradient">LMS All IN?</span>
            <motion.span 
              className="absolute -bottom-2 left-0 right-0 h-1 bg-gradient-to-r from-transparent via-blue-500/30 dark:via-blue-500/40 to-transparent rounded-full blur-sm"
              initial={{ width: 0, left: '50%' }}
              animate={{ width: '100%', left: '0%' }}
              transition={{ duration: 1, delay: 0.5 }}
            />
          </span>
        </h1>
        
        <motion.div 
          variants={itemVariants}
          className="text-xl text-gray-600 dark:text-gray-300 max-w-3xl mx-auto relative backdrop-blur-sm py-4 px-6 rounded-xl border border-blue-500/10 dark:border-blue-500/20"
        >
          <div className="absolute inset-0 bg-gradient-to-r from-blue-500/5 to-purple-500/5 dark:from-blue-500/10 dark:to-purple-500/10 rounded-xl"></div>
          <span className="relative" ref={(el) => {
            if (el) {
              const typed = new Typed(el, {
                strings: ['Your premier destination for programming excellence and community-driven learning.'],
                typeSpeed: 20,
                showCursor: true,
                cursorChar: '|',
                loop: false
              });
              return () => typed.destroy();
            }
          }} />
          
          {/* Animated scanner effect */}
          <motion.div 
            className="absolute left-0 right-0 h-px bg-gradient-to-r from-transparent via-blue-400/50 dark:via-blue-400/60 to-transparent"
            animate={{ 
              top: ['0%', '100%'],
              opacity: [0, 1, 0]
            }}
            transition={{
              duration: 2,
              repeat: Infinity,
              repeatType: 'loop',
              ease: 'linear',
              repeatDelay: 1
            }}
          />
        </motion.div>
      </motion.div>

      {/* About Us Section */}
      <motion.div className="w-[95%] 800px:w-[85%] mx-auto mb-16 relative z-10">
        <motion.div 
          variants={itemVariants}
          className="relative mb-12 text-center"
        >
          <div className="absolute top-1/2 left-0 right-0 h-px bg-gradient-to-r from-transparent via-teal-500/20 dark:via-teal-400/30 to-transparent"></div>
          <span className="relative inline-block bg-white/50 dark:bg-gray-900/50 backdrop-blur-md px-6 py-2 rounded-full border border-teal-500/10 dark:border-teal-500/20 shadow-sm">
            <span className="bg-clip-text text-transparent bg-gradient-to-r from-teal-600 to-emerald-600 dark:from-teal-400 dark:to-emerald-400 font-bold tracking-wider">ABOUT US</span>
          </span>
        </motion.div>
        
        <motion.div 
          variants={itemVariants}
          className="bg-gradient-to-br from-white/80 to-gray-100/80 dark:from-gray-900/80 dark:to-gray-800/80 p-8 rounded-2xl backdrop-blur-md border border-teal-500/10 dark:border-teal-500/20 relative overflow-hidden"
        >
          {/* Dot pattern background */}
          <div className="absolute inset-0 opacity-5 dark:opacity-10 pointer-events-none">
            <svg className="w-full h-full" preserveAspectRatio="none">
              <pattern id="dotgrid-about" width="20" height="20" patternUnits="userSpaceOnUse">
                <circle cx="10" cy="10" r="1" fill="#14b8a6" />
              </pattern>
              <rect width="100%" height="100%" fill="url(#dotgrid-about)" />
            </svg>
          </div>
          
          <div className="relative">
            <h2 className="text-2xl font-bold mb-6 bg-gradient-to-r from-teal-600 to-emerald-600 dark:from-teal-400 dark:to-emerald-400 bg-clip-text text-transparent inline-block">
              Our Story
              <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-teal-400/30 dark:via-teal-400/40 to-transparent"></div>
            </h2>
            
            <div className="space-y-4 text-gray-600 dark:text-gray-300">
              <p className="leading-relaxed">
                <span className="font-medium text-teal-600 dark:text-teal-400">LMS All IN</span> was founded in 2023 with a simple yet powerful vision: to democratize access to high-quality programming education. We believe that knowledge should be accessible to everyone, regardless of their background or financial situation.
              </p>
              
              <p className="leading-relaxed">
                Our team of passionate educators, developers, and designers came together with decades of combined experience in both education and industry. We noticed a gap in the market for affordable, comprehensive learning resources that didn't compromise on quality or community support.
              </p>
              
              <p className="leading-relaxed">
                What sets us apart is our commitment to creating a learning environment that combines structured courses with real-world projects and a supportive community. We're not just another online learning platform – we're building a movement of empowered developers who support each other on their journey.
              </p>
              
              <div className="flex flex-wrap gap-4 mt-6">
                <div className="flex items-center gap-2 bg-white/50 dark:bg-gray-800/50 px-4 py-2 rounded-full border border-teal-500/10 dark:border-teal-500/20">
                  <div className="w-3 h-3 rounded-full bg-teal-500"></div>
                  <span className="text-sm font-medium">Founded in 2023</span>
                </div>
                <div className="flex items-center gap-2 bg-white/50 dark:bg-gray-800/50 px-4 py-2 rounded-full border border-teal-500/10 dark:border-teal-500/20">
                  <div className="w-3 h-3 rounded-full bg-emerald-500"></div>
                  <span className="text-sm font-medium">10,000+ Students</span>
                </div>
                <div className="flex items-center gap-2 bg-white/50 dark:bg-gray-800/50 px-4 py-2 rounded-full border border-teal-500/10 dark:border-teal-500/20">
                  <div className="w-3 h-3 rounded-full bg-teal-500"></div>
                  <span className="text-sm font-medium">50+ Courses</span>
                </div>
                <div className="flex items-center gap-2 bg-white/50 dark:bg-gray-800/50 px-4 py-2 rounded-full border border-teal-500/10 dark:border-teal-500/20">
                  <div className="w-3 h-3 rounded-full bg-emerald-500"></div>
                  <span className="text-sm font-medium">Global Community</span>
                </div>
              </div>
            </div>
          </div>
          
          {/* Decorative corner elements */}
          <div className="absolute top-0 right-0 w-20 h-20 overflow-hidden pointer-events-none">
            <div className="absolute top-0 right-0 w-10 h-10 border-t-2 border-r-2 border-teal-500/20 dark:border-teal-500/30 rounded-tr-lg"></div>
          </div>
          <div className="absolute bottom-0 left-0 w-20 h-20 overflow-hidden pointer-events-none">
            <div className="absolute bottom-0 left-0 w-10 h-10 border-b-2 border-l-2 border-teal-500/20 dark:border-teal-500/30 rounded-bl-lg"></div>
          </div>
        </motion.div>
      </motion.div>
      
      {/* What We Offer Section */}
      <motion.div className="w-[95%] 800px:w-[85%] mx-auto mb-16 relative z-10">
        <motion.div 
          variants={itemVariants}
          className="relative mb-12 text-center"
        >
          <div className="absolute top-1/2 left-0 right-0 h-px bg-gradient-to-r from-transparent via-purple-500/20 dark:via-purple-400/30 to-transparent"></div>
          <span className="relative inline-block bg-white/50 dark:bg-gray-900/50 backdrop-blur-md px-6 py-2 rounded-full border border-purple-500/10 dark:border-purple-500/20 shadow-sm">
            <span className="bg-clip-text text-transparent bg-gradient-to-r from-purple-600 to-pink-600 dark:from-purple-400 dark:to-pink-400 font-bold tracking-wider">WHAT WE OFFER</span>
          </span>
        </motion.div>
        
        <motion.div 
          variants={itemVariants}
          className="bg-gradient-to-br from-white/80 to-gray-100/80 dark:from-gray-900/80 dark:to-gray-800/80 p-8 rounded-2xl backdrop-blur-md border border-purple-500/10 dark:border-purple-500/20 relative overflow-hidden"
        >
          {/* Circuit pattern background */}
          <div className="absolute inset-0 opacity-5 dark:opacity-10 pointer-events-none">
            <svg className="w-full h-full" viewBox="0 0 400 200" preserveAspectRatio="none">
              <path d="M0,100 L100,100 L120,80 L150,120 L180,120 L200,100 L220,100 L250,70 L300,130 L350,100 L400,100" stroke="#8b5cf6" fill="none" strokeWidth="1" />
              <path d="M0,50 L50,50 L70,70 L100,70" stroke="#8b5cf6" fill="none" strokeWidth="1" />
              <path d="M300,100 L320,80 L380,80 L400,80" stroke="#8b5cf6" fill="none" strokeWidth="1" />
              <circle cx="100" cy="100" r="3" fill="#8b5cf6" />
              <circle cx="200" cy="100" r="3" fill="#8b5cf6" />
              <circle cx="300" cy="100" r="3" fill="#8b5cf6" />
            </svg>
          </div>
          
          <div className="relative">
            <div className="flex items-center mb-6">
              <div className="mr-4 relative">
                <div className="absolute inset-0 bg-gradient-to-r from-purple-500/20 to-pink-500/20 dark:from-purple-500/30 dark:to-pink-500/30 rounded-full blur-md animate-pulse"></div>
                <div className="relative bg-white/20 dark:bg-gray-900/50 p-3 rounded-full border border-purple-500/30">
                  <FaCode className="text-purple-500 dark:text-purple-400" size={24} />
                </div>
              </div>
              <h2 className="text-3xl font-bold mb-0 bg-gradient-to-r from-purple-600 to-pink-600 dark:from-purple-400 dark:to-pink-400 bg-clip-text text-transparent relative">
                Comprehensive Learning Experience
                <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-purple-400/20 dark:via-purple-400/30 to-transparent"></div>
              </h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mt-8">
              <div className="bg-white/50 dark:bg-gray-800/50 p-6 rounded-xl border border-purple-500/10 dark:border-purple-500/20 relative group">
                <div className="absolute top-0 right-0 w-16 h-16 opacity-10 dark:opacity-20">
                  <svg viewBox="0 0 100 100">
                    <circle cx="50" cy="50" r="40" stroke="#8b5cf6" strokeWidth="2" fill="none" />
                    <circle cx="50" cy="50" r="20" stroke="#8b5cf6" strokeWidth="2" fill="none" />
                    <line x1="50" y1="10" x2="50" y2="30" stroke="#8b5cf6" strokeWidth="2" />
                    <line x1="50" y1="70" x2="50" y2="90" stroke="#8b5cf6" strokeWidth="2" />
                    <line x1="10" y1="50" x2="30" y2="50" stroke="#8b5cf6" strokeWidth="2" />
                    <line x1="70" y1="50" x2="90" y2="50" stroke="#8b5cf6" strokeWidth="2" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold text-purple-600 dark:text-purple-400 mb-3">Interactive Courses</h3>
                <p className="text-gray-600 dark:text-gray-300">Engage with our interactive courses designed to make learning programming intuitive and enjoyable. Each course includes hands-on projects and real-world applications.</p>
              </div>
              
              <div className="bg-white/50 dark:bg-gray-800/50 p-6 rounded-xl border border-purple-500/10 dark:border-purple-500/20 relative group">
                <div className="absolute top-0 right-0 w-16 h-16 opacity-10 dark:opacity-20">
                  <svg viewBox="0 0 100 100">
                    <rect x="20" y="20" width="60" height="60" rx="5" stroke="#8b5cf6" strokeWidth="2" fill="none" />
                    <line x1="20" y1="40" x2="80" y2="40" stroke="#8b5cf6" strokeWidth="2" />
                    <circle cx="30" cy="30" r="5" fill="#8b5cf6" />
                    <circle cx="50" cy="30" r="5" fill="#8b5cf6" />
                    <circle cx="70" cy="30" r="5" fill="#8b5cf6" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold text-purple-600 dark:text-purple-400 mb-3">Expert Mentorship</h3>
                <p className="text-gray-600 dark:text-gray-300">Receive guidance from industry professionals who provide personalized feedback on your projects and help you navigate your learning journey.</p>
              </div>
              
              <div className="bg-white/50 dark:bg-gray-800/50 p-6 rounded-xl border border-purple-500/10 dark:border-purple-500/20 relative group">
                <div className="absolute top-0 right-0 w-16 h-16 opacity-10 dark:opacity-20">
                  <svg viewBox="0 0 100 100">
                    <path d="M20,50 Q50,20 80,50 Q50,80 20,50" stroke="#8b5cf6" strokeWidth="2" fill="none" />
                    <circle cx="50" cy="50" r="10" stroke="#8b5cf6" strokeWidth="2" fill="none" />
                    <circle cx="50" cy="50" r="30" stroke="#8b5cf6" strokeWidth="2" fill="none" strokeDasharray="5,5" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold text-purple-600 dark:text-purple-400 mb-3">Community Support</h3>
                <p className="text-gray-600 dark:text-gray-300">Join our thriving community of learners where you can collaborate on projects, participate in code reviews, and build your professional network.</p>
              </div>
              
              <div className="bg-white/50 dark:bg-gray-800/50 p-6 rounded-xl border border-purple-500/10 dark:border-purple-500/20 relative group">
                <div className="absolute top-0 right-0 w-16 h-16 opacity-10 dark:opacity-20">
                  <svg viewBox="0 0 100 100">
                    <polygon points="50,20 80,40 80,80 20,80 20,40" stroke="#8b5cf6" strokeWidth="2" fill="none" />
                    <line x1="50" y1="20" x2="50" y2="80" stroke="#8b5cf6" strokeWidth="2" />
                    <line x1="20" y1="60" x2="80" y2="60" stroke="#8b5cf6" strokeWidth="2" />
                  </svg>
                </div>
                <h3 className="text-xl font-semibold text-purple-600 dark:text-purple-400 mb-3">Career Resources</h3>
                <p className="text-gray-600 dark:text-gray-300">Access our extensive library of career resources, including resume reviews, interview preparation, and job placement assistance to help you land your dream role.</p>
              </div>
            </div>
            
            <div className="mt-8 text-center">
              <p className="text-gray-600 dark:text-gray-300 text-lg italic">
                "From comprehensive video tutorials to hands-on projects, we provide the tools and resources you need to master programming. Our supportive community ensures you're never alone on your journey."
              </p>
            </div>
          </div>
        </motion.div>
      </motion.div>
      
      {/* Features Section with AI-inspired design */}
      <motion.div className="w-[95%] 800px:w-[85%] mx-auto mb-20 relative z-10">
        <motion.div 
          variants={itemVariants}
          className="relative mb-12 text-center"
        >
          <div className="absolute top-1/2 left-0 right-0 h-px bg-gradient-to-r from-transparent via-blue-500/20 dark:via-blue-500/30 to-transparent"></div>
          <span className="relative inline-block bg-white/50 dark:bg-gray-900/50 backdrop-blur-md px-6 py-2 rounded-full border border-blue-500/10 dark:border-blue-500/20 shadow-sm">
            <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400 font-bold tracking-wider">PLATFORM FEATURES</span>
          </span>
        </motion.div>
        
        {/* Feature Cards */}
        <motion.div variants={itemVariants} className="grid grid-cols-1 lg:grid-cols-2 gap-12 w-full mb-12">
          {/* Left Column */}
          <div className="space-y-8 w-full">
            {/* Our Mission Card */}
            <motion.div 
              variants={itemVariants}
              whileHover={{ y: -5, boxShadow: "0 10px 25px -5px rgba(59, 130, 246, 0.1)" }}
              className="bg-gradient-to-r from-blue-500/10 to-purple-500/10 dark:from-blue-500/5 dark:to-purple-500/5 p-8 rounded-2xl backdrop-blur-sm border border-blue-500/20 dark:border-blue-500/10 relative overflow-hidden group"
            >
              {/* Animated scanner effect */}
              <div className="absolute inset-0 overflow-hidden">
                <motion.div 
                  initial={{ top: '-100%' }}
                  animate={{ top: '100%' }}
                  transition={{ duration: 2, repeat: Infinity, repeatType: 'loop', ease: 'linear', repeatDelay: 1 }}
                  className="absolute left-0 right-0 h-[1px] bg-gradient-to-r from-transparent via-blue-400/40 dark:via-blue-400/50 to-transparent"
                />
              </div>
              
              {/* Hexagonal pattern background */}
              <div className="absolute inset-0 opacity-5 dark:opacity-10 pointer-events-none">
                <svg className="w-full h-full" preserveAspectRatio="none">
                  <pattern id="hexagrid1" width="20" height="20" patternUnits="userSpaceOnUse" patternTransform="rotate(30)">
                    <path d="M10,0 L20,5 L20,15 L10,20 L0,15 L0,5 Z" fill="none" stroke="#3b82f6" strokeWidth="0.5" />
                  </pattern>
                  <rect width="100%" height="100%" fill="url(#hexagrid1)" />
                </svg>
              </div>
              
              <div className="relative">
                <div className="flex items-center mb-4">
                  <div className="mr-3 relative">
                    <div className="absolute inset-0 bg-gradient-to-r from-blue-500/20 to-purple-500/20 dark:from-blue-500/30 dark:to-purple-500/30 rounded-full blur-md animate-pulse"></div>
                    <div className="relative bg-white/20 dark:bg-gray-900/50 p-2 rounded-full border border-blue-500/30">
                      <FaRocket className="text-blue-500 dark:text-blue-400" size={18} />
                    </div>
                  </div>
                  <h2 className="text-2xl font-bold mb-0 bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400 bg-clip-text text-transparent relative">
                    Our Mission
                    <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-blue-400/20 dark:via-blue-400/30 to-transparent"></div>
                  </h2>
                </div>
                <p className="text-gray-600 dark:text-gray-300 leading-relaxed pl-2 border-l-2 border-blue-500/30">
                  We're dedicated to making programming education accessible to everyone. Our platform combines affordability with quality, ensuring that financial constraints never limit your learning potential.
                </p>
              </div>
              
              {/* Decorative corner element */}
              <div className="absolute -bottom-2 -right-2 w-12 h-12 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <div className="absolute inset-0 bg-gradient-to-r from-blue-500/20 to-purple-500/20 dark:from-blue-500/30 dark:to-purple-500/30 rounded-full blur-xl"></div>
              </div>
            </motion.div>

            <motion.div 
              variants={itemVariants}
              whileHover={{ y: -5, boxShadow: "0 10px 25px -5px rgba(139, 92, 246, 0.1)" }}
              className="bg-gradient-to-r from-purple-500/10 to-pink-500/10 dark:from-purple-500/5 dark:to-pink-500/5 p-8 rounded-2xl backdrop-blur-sm border border-purple-500/20 dark:border-purple-500/10 relative overflow-hidden group"
            >
              {/* Circuit pattern background */}
              <div className="absolute inset-0 opacity-5 dark:opacity-10 pointer-events-none">
                <svg className="w-full h-full" viewBox="0 0 400 200" preserveAspectRatio="none">
                  <path d="M0,100 L100,100 L120,80 L150,120 L180,120 L200,100 L220,100 L250,70 L300,130 L350,100 L400,100" stroke="#8b5cf6" fill="none" strokeWidth="1" />
                  <path d="M0,50 L50,50 L70,70 L100,70" stroke="#8b5cf6" fill="none" strokeWidth="1" />
                  <path d="M300,100 L320,80 L380,80 L400,80" stroke="#8b5cf6" fill="none" strokeWidth="1" />
                  <circle cx="100" cy="100" r="3" fill="#8b5cf6" />
                  <circle cx="200" cy="100" r="3" fill="#8b5cf6" />
                  <circle cx="300" cy="100" r="3" fill="#8b5cf6" />
                </svg>
              </div>
              
              <div className="relative">
                <div className="flex items-center mb-4">
                  <div className="mr-3 relative">
                    <div className="absolute inset-0 bg-gradient-to-r from-purple-500/20 to-pink-500/20 dark:from-purple-500/30 dark:to-pink-500/30 rounded-full blur-md animate-pulse"></div>
                    <div className="relative bg-white/20 dark:bg-gray-900/50 p-2 rounded-full border border-purple-500/30">
                      <FaCode className="text-purple-500 dark:text-purple-400" size={18} />
                    </div>
                  </div>
                  <h2 className="text-2xl font-bold mb-0 bg-gradient-to-r from-purple-600 to-pink-600 dark:from-purple-400 dark:to-pink-400 bg-clip-text text-transparent relative">
                    What We Offer
                    <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-purple-400/20 dark:via-purple-400/30 to-transparent"></div>
                  </h2>
                </div>
                <p className="text-gray-600 dark:text-gray-300 leading-relaxed pl-2 border-l-2 border-purple-500/30">
                  From comprehensive video tutorials to hands-on projects, we provide the tools and resources you need to master programming. Our supportive community ensures you're never alone on your journey.
                </p>
              </div>
              
              {/* Decorative corner element */}
              <div className="absolute -bottom-2 -right-2 w-12 h-12 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <div className="absolute inset-0 bg-gradient-to-r from-purple-500/20 to-pink-500/20 dark:from-purple-500/30 dark:to-pink-500/30 rounded-full blur-xl"></div>
              </div>
            </motion.div>
          </div>

          {/* Right Column */}
          <div className="space-y-8 w-full">
            <motion.div 
              variants={itemVariants}
              whileHover={{ y: -5, boxShadow: "0 10px 25px -5px rgba(236, 72, 153, 0.1)" }}
              className="bg-gradient-to-r from-pink-500/10 to-orange-500/10 dark:from-pink-500/5 dark:to-orange-500/5 p-8 rounded-2xl backdrop-blur-sm border border-pink-500/20 dark:border-pink-500/10 relative overflow-hidden group"
            >
              {/* Dot grid pattern background */}
              <div className="absolute inset-0 opacity-5 dark:opacity-10 pointer-events-none">
                <svg className="w-full h-full" preserveAspectRatio="none">
                  <pattern id="dotgrid" width="20" height="20" patternUnits="userSpaceOnUse">
                    <circle cx="10" cy="10" r="1" fill="#ec4899" />
                  </pattern>
                  <rect width="100%" height="100%" fill="url(#dotgrid)" />
                </svg>
              </div>
              
              <div className="relative">
                <div className="flex items-center mb-4">
                  <div className="mr-3 relative">
                    <div className="absolute inset-0 bg-gradient-to-r from-pink-500/20 to-orange-500/20 dark:from-pink-500/30 dark:to-orange-500/30 rounded-full blur-md animate-pulse"></div>
                    <div className="relative bg-white/20 dark:bg-gray-900/50 p-2 rounded-full border border-pink-500/30">
                      <FaUsers className="text-pink-500 dark:text-pink-400" size={18} />
                    </div>
                  </div>
                  <h2 className="text-2xl font-bold mb-0 bg-gradient-to-r from-pink-600 to-orange-600 dark:from-pink-400 dark:to-orange-400 bg-clip-text text-transparent relative">
                    Our Community
                    <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-pink-400/20 dark:via-pink-400/30 to-transparent"></div>
                  </h2>
                </div>
                <p className="text-gray-600 dark:text-gray-300 leading-relaxed pl-2 border-l-2 border-pink-500/30">
                  Join a thriving community of learners and mentors. Share knowledge, collaborate on projects, and grow together in a supportive environment that celebrates every achievement.
                </p>
              </div>
              
              {/* Decorative corner element */}
              <div className="absolute -bottom-2 -right-2 w-12 h-12 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <div className="absolute inset-0 bg-gradient-to-r from-pink-500/20 to-orange-500/20 dark:from-pink-500/30 dark:to-orange-500/30 rounded-full blur-xl"></div>
              </div>
            </motion.div>

            <motion.div 
              variants={itemVariants}
              whileHover={{ y: -5, boxShadow: "0 10px 25px -5px rgba(249, 115, 22, 0.1)" }}
              className="bg-gradient-to-r from-orange-500/10 to-yellow-500/10 dark:from-orange-500/5 dark:to-yellow-500/5 p-8 rounded-2xl backdrop-blur-sm border border-orange-500/20 dark:border-orange-500/10 relative overflow-hidden group"
            >
              {/* Wave pattern background */}
              <div className="absolute inset-0 opacity-5 dark:opacity-10 pointer-events-none">
                <svg className="w-full h-full" preserveAspectRatio="none" viewBox="0 0 400 200">
                  <path d="M0,100 C50,80 100,120 150,100 C200,80 250,120 300,100 C350,80 400,120 450,100" stroke="#f97316" fill="none" strokeWidth="1" />
                  <path d="M0,50 C50,30 100,70 150,50 C200,30 250,70 300,50 C350,30 400,70 450,50" stroke="#f97316" fill="none" strokeWidth="1" />
                  <path d="M0,150 C50,130 100,170 150,150 C200,130 250,170 300,150 C350,130 400,170 450,150" stroke="#f97316" fill="none" strokeWidth="1" />
                </svg>
              </div>
              
              <div className="relative">
                <div className="flex items-center mb-4">
                  <div className="mr-3 relative">
                    <div className="absolute inset-0 bg-gradient-to-r from-orange-500/20 to-yellow-500/20 dark:from-orange-500/30 dark:to-yellow-500/30 rounded-full blur-md animate-pulse"></div>
                    <div className="relative bg-white/20 dark:bg-gray-900/50 p-2 rounded-full border border-orange-500/30">
                      <FaAward className="text-orange-500 dark:text-orange-400" size={18} />
                    </div>
                  </div>
                  <h2 className="text-2xl font-bold mb-0 bg-gradient-to-r from-orange-600 to-yellow-600 dark:from-orange-400 dark:to-yellow-400 bg-clip-text text-transparent relative">
                    Your Success
                    <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-orange-400/20 dark:via-orange-400/30 to-transparent"></div>
                  </h2>
                </div>
                <p className="text-gray-600 dark:text-gray-300 leading-relaxed pl-2 border-l-2 border-orange-500/30">
                  Your success is our priority. With Becodemy, you'll gain the skills, confidence, and support needed to achieve your programming goals and land your dream job.
                </p>
              </div>
              
              {/* Decorative corner element */}
              <div className="absolute -bottom-2 -right-2 w-12 h-12 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <div className="absolute inset-0 bg-gradient-to-r from-orange-500/20 to-yellow-500/20 dark:from-orange-500/30 dark:to-yellow-500/30 rounded-full blur-xl"></div>
              </div>
            </motion.div>
          </div>
        </motion.div>
      </motion.div>

      {/* Team Section with AI-inspired design */}
      <motion.div variants={itemVariants} className="w-[95%] 800px:w-[85%] mx-auto relative z-10">
        <motion.div 
          variants={itemVariants}
          className="relative mb-16 text-center"
        >
          <div className="absolute top-1/2 left-0 right-0 h-px bg-gradient-to-r from-transparent via-purple-500/20 dark:via-purple-400/30 to-transparent"></div>
          <span className="relative inline-block bg-white/50 dark:bg-gray-900/50 backdrop-blur-md px-6 py-2 rounded-full border border-purple-500/10 dark:border-purple-500/20 shadow-sm dark:shadow-purple-500/10">
            <span className="bg-clip-text text-transparent bg-gradient-to-r from-purple-600 to-blue-600 dark:from-purple-400 dark:to-blue-400 font-bold tracking-wider">TEAM OF INNOVATORS</span>
          </span>
        </motion.div>
        
        <div className="relative">
          {/* Decorative elements */}
          <div className="absolute -top-20 left-1/2 transform -translate-x-1/2 w-1 h-40 bg-gradient-to-b from-purple-500/20 dark:from-purple-500/30 to-transparent rounded-full blur-sm"></div>
          <div className="absolute -bottom-20 left-1/2 transform -translate-x-1/2 w-1 h-40 bg-gradient-to-t from-blue-500/20 dark:from-blue-500/30 to-transparent rounded-full blur-sm"></div>
        </div>
        
        <motion.h2 
          variants={itemVariants}
          className={`${styles.title} text-center mb-12 relative inline-block w-full`}
        >
          <span className="relative">
            Meet Our <span className="text-gradient">Team</span>
            <motion.span 
              className="absolute -bottom-2 left-0 right-0 h-1.5 bg-gradient-to-r from-transparent via-purple-500/30 dark:via-purple-500/40 to-transparent rounded-full blur-sm"
              initial={{ width: 0, left: '50%' }}
              animate={{ width: '100%', left: '0%' }}
              transition={{ duration: 1, delay: 0.5 }}
            />
          </span>
        </motion.h2>
        
        <motion.div 
          variants={containerVariants}
          className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8"
        >
          {teamMembers.map((member) => (
            <motion.div
              key={member.id}
              variants={itemVariants}
              whileHover={{ y: -8, scale: 1.02 }}
              className="bg-gradient-to-br from-white/90 to-gray-100/90 dark:from-slate-900/90 dark:to-slate-800/90 rounded-xl backdrop-blur-md border border-gray-200/50 dark:border-purple-500/10 overflow-hidden relative group shadow-md dark:shadow-lg"
            >
              {/* Hexagonal pattern background */}
              <div className="absolute inset-0 opacity-5 dark:opacity-10 pointer-events-none">
                <svg className="w-full h-full" preserveAspectRatio="none">
                  <pattern id="hexagrid-team" width="20" height="20" patternUnits="userSpaceOnUse" patternTransform="rotate(30)">
                    <path d="M10,0 L20,5 L20,15 L10,20 L0,15 L0,5 Z" fill="none" stroke="#8b5cf6" strokeWidth="0.5" />
                  </pattern>
                  <rect width="100%" height="100%" fill="url(#hexagrid-team)" />
                </svg>
              </div>
              
              {/* Top border glow */}
              <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-blue-500/0 via-purple-500/30 dark:via-purple-500/50 to-blue-500/0"></div>
              
              <div className="p-6 relative">
                <div className="text-center">
                  {/* Image container with futuristic design */}
                  <div className="relative mx-auto w-28 h-28 mb-6">
                    {/* Animated ring */}
                    <motion.div 
                      animate={{ rotate: 360 }}
                      transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
                      className="absolute inset-0 rounded-full border-2 border-dashed border-purple-500/20 dark:border-purple-500/30"
                    ></motion.div>
                    
                    {/* Outer glow */}
                    <div className="absolute -inset-1 bg-gradient-to-r from-blue-500/5 to-purple-500/5 dark:from-blue-500/10 dark:to-purple-500/10 rounded-full blur-md"></div>
                    
                    {/* Image wrapper */}
                    <div className="absolute inset-0 rounded-full p-[2px] bg-gradient-to-r from-blue-500 via-purple-500 to-blue-500 overflow-hidden">
                      <div className="rounded-full p-1 bg-white dark:bg-gray-900 h-full w-full">
                        <img
                          src={member.image}
                          alt={member.name}
                          onError={(e: React.SyntheticEvent<HTMLImageElement, Event>) => {
                            const target = e.currentTarget;
                            target.src = '/assests/avatar.png';
                          }}
                          className="w-full h-full rounded-full object-cover"
                        />
                      </div>
                    </div>
                    
                    {/* Scanner effect */}
                    <div className="absolute inset-0 overflow-hidden rounded-full pointer-events-none">
                      <motion.div 
                        initial={{ top: '-100%' }}
                        animate={{ top: '100%' }}
                        transition={{ duration: 2, repeat: Infinity, repeatType: 'loop', ease: 'linear', repeatDelay: 3 }}
                        className="absolute left-0 right-0 h-[2px] bg-gradient-to-r from-transparent via-blue-400/60 to-transparent"
                      />
                    </div>
                  </div>
                  
                  {/* Content with futuristic design */}
                  <div className="relative">
                    {/* Name with gradient underline */}
                    <h3 className="text-xl font-semibold bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400 bg-clip-text text-transparent mb-2 relative inline-block">
                      {member.name}
                      <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-gradient-to-r from-transparent via-purple-400/30 dark:via-purple-400/40 to-transparent"></div>
                    </h3>
                    
                    {/* Role with tech-inspired badge */}
                    <div className="mb-3 flex justify-center">
                      <span className="px-3 py-1 text-xs font-medium rounded-full bg-gradient-to-r from-blue-50 to-purple-50 dark:from-blue-900/20 dark:to-purple-900/20 border border-blue-200/50 dark:border-purple-500/30 text-blue-600 dark:text-purple-300 shadow-sm">
                        {member.role}
                      </span>
                    </div>
                    
                    {/* Bio with side accent */}
                    <div className="relative mb-5">
                      <div className="absolute left-0 top-0 bottom-0 w-1 bg-gradient-to-b from-blue-500/30 to-purple-500/30 dark:from-blue-500/40 dark:to-purple-500/40 rounded-full opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                      <p className="text-gray-600 dark:text-gray-300 text-sm pl-3 leading-relaxed">{member.bio}</p>
                    </div>
                    
                    {/* Social links with hover effects */}
                    <div className="flex justify-center space-x-4">
                      <a
                        href={member.github}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="relative p-2 rounded-full bg-gradient-to-r from-gray-50 to-gray-100 dark:from-gray-800/60 dark:to-gray-800/80 border border-gray-200/70 dark:border-gray-700/50 hover:border-blue-500/50 transition-all duration-300 group shadow-sm"
                      >
                        <div className="absolute inset-0 bg-gradient-to-r from-blue-500/0 to-blue-500/0 group-hover:from-blue-500/10 group-hover:to-purple-500/10 dark:group-hover:from-blue-500/20 dark:group-hover:to-purple-500/20 rounded-full blur-md transition-all duration-300"></div>
                        <FaGithub className="w-5 h-5 text-gray-600 dark:text-gray-300 group-hover:text-blue-600 dark:group-hover:text-blue-400 relative z-10" />
                      </a>
                      <a
                        href={member.linkedin}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="relative p-2 rounded-full bg-gradient-to-r from-gray-50 to-gray-100 dark:from-gray-800/60 dark:to-gray-800/80 border border-gray-200/70 dark:border-gray-700/50 hover:border-blue-500/50 transition-all duration-300 group shadow-sm"
                      >
                        <div className="absolute inset-0 bg-gradient-to-r from-blue-500/0 to-blue-500/0 group-hover:from-blue-500/10 group-hover:to-purple-500/10 dark:group-hover:from-blue-500/20 dark:group-hover:to-purple-500/20 rounded-full blur-md transition-all duration-300"></div>
                        <FaLinkedin className="w-5 h-5 text-gray-600 dark:text-gray-300 group-hover:text-blue-600 dark:group-hover:text-blue-400 relative z-10" />
                      </a>
                    </div>
                  </div>
                </div>
              </div>
              
              {/* Bottom accent line */}
              <div className="absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r from-blue-500/0 via-blue-500/20 dark:via-blue-500/30 to-blue-500/0 transform scale-x-0 group-hover:scale-x-100 transition-transform duration-500 ease-out"></div>
            </motion.div>
          ))}
        </motion.div>
      </motion.div>
    </motion.div>
  );
};

export default About;

import Image from "next/image";
import { styles } from "../../../app/styles/style";
import React, { FC, useEffect, useState, useRef } from "react";
import { AiOutlineCamera } from "react-icons/ai";
import { FiEdit, FiUser, FiMail, FiCheck, FiShield } from "react-icons/fi";
import { HiOutlineSparkles, HiCube } from "react-icons/hi";
import { RiRobotLine, RiAtLine } from "react-icons/ri";
import avatarIcon from "../../../public/assests/avatar.png";
import {
  useEditProfileMutation,
  useUpdateAvatarMutation,
} from "@/redux/features/user/userApi";
import { useLoadUserQuery } from "@/redux/features/api/apiSlice";
import { toast } from "react-hot-toast";
import { motion, AnimatePresence, useAnimation, useInView } from "framer-motion";

// Define types for AI components
type AIComponentProps = {
  className?: string;
  [key: string]: any;
};

type AICircleProps = AIComponentProps & {
  size?: 'sm' | 'md' | 'lg';
};

// AI-inspired shape component
const AIShape: FC<AIComponentProps> = ({ className = "", ...props }) => {
  return (
    <div className={`absolute pointer-events-none ${className}`} {...props}>
      <div className="relative">
        <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 dark:from-cyan-500/20 dark:to-teal-500/20 rounded-lg blur-xl transform animate-pulse"></div>
        <div className="h-12 w-12 rounded-lg border border-teal-300/30 dark:border-teal-500/30 backdrop-blur-sm rotate-45 animate-float"></div>
      </div>
    </div>
  );
};

// AI-inspired circle component
const AICircle: FC<AICircleProps> = ({ className = "", size = "md", ...props }) => {
  const sizes = {
    sm: "h-4 w-4",
    md: "h-8 w-8",
    lg: "h-16 w-16",
  };
  
  return (
    <div className={`absolute pointer-events-none ${className}`} {...props}>
      <div className="relative">
        <div className={`${sizes[size]} rounded-full border border-cyan-300/30 dark:border-cyan-500/30 backdrop-blur-sm animate-float-slow`}></div>
        <div className={`absolute inset-0 bg-gradient-to-r from-teal-500/5 to-cyan-500/5 dark:from-teal-500/10 dark:to-cyan-500/10 rounded-full blur-md`}></div>
      </div>
    </div>
  );
};

// AI-inspired hexagon component
const AIHexagon: FC<AIComponentProps> = ({ className = "", ...props }) => {
  return (
    <div className={`absolute pointer-events-none ${className}`} {...props}>
      <div className="relative">
        <div className="absolute inset-0 bg-gradient-to-r from-teal-500/10 to-cyan-500/10 dark:from-teal-500/20 dark:to-cyan-500/20 blur-xl transform animate-pulse-slow"></div>
        <div className="h-10 w-10 clip-path-hexagon border border-teal-300/30 dark:border-teal-500/30 backdrop-blur-sm animate-float"></div>
      </div>
    </div>
  );
};


type Props = {
  avatar: string | null;
  user: any;
};

const ProfileInfo: FC<Props> = ({ avatar, user }) => {
  const [name, setName] = useState(user && user.name);
  const [updateAvatar, { isSuccess, error }] = useUpdateAvatarMutation();
  const [editProfile, { isSuccess: success, error: updateError }] =
    useEditProfileMutation();
  const [loadUser, setLoadUser] = useState(false);
  const {} = useLoadUserQuery(undefined, { skip: loadUser ? false : true });

  const imageHandler = async (e: any) => {
    const fileReader = new FileReader();

    fileReader.onload = () => {
      if (fileReader.readyState === 2) {
        const avatar = fileReader.result;
        updateAvatar(avatar);
      }
    };
    fileReader.readAsDataURL(e.target.files[0]);
  };

  useEffect(() => {
    if (isSuccess) {
      setLoadUser(true);
      toast.success("Profile picture updated successfully!", {
        style: {
          borderRadius: '10px',
          background: '#1e293b',
          color: '#fff',
          border: '1px solid rgba(56, 189, 248, 0.2)'
        },
        iconTheme: {
          primary: '#2dd4bf',
          secondary: '#1e293b',
        },
      });
    }
    if (error || updateError) {
      console.log(error);
      toast.error("Something went wrong. Please try again.", {
        style: {
          borderRadius: '10px',
          background: '#1e293b',
          color: '#fff',
          border: '1px solid rgba(239, 68, 68, 0.2)'
        },
      });
    }
    if(success){
      toast.success("Profile updated successfully!", {
        style: {
          borderRadius: '10px',
          background: '#1e293b',
          color: '#fff',
          border: '1px solid rgba(56, 189, 248, 0.2)'
        },
        iconTheme: {
          primary: '#2dd4bf',
          secondary: '#1e293b',
        },
      });
      setLoadUser(true);
      setIsUpdating(false);
    }
  }, [isSuccess, error, success, updateError]);

  const handleSubmit = async (e: any) => {
    e.preventDefault();
    if (name !== "") {
      await editProfile({
        name: name,
      });
    }
  };

  const [isUpdating, setIsUpdating] = useState(false);
  
  const containerVariants = {
    hidden: { opacity: 0 },
    visible: { 
      opacity: 1,
      transition: { 
        staggerChildren: 0.1,
        delayChildren: 0.2
      }
    }
  };
  
  const itemVariants = {
    hidden: { y: 20, opacity: 0 },
    visible: { y: 0, opacity: 1 }
  };

  // Define animation variants for AI elements
  const floatAnimation = {
    hidden: { opacity: 0, y: 10 },
    visible: { 
      opacity: 1, 
      y: [0, -10, 0],
      transition: {
        y: {
          repeat: Infinity,
          duration: 3,
          ease: "easeInOut"
        }
      }
    }
  };

  // Reference for animation on scroll
  const containerRef = useRef(null);
  const isInView = useInView(containerRef, { once: false, amount: 0.3 });
  const controls = useAnimation();

  useEffect(() => {
    if (isInView) {
      controls.start("visible");
    }
  }, [isInView, controls]);

  return (
    <>
      <motion.div 
        ref={containerRef}
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, ease: "easeOut" }}
        className="w-full max-w-4xl mx-auto bg-white/90 dark:bg-gradient-to-br dark:from-slate-900/95 dark:via-slate-800/90 dark:to-slate-900/95 p-10 rounded-3xl backdrop-blur-md shadow-lg dark:shadow-2xl border border-gray-200/70 dark:border-slate-700/30 relative overflow-hidden text-gray-800 dark:text-white"
      >
        {/* AI-inspired decorative elements */}
        <div className="absolute top-0 left-0 w-full h-full overflow-hidden rounded-3xl pointer-events-none">
          {/* Glowing orbs */}
          <div className="absolute -top-24 -left-24 w-48 h-48 bg-cyan-500/5 dark:bg-cyan-500/10 rounded-full blur-3xl"></div>
          <div className="absolute -bottom-24 -right-24 w-48 h-48 bg-teal-500/5 dark:bg-teal-500/10 rounded-full blur-3xl"></div>
          
          {/* Neural network-like connections */}
          <div className="absolute top-0 left-0 w-full h-full">
            <svg className="w-full h-full opacity-10" viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
              <path d="M50,250 Q200,150 350,250 T650,250" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
              <path d="M50,350 Q200,450 350,350 T650,350" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
              <path d="M200,50 Q300,200 200,350 T200,550" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
              <path d="M400,50 Q500,200 400,350 T400,550" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
              <path d="M600,50 Q700,200 600,350 T600,550" stroke="url(#gradient1)" fill="none" strokeWidth="1" />
              <defs>
                <linearGradient id="gradient1" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" stopColor="#2dd4bf" stopOpacity="0.3" />
                  <stop offset="100%" stopColor="#0ea5e9" stopOpacity="0.3" />
                </linearGradient>
              </defs>
            </svg>
          </div>
          
          {/* AI Shapes */}
          <motion.div
            variants={floatAnimation}
            initial="hidden"
            animate="visible"
          >
            <AIShape className="top-10 right-10" />
            <AIShape className="bottom-20 left-10 rotate-12" />
            <AICircle className="top-1/3 left-20" size="sm" />
            <AICircle className="bottom-1/4 right-1/4" size="lg" />
            <AIHexagon className="top-1/4 right-1/3" />
          </motion.div>
        </div>
        
        <motion.div 
          variants={containerVariants}
          initial="hidden"
          animate="visible"
          className="relative z-10"
        >
          {/* Profile header with AI icon */}
          <motion.div variants={itemVariants} className="flex items-center justify-center mb-8 relative">
            <div className="absolute -top-6 left-1/2 transform -translate-x-1/2 w-40 h-1 bg-gradient-to-r from-transparent via-cyan-500/30 to-transparent rounded-full blur-sm"></div>
            <div className="flex items-center bg-white/50 dark:bg-slate-800/50 px-5 py-2 rounded-full border border-gray-200/50 dark:border-slate-700/50 shadow-lg backdrop-blur-sm">
              <div className="mr-3 relative">
                <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 dark:from-cyan-500/20 dark:to-teal-500/20 rounded-full blur-md animate-pulse"></div>
                <div className="relative bg-white/80 dark:bg-slate-900/80 p-2 rounded-full border border-cyan-300/30 dark:border-cyan-500/30">
                  <RiRobotLine className="text-cyan-600 dark:text-cyan-400" size={22} />
                </div>
              </div>
              <h2 className="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-cyan-600 to-teal-600 dark:from-cyan-400 dark:via-teal-300 dark:to-cyan-400 tracking-wide">Your PROFILE</h2>
              <HiCube className="ml-3 text-teal-600 dark:text-teal-400 animate-float-slow" size={20} />
            </div>
          </motion.div>

          {/* Avatar section with futuristic elements */}
          <motion.div 
            variants={itemVariants}
            className="w-full flex justify-center mb-12">
            <motion.div 
              whileHover={{ scale: 1.05 }}
              className="relative">
              {/* Outer glow ring */}
              <div className="absolute -inset-4 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 rounded-full blur-xl animate-pulse-slow"></div>
              
              {/* Animated scanner effect */}
              <div className="absolute inset-0 overflow-hidden rounded-full">
                <div className="absolute inset-0 bg-gradient-to-b from-transparent via-cyan-500/10 to-transparent h-full w-full animate-scanner"></div>
              </div>
              
              {/* Main avatar container */}
              <div className="rounded-full p-[3px] bg-gradient-to-r from-cyan-400 via-teal-300 to-cyan-500 shadow-lg shadow-teal-500/20">
                {/* Hexagon pattern border */}
                <div className="rounded-full p-1 bg-slate-900/90 backdrop-blur-md relative overflow-hidden">
                  {/* Hexagonal grid pattern */}
                  <div className="absolute inset-0 opacity-20 pointer-events-none">
                    <svg className="w-full h-full" viewBox="0 0 100 100" preserveAspectRatio="none">
                      <pattern id="hexagrid" x="0" y="0" width="10" height="10" patternUnits="userSpaceOnUse">
                        <path d="M5,0 L10,5 L5,10 L0,5 Z" fill="none" stroke="#2dd4bf" strokeWidth="0.5" />
                      </pattern>
                      <rect x="0" y="0" width="100" height="100" fill="url(#hexagrid)" />
                    </svg>
                  </div>
                  
                  {/* User image */}
                  <Image
                    src={user.avatar || avatar ? user.avatar.url || avatar : avatarIcon}
                    alt="User profile"
                    width={170}
                    height={170}
                    className="w-[170px] h-[170px] cursor-pointer rounded-full object-cover"
                  />
                </div>
              </div>
              
              {/* File input for avatar upload */}
              <input
                type="file"
                name=""
                id="avatar"
                className="hidden"
                onChange={imageHandler}
                accept="image/png,image/jpg,image/jpeg,image/webp"
              />
              
              {/* Camera button with futuristic design */}
              <label htmlFor="avatar">
                <motion.div 
                  whileHover={{ scale: 1.1, boxShadow: "0 0 15px rgba(45, 212, 191, 0.5)" }}
                  whileTap={{ scale: 0.9 }}
                  className="w-[50px] h-[50px] bg-gradient-to-r from-cyan-500 to-teal-400 text-white rounded-full absolute bottom-3 right-3 flex items-center justify-center cursor-pointer shadow-lg border-2 border-slate-900/80 transition-all duration-300 overflow-hidden group">
                  {/* Animated background */}
                  <div className="absolute inset-0 bg-gradient-to-r from-cyan-400 to-teal-300 opacity-0 group-hover:opacity-100 transition-opacity duration-300 blur-sm"></div>
                  {/* Camera icon */}
                  <AiOutlineCamera size={24} className="relative z-10" />
                  {/* Pulsing ring */}
                  <div className="absolute inset-0 rounded-full border-2 border-cyan-400/30 scale-0 group-hover:scale-125 opacity-0 group-hover:opacity-100 transition-all duration-700"></div>
                </motion.div>
              </label>
              
              {/* Status indicator */}
              <div className="absolute bottom-5 left-5 w-5 h-5 rounded-full bg-teal-400 border-2 border-slate-900 shadow-lg shadow-teal-500/20 flex items-center justify-center animate-pulse">
                <div className="w-2 h-2 rounded-full bg-white"></div>
              </div>
            </motion.div>
          </motion.div>

          <div className="w-full max-w-xl mx-auto relative">
            {/* AI-inspired decorative elements for form */}
            <div className="absolute -left-6 top-1/4 w-1 h-32 bg-gradient-to-b from-cyan-500/30 to-transparent rounded-full blur-sm"></div>
            <div className="absolute -right-6 bottom-1/4 w-1 h-32 bg-gradient-to-b from-transparent to-teal-500/30 rounded-full blur-sm"></div>
            
            <form onSubmit={handleSubmit} className="space-y-10">
              {/* Name input field with AI-inspired design */}
              <motion.div variants={itemVariants} className="relative group">
                {/* Label with AI-inspired design */}
                <div className="flex items-center mb-3">
                  <div className="relative mr-2">
                    <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 dark:from-cyan-500/20 dark:to-teal-500/20 rounded-full blur-sm"></div>
                    <div className="relative bg-white/80 dark:bg-slate-800/80 p-1.5 rounded-full border border-cyan-300/30 dark:border-cyan-500/30">
                      <FiUser className="text-cyan-600 dark:text-cyan-400" size={14} />
                    </div>
                  </div>
                  <label className="text-sm font-medium text-gray-600 dark:text-gray-300 flex items-center">
                    <span className="bg-clip-text text-transparent bg-gradient-to-r from-cyan-600 to-teal-600 dark:from-cyan-300 dark:to-teal-300 tracking-wide">FULL NAME</span>
                    <div className="w-full 800px:flex items-center py-3">
                      <div className="ml-2 h-px w-10 bg-gradient-to-r from-cyan-500/30 dark:from-cyan-500/50 to-transparent"></div>
                    </div>
                  </label>
                </div>
                
                {/* Input field with futuristic design */}
                <div className="relative overflow-hidden rounded-xl">
                  {/* Animated background */}
                  <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 rounded-xl blur-md transform group-hover:translate-x-1 transition-all duration-300"></div>
                  
                  {/* Hexagonal pattern for background */}
                  <div className="absolute inset-0 opacity-5 pointer-events-none">
                    <svg className="w-full h-full" preserveAspectRatio="none">
                      <pattern id="smallgrid" width="8" height="8" patternUnits="userSpaceOnUse">
                        <path d="M 8 0 L 0 0 0 8" fill="none" stroke="#2dd4bf" strokeWidth="0.5" opacity="0.2" />
                      </pattern>
                      <rect width="100%" height="100%" fill="url(#smallgrid)" />
                    </svg>
                  </div>
                  
                  <div className="relative">
                    <input
                      type="text"
                      className="w-full bg-white/70 dark:bg-slate-800/80 border border-gray-300/50 dark:border-slate-700/50 text-gray-800 dark:text-white rounded-xl px-5 py-4 outline-none focus:ring-2 focus:ring-cyan-400/50 transition-all duration-300 pl-10"
                      required
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                    />
                    
                    {/* Animated edit icon */}
                    <div className="absolute right-4 top-1/2 transform -translate-y-1/2 group-hover:scale-110 transition-transform duration-300">
                      <div className="relative">
                        <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/20 to-teal-500/20 rounded-full blur-sm opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                        <FiEdit className="relative text-cyan-400/70 text-lg" />
                      </div>
                    </div>
                    
                    {/* Left indicator bar */}
                    <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-gradient-to-b from-cyan-400 to-teal-400 rounded-l-xl transition-all duration-300 group-hover:scale-y-110"></div>
                    
                    {/* Bottom scan line effect */}
                    <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-cyan-400/50 to-transparent transform translate-x-full group-hover:translate-x-0 transition-transform duration-1000 ease-in-out"></div>
                  </div>
                </div>
              </motion.div>

              {/* Email field with AI-inspired design */}
              <motion.div variants={itemVariants} className="relative group">
                {/* Label with AI-inspired design */}
                <div className="flex items-center mb-3">
                  <div className="relative mr-2">
                    <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 dark:from-cyan-500/20 dark:to-teal-500/20 rounded-full blur-sm"></div>
                    <div className="relative bg-white/80 dark:bg-slate-800/80 p-1.5 rounded-full border border-cyan-300/30 dark:border-cyan-500/30">
                      <FiMail className="text-cyan-600 dark:text-cyan-400" size={14} />
                    </div>
                  </div>
                  <label className="text-sm font-medium text-gray-600 dark:text-gray-300 flex items-center">
                    <span className="bg-clip-text text-transparent bg-gradient-to-r from-cyan-600 to-teal-600 dark:from-cyan-300 dark:to-teal-300 tracking-wide">EMAIL ADDRESS</span>
                    <div className="ml-2 h-px w-10 bg-gradient-to-r from-cyan-500/30 dark:from-cyan-500/50 to-transparent"></div>
                  </label>
                </div>
                
                {/* Input field with futuristic design */}
                <div className="relative overflow-hidden rounded-xl">
                  {/* Animated background */}
                  <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/5 to-teal-500/5 rounded-xl blur-md"></div>
                  
                  {/* Security pattern for background */}
                  <div className="absolute inset-0 opacity-5 pointer-events-none">
                    <svg className="w-full h-full" preserveAspectRatio="none">
                      <pattern id="securitygrid" width="20" height="20" patternUnits="userSpaceOnUse">
                        <circle cx="10" cy="10" r="1" fill="#2dd4bf" opacity="0.5" />
                        <path d="M 0 10 H 20 M 10 0 V 20" stroke="#2dd4bf" strokeWidth="0.5" opacity="0.2" strokeDasharray="2 4" />
                      </pattern>
                      <rect width="100%" height="100%" fill="url(#securitygrid)" />
                    </svg>
                  </div>
                  
                  <div className="relative">
                    <div className="absolute left-10 top-1/2 transform -translate-y-1/2 opacity-30">
                      <FiShield size={14} className="text-cyan-400" />
                    </div>
                    
                    <input
                      type="text"
                      readOnly
                      className="w-full bg-gray-100/60 dark:bg-slate-800/60 border border-gray-300/50 dark:border-slate-700/50 text-gray-500 dark:text-white/80 rounded-xl px-5 py-4 outline-none cursor-not-allowed pl-10"
                      required
                      value={user?.email}
                    />
                    
                    {/* Left indicator bar */}
                    <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-gradient-to-b from-cyan-400/50 to-teal-400/50 rounded-l-xl opacity-50"></div>
                    
                    {/* Locked indicator */}
                    <div className="absolute right-4 top-1/2 transform -translate-y-1/2 bg-slate-700/50 p-1 rounded-full">
                      <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                      </svg>
                    </div>
                  </div>
                </div>
              </motion.div>

              {/* Submit button with futuristic AI design */}
              <motion.button
                variants={itemVariants}
                type="submit"
                disabled={isUpdating}
                onClick={() => setIsUpdating(true)}
                whileHover={{ scale: 1.02, boxShadow: "0 0 25px rgba(45, 212, 191, 0.3)" }}
                whileTap={{ scale: 0.98 }}
                className="w-full py-4 px-6 bg-gradient-to-r from-cyan-500 to-teal-400 hover:from-cyan-600 hover:to-teal-500 text-white font-medium rounded-xl shadow-md dark:shadow-lg dark:shadow-teal-500/20 transition-all duration-300 relative overflow-hidden group mt-10"
              >
                {/* Button background effects */}
                <span className="absolute inset-0 w-full h-full bg-gradient-to-r from-cyan-400 to-teal-300 opacity-0 group-hover:opacity-100 transition-opacity duration-300 blur-xl"></span>
                
                {/* Hexagonal pattern overlay */}
                <div className="absolute inset-0 opacity-10 group-hover:opacity-20 transition-opacity duration-300 pointer-events-none overflow-hidden">
                  <svg className="w-full h-full" preserveAspectRatio="none">
                    <pattern id="buttonhex" width="10" height="10" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
                      <path d="M5,0 L10,5 L5,10 L0,5 Z" fill="none" stroke="#fff" strokeWidth="0.5" />
                    </pattern>
                    <rect width="100%" height="100%" fill="url(#buttonhex)" />
                  </svg>
                </div>
                
                {/* Animated scan line */}
                <span className="absolute inset-0 overflow-hidden rounded-xl">
                  <span className="absolute top-0 left-0 right-0 h-px bg-white/30 transform -translate-y-full group-hover:translate-y-full transition-transform duration-1000 ease-in-out"></span>
                </span>
                
                {/* Button content */}
                <span className="absolute inset-0 w-full h-full flex items-center justify-center">
                  <span className="flex items-center relative z-10">
                    {isUpdating ? (
                      <>
                        <svg className="animate-spin -ml-1 mr-2 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        <span className="tracking-wider">PROCESSING...</span>
                      </>
                    ) : (
                      <>
                        <span className="mr-2 relative">
                          <span className="absolute inset-0 bg-white/20 rounded-full blur-sm opacity-0 group-hover:opacity-100 transition-opacity duration-300"></span>
                          <FiCheck className="relative" />
                        </span> 
                        <span className="tracking-wider">UPDATE PROFILE</span>
                      </>
                    )}
                  </span>
                </span>
              </motion.button>
            </form>
            
            {/* Decorative bottom elements */}
            <motion.div 
              variants={itemVariants}
              className="absolute -bottom-20 left-1/2 transform -translate-x-1/2 w-40 h-1.5 bg-gradient-to-r from-transparent via-cyan-500/30 to-transparent rounded-full blur-sm mt-8">
            </motion.div>
            
            {/* AI circuit lines */}
            <div className="absolute -bottom-10 left-0 right-0 h-20 overflow-hidden pointer-events-none opacity-30">
              <svg className="w-full h-full" viewBox="0 0 400 80" preserveAspectRatio="none">
                <path d="M0,40 L80,40 L100,20 L150,60 L180,60 L200,40 L220,40 L250,10 L300,70 L320,70 L350,40 L400,40" stroke="url(#circuitgrad)" fill="none" strokeWidth="1" />
                <path d="M0,60 L40,60 L60,40 L100,40" stroke="url(#circuitgrad)" fill="none" strokeWidth="1" />
                <path d="M300,40 L320,20 L380,20 L400,20" stroke="url(#circuitgrad)" fill="none" strokeWidth="1" />
                <circle cx="100" cy="40" r="3" fill="#2dd4bf" />
                <circle cx="200" cy="40" r="3" fill="#2dd4bf" />
                <circle cx="300" cy="40" r="3" fill="#2dd4bf" />
                <defs>
                  <linearGradient id="circuitgrad" x1="0%" y1="0%" x2="100%" y2="0%">
                    <stop offset="0%" stopColor="#2dd4bf" stopOpacity="0" />
                    <stop offset="50%" stopColor="#2dd4bf" stopOpacity="1" />
                    <stop offset="100%" stopColor="#2dd4bf" stopOpacity="0" />
                  </linearGradient>
                </defs>
              </svg>
            </div>
          </div>
        </motion.div>
      </motion.div>
    </>
  );
};

export default ProfileInfo;

import { styles } from "@/app/styles/style"; // Assuming this contains necessary base styles if any
import { useUpdatePasswordMutation } from "@/redux/features/user/userApi";
import React, { FC, useEffect, useState, useRef } from "react";
import { toast } from "react-hot-toast";
import { motion, AnimatePresence, useAnimation, useInView } from "framer-motion";
import { FiLock, FiKey, FiShield, FiRefreshCw } from "react-icons/fi";
import { HiCube } from "react-icons/hi";
// Removed RiRobotLine as it wasn't used
// import { RiRobotLine } from "react-icons/ri";

// AI-inspired shape component Props
type AIComponentProps = {
  className?: string;
  [key: string]: any; // Allows for other props like animation variants
};

type AICircleProps = AIComponentProps & {
  size?: 'sm' | 'md' | 'lg';
};

// AI-inspired shape component
const AIShape: FC<AIComponentProps> = ({ className = "", ...props }) => {
  return (
    <div className={`absolute pointer-events-none ${className}`} {...props}>
      <div className="relative">
        {/* Blur Effect */}
        <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 dark:from-cyan-500/20 dark:to-teal-500/20 rounded-lg blur-xl transform animate-pulse"></div>
        {/* Main Shape */}
        <div className="h-12 w-12 rounded-lg border border-teal-300/30 dark:border-teal-500/30 backdrop-blur-sm rotate-45 animate-float bg-white/5 dark:bg-black/5"></div>
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
        {/* Main Shape */}
        <div className={`${sizes[size]} rounded-full border border-cyan-300/30 dark:border-cyan-500/30 backdrop-blur-sm animate-float-slow bg-white/5 dark:bg-black/5`}></div>
        {/* Blur Effect */}
        <div className={`absolute inset-0 bg-gradient-to-r from-teal-500/5 to-cyan-500/5 dark:from-teal-500/10 dark:to-cyan-500/10 rounded-full blur-md`}></div>
      </div>
    </div>
  );
};

// AI-inspired hexagon component
const AIHexagon: FC<AIComponentProps> = ({ className = "", ...props }) => {
  // Basic clip-path for hexagon - requires setup in tailwind.config.js or global CSS if not default
  // Add this to your global CSS or tailwind config:
  // .clip-path-hexagon { clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%); }
  return (
    <div className={`absolute pointer-events-none ${className}`} {...props}>
      <div className="relative">
        {/* Blur Effect */}
        <div className="absolute inset-0 bg-gradient-to-r from-teal-500/10 to-cyan-500/10 dark:from-teal-500/20 dark:to-cyan-500/20 blur-xl transform animate-pulse-slow"></div>
        {/* Main Shape */}
        <div className="h-10 w-10 clip-path-hexagon border border-teal-300/30 dark:border-teal-500/30 backdrop-blur-sm animate-float bg-white/5 dark:bg-black/5"></div>
      </div>
    </div>
  );
};


// Props for ChangePassword component (currently none)
type Props = {};

const ChangePassword: FC<Props> = (props) => {
  const [oldPassword, setOldPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [updatePassword, { isSuccess, error, isLoading }] = useUpdatePasswordMutation();
  const [isUpdating, setIsUpdating] = useState(false); // To manage button state during API call

  // Reference for animation on scroll
  const containerRef = useRef(null);
  const isInView = useInView(containerRef, { once: false, amount: 0.2 }); // Trigger animation when 20% is visible
  const controls = useAnimation(); // Use animation controls (though not used explicitly in this version, kept for structure)

  // Animation variants
  const containerVariants = {
    hidden: { opacity: 0, y: 30 },
    visible: {
      opacity: 1,
      y: 0,
      transition: {
        duration: 0.6,
        ease: "easeOut",
        staggerChildren: 0.1, // Stagger animation of child elements
        delayChildren: 0.2   // Delay before children start animating
      }
    }
  };

  const itemVariants = {
    hidden: { y: 20, opacity: 0 },
    visible: {
      y: 0,
      opacity: 1,
      transition: { duration: 0.5, ease: "easeOut" }
    }
  };

  // Animation variants for floating AI elements
  const floatAnimation = {
    initial: { opacity: 0, scale: 0.8, y: 10 },
    animate: {
        opacity: [0, 0.6, 0.6, 0], // Fade in, stay, fade out
        scale: 1,
        y: [10, -10, 10], // Vertical float
        transition: {
            opacity: { duration: 5, repeat: Infinity, ease: "linear" },
            y: { duration: 4, repeat: Infinity, ease: "easeInOut" },
        }
    }
  };


  // Handle password change submission
  const passwordChangeHandler = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (newPassword !== confirmPassword) {
      // Use default toast styling or provide neutral styles
      toast.error("Passwords do not match");
      return; // Prevent API call
    }
    if (!oldPassword || !newPassword) {
        toast.error("Please fill in all password fields.");
        return;
    }

    setIsUpdating(true); // Set loading state for button
    try {
        await updatePassword({ oldPassword, newPassword }).unwrap(); // Use unwrap to handle promise correctly
        // Success toast is handled by useEffect below
    } catch (err) {
         // Error toast is handled by useEffect below
        console.error("Failed to update password:", err);
    } finally {
        setIsUpdating(false); // Reset loading state regardless of outcome
    }
  };

  // Trigger animations when the component scrolls into view
  useEffect(() => {
    if (isInView) {
      controls.start("visible");
    } else {
      // Optional: Reset animation when out of view
      // controls.start("hidden");
    }
  }, [isInView, controls]);

  // Handle feedback toasts based on API call status
  useEffect(() => {
    if (isSuccess) {
      // Use default success toast or provide neutral styling
      toast.success("Password changed successfully!");
      setOldPassword("");
      setNewPassword("");
      setConfirmPassword("");
      // isUpdating is set back to false in the handler's finally block
    }
    if (error) {
      let errorMessage = "An unknown error occurred";
      if (typeof error === 'object' && error !== null && "data" in error) {
        const errorData = error.data as any;
        errorMessage = errorData?.message || "Failed to update password.";
      } else if (error instanceof Error) {
        errorMessage = error.message;
      }
      // Use default error toast or provide neutral styling
      toast.error(errorMessage);
      // isUpdating is set back to false in the handler's finally block
    }
  }, [isSuccess, error]);

  return (
    <motion.div
      ref={containerRef}
      variants={containerVariants}
      initial="hidden"
      animate={isInView ? "visible" : "hidden"} // Animate based on inView status
      className="w-full max-w-4xl mx-auto bg-white/90 dark:bg-gradient-to-br dark:from-slate-900/95 dark:via-slate-800/90 dark:to-slate-900/95 p-8 sm:p-10 rounded-3xl backdrop-blur-md shadow-lg dark:shadow-2xl border border-gray-200/70 dark:border-slate-700/30 relative overflow-hidden text-gray-800 dark:text-white"
    >
      {/* --- Background Decorative Elements --- */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden rounded-3xl pointer-events-none -z-10">
        {/* Glowing orbs */}
        <div className="absolute -top-24 -left-24 w-48 h-48 bg-cyan-500/5 dark:bg-cyan-500/10 rounded-full blur-3xl animate-pulse-slow"></div>
        <div className="absolute -bottom-24 -right-24 w-48 h-48 bg-teal-500/5 dark:bg-teal-500/10 rounded-full blur-3xl animate-pulse-slow"></div>

        {/* Neural network-like connections */}
        <div className="absolute top-0 left-0 w-full h-full">
          <svg className="w-full h-full opacity-5 dark:opacity-10" viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
            {/* Define the gradient once */}
            <defs>
              <linearGradient id="neuralGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                 <stop offset="0%" stopColor="#2dd4bf" stopOpacity="0.5" /> {/* Teal */}
                 <stop offset="100%" stopColor="#0ea5e9" stopOpacity="0.5" /> {/* Sky Blue */}
              </linearGradient>
            </defs>
            {/* Use the gradient for paths */}
            <path d="M50,250 Q200,150 350,250 T650,250" stroke="url(#neuralGrad)" fill="none" strokeWidth="1" />
            <path d="M50,350 Q200,450 350,350 T650,350" stroke="url(#neuralGrad)" fill="none" strokeWidth="1" />
            <path d="M200,50 Q300,200 200,350 T200,550" stroke="url(#neuralGrad)" fill="none" strokeWidth="1" />
            <path d="M400,50 Q500,200 400,350 T400,550" stroke="url(#neuralGrad)" fill="none" strokeWidth="1" />
            <path d="M600,50 Q700,200 600,350 T600,550" stroke="url(#neuralGrad)" fill="none" strokeWidth="1" />
          </svg>
        </div>

        {/* Floating AI Shapes */}
        <motion.div variants={floatAnimation} initial="initial" animate="animate">
          <AIShape className="top-10 right-10" style={{ animationDelay: '0s' }} />
        </motion.div>
        <motion.div variants={floatAnimation} initial="initial" animate="animate">
          <AIShape className="bottom-20 left-10 rotate-12" style={{ animationDelay: '-2s' }}/>
        </motion.div>
        <motion.div variants={floatAnimation} initial="initial" animate="animate">
           <AICircle className="top-1/3 left-20" size="sm" style={{ animationDelay: '-1s' }}/>
        </motion.div>
         <motion.div variants={floatAnimation} initial="initial" animate="animate">
           <AICircle className="bottom-1/4 right-1/4" size="lg" style={{ animationDelay: '-3s' }}/>
        </motion.div>
         <motion.div variants={floatAnimation} initial="initial" animate="animate">
           <AIHexagon className="top-1/4 right-1/3" style={{ animationDelay: '-4s' }}/>
        </motion.div>
      </div>

      {/* --- Form Content --- */}
      <div className="relative z-10">
        {/* Header with AI icon */}
        <motion.div variants={itemVariants} className="flex flex-col items-center mb-8 relative">
           {/* Top decorative line */}
           <div className="absolute -top-4 left-1/2 transform -translate-x-1/2 w-40 h-0.5 bg-gradient-to-r from-transparent via-cyan-500/30 dark:via-cyan-400/40 to-transparent rounded-full blur-sm"></div>
           {/* Main Header container */}
           <div className="flex items-center bg-white/60 dark:bg-slate-800/60 px-5 py-2 rounded-full border border-gray-200/50 dark:border-slate-700/50 shadow-md backdrop-blur-sm">
             {/* Icon Wrapper */}
             <div className="mr-3 relative">
               <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 dark:from-cyan-500/20 dark:to-teal-500/20 rounded-full blur-md animate-pulse"></div>
               <div className="relative bg-white/80 dark:bg-slate-900/80 p-2 rounded-full border border-cyan-300/30 dark:border-cyan-500/30">
                 <FiKey className="text-cyan-600 dark:text-cyan-400" size={22} />
               </div>
             </div>
             {/* Title Text */}
             <h2 className="text-xl sm:text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-cyan-600 to-teal-600 dark:from-cyan-400 dark:via-teal-300 dark:to-cyan-400 tracking-wide">SECURITY ACCESS</h2>
             {/* Cube Icon */}
             <HiCube className="ml-3 text-teal-600 dark:text-teal-400 animate-float-slow" size={20} />
           </div>
        </motion.div>

        {/* Form Wrapper */}
        <div className="w-full max-w-xl mx-auto relative">
          {/* Form decorative elements */}
          <div className="absolute -left-6 top-1/4 w-0.5 h-32 bg-gradient-to-b from-cyan-500/20 dark:from-cyan-400/30 to-transparent rounded-full blur-sm opacity-50"></div>
          <div className="absolute -right-6 bottom-1/4 w-0.5 h-32 bg-gradient-to-t from-teal-500/20 dark:from-teal-400/30 to-transparent rounded-full blur-sm opacity-50"></div>

          <form onSubmit={passwordChangeHandler} className="space-y-6 sm:space-y-8">

            {/* --- Old Password Field --- */}
            <motion.div variants={itemVariants} className="relative group">
              {/* Label */}
              <div className="flex items-center mb-2">
                <div className="relative mr-2">
                  <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 dark:from-cyan-500/20 dark:to-teal-500/20 rounded-full blur-sm"></div>
                  <div className="relative bg-white/80 dark:bg-slate-800/80 p-1.5 rounded-full border border-cyan-300/30 dark:border-cyan-500/30">
                    <FiLock className="text-cyan-600 dark:text-cyan-400" size={14} />
                  </div>
                </div>
                <label className="text-sm font-medium text-gray-600 dark:text-gray-300 flex items-center">
                  <span className="bg-clip-text text-transparent bg-gradient-to-r from-cyan-600 to-teal-600 dark:from-cyan-300 dark:to-teal-300 tracking-wide">CURRENT PASSWORD</span>
                  <div className="ml-2 h-px w-10 bg-gradient-to-r from-cyan-500/30 dark:from-cyan-500/50 to-transparent"></div>
                </label>
              </div>

              {/* Input */}
              <div className="relative overflow-hidden rounded-xl">
                {/* Animated background */}
                <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/5 to-teal-500/5 dark:from-cyan-500/10 dark:to-teal-500/10 rounded-xl blur-md transform group-hover:translate-x-1 transition-all duration-300 -z-10"></div>
                 {/* Security pattern background */}
                <div className="absolute inset-0 opacity-5 dark:opacity-[0.03] pointer-events-none -z-10">
                  <svg className="w-full h-full" preserveAspectRatio="none">
                    <pattern id="securitygrid1" width="20" height="20" patternUnits="userSpaceOnUse">
                      <circle cx="10" cy="10" r="1" className="fill-teal-400 dark:fill-teal-600" opacity="0.5" />
                      <path d="M 0 10 H 20 M 10 0 V 20" className="stroke-teal-400/50 dark:stroke-teal-600/50" strokeWidth="0.5" opacity="0.2" strokeDasharray="2 4" />
                    </pattern>
                    <rect width="100%" height="100%" fill="url(#securitygrid1)" />
                  </svg>
                </div>

                <div className="relative">
                  {/* Input Icon */}
                  <div className="absolute left-3 top-1/2 transform -translate-y-1/2 opacity-40 dark:opacity-60 pointer-events-none">
                    <FiShield size={16} className="text-cyan-600 dark:text-cyan-400" />
                  </div>
                  {/* Input Element */}
                  <input
                    type="password"
                    className="w-full bg-white/70 dark:bg-slate-800/80 border border-gray-300/50 dark:border-slate-700/50 text-gray-800 dark:text-white rounded-xl px-4 py-3 sm:px-5 sm:py-4 outline-none focus:ring-2 focus:ring-cyan-500/50 dark:focus:ring-cyan-400/60 transition-all duration-300 pl-10" // Added padding-left for icon
                    required
                    value={oldPassword}
                    onChange={(e) => setOldPassword(e.target.value)}
                    placeholder="Enter current password"
                  />
                   {/* Left indicator bar */}
                  <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-gradient-to-b from-cyan-400 to-teal-400 rounded-l-xl transition-all duration-300 scale-y-0 group-focus-within:scale-y-100 group-hover:scale-y-105 origin-center"></div>
                   {/* Bottom scan line effect */}
                  <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-cyan-400/70 dark:via-cyan-300/70 to-transparent transform translate-x-full group-focus-within:translate-x-0 transition-transform duration-700 ease-out"></div>
                </div>
              </div>
            </motion.div>

             {/* --- New Password Field --- */}
            <motion.div variants={itemVariants} className="relative group">
              {/* Label */}
              <div className="flex items-center mb-2">
                <div className="relative mr-2">
                  <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 dark:from-cyan-500/20 dark:to-teal-500/20 rounded-full blur-sm"></div>
                  <div className="relative bg-white/80 dark:bg-slate-800/80 p-1.5 rounded-full border border-cyan-300/30 dark:border-cyan-500/30">
                     <FiKey className="text-cyan-600 dark:text-cyan-400" size={14} />
                  </div>
                </div>
                <label className="text-sm font-medium text-gray-600 dark:text-gray-300 flex items-center">
                   <span className="bg-clip-text text-transparent bg-gradient-to-r from-cyan-600 to-teal-600 dark:from-cyan-300 dark:to-teal-300 tracking-wide">NEW PASSWORD</span>
                   <div className="ml-2 h-px w-10 bg-gradient-to-r from-cyan-500/30 dark:from-cyan-500/50 to-transparent"></div>
                </label>
              </div>

              {/* Input */}
               <div className="relative overflow-hidden rounded-xl">
                 {/* Animated background */}
                 <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/5 to-teal-500/5 dark:from-cyan-500/10 dark:to-teal-500/10 rounded-xl blur-md transform group-hover:translate-x-1 transition-all duration-300 -z-10"></div>
                 {/* Grid pattern background */}
                 <div className="absolute inset-0 opacity-5 dark:opacity-[0.03] pointer-events-none -z-10">
                   <svg className="w-full h-full" preserveAspectRatio="none">
                     <pattern id="smallgrid" width="8" height="8" patternUnits="userSpaceOnUse">
                       <path d="M 8 0 L 0 0 0 8" fill="none" className="stroke-teal-400/50 dark:stroke-teal-600/50" strokeWidth="0.5" opacity="0.3" />
                     </pattern>
                     <rect width="100%" height="100%" fill="url(#smallgrid)" />
                   </svg>
                 </div>

                <div className="relative">
                  {/* Input Icon */}
                   <div className="absolute left-3 top-1/2 transform -translate-y-1/2 opacity-40 dark:opacity-60 pointer-events-none">
                     <FiShield size={16} className="text-cyan-600 dark:text-cyan-400" />
                   </div>
                  {/* Input Element */}
                  <input
                    type="password"
                    className="w-full bg-white/70 dark:bg-slate-800/80 border border-gray-300/50 dark:border-slate-700/50 text-gray-800 dark:text-white rounded-xl px-4 py-3 sm:px-5 sm:py-4 outline-none focus:ring-2 focus:ring-cyan-500/50 dark:focus:ring-cyan-400/60 transition-all duration-300 pl-10" // Added padding-left for icon
                    required
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    placeholder="Enter new password"
                  />
                  {/* Left indicator bar */}
                  <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-gradient-to-b from-cyan-400 to-teal-400 rounded-l-xl transition-all duration-300 scale-y-0 group-focus-within:scale-y-100 group-hover:scale-y-105 origin-center"></div>
                   {/* Bottom scan line effect */}
                  <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-cyan-400/70 dark:via-cyan-300/70 to-transparent transform translate-x-full group-focus-within:translate-x-0 transition-transform duration-700 ease-out"></div>
                </div>
              </div>
            </motion.div>

             {/* --- Confirm Password Field --- */}
             <motion.div variants={itemVariants} className="relative group">
               {/* Label */}
               <div className="flex items-center mb-2">
                 <div className="relative mr-2">
                   <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 to-teal-500/10 dark:from-cyan-500/20 dark:to-teal-500/20 rounded-full blur-sm"></div>
                   <div className="relative bg-white/80 dark:bg-slate-800/80 p-1.5 rounded-full border border-cyan-300/30 dark:border-cyan-500/30">
                      <FiKey className="text-cyan-600 dark:text-cyan-400" size={14} />
                   </div>
                 </div>
                 <label className="text-sm font-medium text-gray-600 dark:text-gray-300 flex items-center">
                   <span className="bg-clip-text text-transparent bg-gradient-to-r from-cyan-600 to-teal-600 dark:from-cyan-300 dark:to-teal-300 tracking-wide">CONFIRM PASSWORD</span>
                   <div className="ml-2 h-px w-10 bg-gradient-to-r from-cyan-500/30 dark:from-cyan-500/50 to-transparent"></div>
                 </label>
               </div>

               {/* Input */}
               <div className="relative overflow-hidden rounded-xl">
                 {/* Animated background */}
                 <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/5 to-teal-500/5 dark:from-cyan-500/10 dark:to-teal-500/10 rounded-xl blur-md transform group-hover:translate-x-1 transition-all duration-300 -z-10"></div>
                 {/* Grid pattern background */}
                 <div className="absolute inset-0 opacity-5 dark:opacity-[0.03] pointer-events-none -z-10">
                    <svg className="w-full h-full" preserveAspectRatio="none">
                     {/* Use different ID if patterns need to be distinct */}
                     <pattern id="smallgrid2" width="8" height="8" patternUnits="userSpaceOnUse">
                        <path d="M 8 0 L 0 0 0 8" fill="none" className="stroke-teal-400/50 dark:stroke-teal-600/50" strokeWidth="0.5" opacity="0.3" />
                     </pattern>
                     <rect width="100%" height="100%" fill="url(#smallgrid2)" />
                   </svg>
                 </div>

                 <div className="relative">
                   {/* Input Icon */}
                   <div className="absolute left-3 top-1/2 transform -translate-y-1/2 opacity-40 dark:opacity-60 pointer-events-none">
                     <FiShield size={16} className="text-cyan-600 dark:text-cyan-400" />
                   </div>
                   {/* Input Element */}
                   <input
                    type="password"
                    className="w-full bg-white/70 dark:bg-slate-800/80 border border-gray-300/50 dark:border-slate-700/50 text-gray-800 dark:text-white rounded-xl px-4 py-3 sm:px-5 sm:py-4 outline-none focus:ring-2 focus:ring-cyan-500/50 dark:focus:ring-cyan-400/60 transition-all duration-300 pl-10" // Added padding-left for icon
                    required
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    placeholder="Confirm new password"
                   />
                   {/* Left indicator bar */}
                  <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-gradient-to-b from-cyan-400 to-teal-400 rounded-l-xl transition-all duration-300 scale-y-0 group-focus-within:scale-y-100 group-hover:scale-y-105 origin-center"></div>
                   {/* Bottom scan line effect */}
                  <div className="absolute bottom-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-cyan-400/70 dark:via-cyan-300/70 to-transparent transform translate-x-full group-focus-within:translate-x-0 transition-transform duration-700 ease-out"></div>
                 </div>
               </div>
             </motion.div>

            {/* --- Submit Button --- */}
            <motion.button
              variants={itemVariants}
              type="submit"
              disabled={isUpdating || isLoading} // Disable button when updating/loading
              whileHover={{ scale: 1.03, boxShadow: "0 0 25px rgba(45, 212, 191, 0.4)" }} // Teal glow on hover
              whileTap={{ scale: 0.98 }}
              className={`w-full py-4 px-6 bg-gradient-to-r from-cyan-500 to-teal-400 dark:from-cyan-600 dark:to-teal-500 text-white font-semibold rounded-xl shadow-lg shadow-teal-500/30 dark:shadow-teal-400/30 transition-all duration-300 relative overflow-hidden group mt-6 sm:mt-10 ${isUpdating || isLoading ? 'cursor-not-allowed opacity-70' : ''}`}
            >
              {/* Hover background glow */}
              <span className="absolute inset-0 w-full h-full bg-gradient-to-r from-cyan-400 to-teal-300 opacity-0 group-hover:opacity-20 transition-opacity duration-300 blur-xl -z-10"></span>

              {/* Hexagonal pattern overlay */}
              <div className="absolute inset-0 opacity-5 group-hover:opacity-10 dark:opacity-[0.08] dark:group-hover:opacity-[0.12] transition-opacity duration-300 pointer-events-none -z-10 overflow-hidden">
                <svg className="w-full h-full" preserveAspectRatio="none">
                  <pattern id="buttonhex" width="10" height="10" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
                    <path d="M5,0 L10,5 L5,10 L0,5 Z" fill="none" stroke="#fff" strokeWidth="0.5" opacity="0.5"/>
                  </pattern>
                  <rect width="100%" height="100%" fill="url(#buttonhex)" />
                </svg>
              </div>

               {/* Animated scan line on hover/focus */}
              <span className="absolute inset-0 overflow-hidden rounded-xl">
                 <span className="absolute top-0 left-0 right-0 h-px bg-white/20 transform -translate-x-full group-hover:translate-x-full transition-transform duration-1000 ease-in-out delay-300"></span>
              </span>

              {/* Button content */}
              <span className="relative z-10 flex items-center justify-center h-full">
                {isUpdating || isLoading ? (
                  <>
                    <svg className="animate-spin -ml-1 mr-2 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <span className="tracking-wider">UPDATING...</span>
                  </>
                ) : (
                  <>
                    <FiRefreshCw className="mr-2 group-hover:animate-spin-slow" />
                    <span className="tracking-wider">UPDATE PASSWORD</span>
                  </>
                )}
              </span>
            </motion.button>
          </form>

          {/* Decorative bottom elements */}
          <motion.div
             variants={itemVariants}
             className="absolute -bottom-16 left-1/2 transform -translate-x-1/2 w-48 h-1 bg-gradient-to-r from-transparent via-cyan-500/20 dark:via-cyan-400/30 to-transparent rounded-full blur-sm mt-8">
          </motion.div>

           {/* AI circuit lines at bottom */}
          <div className="absolute -bottom-8 left-0 right-0 h-20 overflow-hidden pointer-events-none opacity-20 dark:opacity-30 -z-10">
             <svg className="w-full h-full" viewBox="0 0 400 80" preserveAspectRatio="none">
                <defs>
                 <linearGradient id="circuitgrad" x1="0%" y1="0%" x2="100%" y2="0%">
                   <stop offset="0%" className="stop-color-teal-400/0 dark:stop-color-teal-500/0" />
                   <stop offset="50%" className="stop-color-teal-400 dark:stop-color-teal-500" stopOpacity="1" />
                   <stop offset="100%" className="stop-color-teal-400/0 dark:stop-color-teal-500/0" />
                 </linearGradient>
               </defs>
               <path d="M0,40 L80,40 L100,20 L150,60 L180,60 L200,40 L220,40 L250,10 L300,70 L320,70 L350,40 L400,40" stroke="url(#circuitgrad)" fill="none" strokeWidth="1" />
               <path d="M0,60 L40,60 L60,40 L100,40" stroke="url(#circuitgrad)" fill="none" strokeWidth="0.5" opacity="0.6" />
               <path d="M300,40 L320,20 L380,20 L400,20" stroke="url(#circuitgrad)" fill="none" strokeWidth="0.5" opacity="0.6" />
               <circle cx="100" cy="40" r="2" className="fill-teal-400 dark:fill-teal-300" opacity="0.8"/>
               <circle cx="200" cy="40" r="2" className="fill-teal-400 dark:fill-teal-300" opacity="0.8"/>
               <circle cx="300" cy="40" r="2" className="fill-teal-400 dark:fill-teal-300" opacity="0.8"/>
             </svg>
          </div>
        </div>
      </div>
    </motion.div>
  );
};

export default ChangePassword;

// Add necessary Tailwind animations and clip-path to your tailwind.config.js or global CSS:
/*
In tailwind.config.js:

theme: {
  extend: {
    keyframes: {
      float: {
        '0%, 100%': { transform: 'translateY(0px) rotate(45deg)' },
        '50%': { transform: 'translateY(-10px) rotate(45deg)' },
      },
      'float-slow': {
        '0%, 100%': { transform: 'translateY(0px)' },
        '50%': { transform: 'translateY(-6px)' },
      },
      'pulse-slow': {
         '0%, 100%': { opacity: '0.8' },
         '50%': { opacity: '0.4' },
      },
      'spin-slow': {
         'to': { transform: 'rotate(360deg)' },
      },
    },
    animation: {
      float: 'float 4s ease-in-out infinite',
      'float-slow': 'float-slow 5s ease-in-out infinite',
      'pulse-slow': 'pulse-slow 5s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      'spin-slow': 'spin-slow 2s linear infinite', // For button icon hover
    },
  },
},

In your global CSS (e.g., index.css or app.css):

@tailwind base;
@tailwind components;
@tailwind utilities;

@layer utilities {
  .clip-path-hexagon {
    clip-path: polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%);
  }
}

// Ensure your Tailwind config enables dark mode, usually:
// darkMode: 'class', // or 'media'
*/
import Link from "next/link";
import React from "react";
import { motion } from "framer-motion";
import { IoClose } from "react-icons/io5";

export const navItemsData = [
  {
    name: "Home",
    url: "/",
  },
  {
    name: "Courses",
    url: "/courses",
  },
  {
    name: "About",
    url: "/about",
  },
  {
    name: "Policy",
    url: "/policy",
  },
  {
    name: "FAQ",
    url: "/faq",
  },
];

type Props = {
  activeItem: number;
  isMobile: boolean;
  onClose?: () => void; // Optional function to close the mobile menu
};

const NavItems: React.FC<Props> = ({ activeItem, isMobile, onClose }) => {
  const linkVariants = {
    initial: { y: -5, opacity: 0 },
    animate: { y: 0, opacity: 1, transition: { duration: 0.3 } },
    hover: { y: -2, transition: { duration: 0.2 } },
  };

  const underlineVariants = {
    initial: { scaleX: 0, originX: 0 },
    animate: { scaleX: 1, transition: { duration: 0.3, ease: "easeOut" } },
    exit: { scaleX: 0, originX: 1, transition: { duration: 0.2 } },
  };
  
  const containerVariants = {
    hidden: { opacity: 0 },
    visible: { 
      opacity: 1,
      transition: {
        staggerChildren: 0.05,
        delayChildren: 0.1,
      }
    },
  };
  
  const itemVariants = {
    hidden: { y: 10, opacity: 0 },
    visible: { y: 0, opacity: 1 },
  };

  return (
    <>
      <motion.nav 
        className="hidden 800px:flex items-center justify-center space-x-8"
        variants={containerVariants}
        initial="hidden"
        animate="visible"
      >
        {navItemsData &&
          navItemsData.map((i, index) => (
            <motion.div
              key={index}
              variants={itemVariants}
              whileHover="hover"
              className="relative"
            >
              <Link href={`${i.url}`} passHref>
                <motion.span
                  className={`text-[17px] font-medium relative px-1 py-2 ${activeItem === index
                    ? "text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400"
                    : "text-gray-800 dark:text-gray-200 hover:text-gray-600 dark:hover:text-white"} transition-colors duration-300`}
                >
                  {i.name}
                  {activeItem === index && (
                    <motion.div
                      className="absolute -bottom-1 left-0 right-0 h-0.5 bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400"
                      initial="initial"
                      animate="animate"
                      exit="exit"
                      variants={underlineVariants}
                    />
                  )}
                </motion.span>
              </Link>
            </motion.div>
          ))}
      </motion.nav>
      {isMobile && (
        <motion.div 
          className="800px:hidden mt-5 bg-white dark:bg-[#111827] rounded-lg shadow-lg overflow-hidden"
          variants={containerVariants}
          initial="hidden"
          animate="visible"
        >
          <div className="w-full flex items-center justify-between py-5 px-6 border-b border-gray-100 dark:border-gray-800">
            <Link href={"/"} passHref>
              <span className="text-2xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400">
                ELearning
              </span>
            </Link>
            
            {/* Close button */}
            <motion.button
              onClick={onClose}
              className="p-2 rounded-full bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors duration-200"
              whileTap={{ scale: 0.9 }}
              whileHover={{ scale: 1.05 }}
              aria-label="Close menu"
            >
              <IoClose size={24} />
            </motion.button>
          </div>
          <div className="py-3">
            {navItemsData &&
              navItemsData.map((i, index) => (
                <motion.div
                  key={index}
                  variants={itemVariants}
                  className="mb-1"
                >
                  <Link href={i.url} passHref>
                    <div className="block relative">
                      <div 
                        className={`py-3 px-6 ${activeItem === index
                          ? "text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400 font-medium"
                          : "text-gray-700 dark:text-gray-300"} transition-colors duration-300`}
                      >
                        {i.name}
                      </div>
                      {activeItem === index && (
                        <motion.div 
                          className="absolute left-0 top-0 bottom-0 w-1 bg-gradient-to-b from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400"
                          initial={{ scaleY: 0 }}
                          animate={{ scaleY: 1 }}
                          transition={{ duration: 0.3 }}
                        />
                      )}
                    </div>
                  </Link>
                </motion.div>
              ))}
          </div>
        </motion.div>
      )}
    </>
  );
};

export default NavItems;

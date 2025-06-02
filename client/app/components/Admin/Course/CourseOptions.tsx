import React, {FC} from 'react';
import { IoCheckmarkSharp } from 'react-icons/io5';
import { motion } from 'framer-motion';

type Props = {
    active: number;
    setActive: (active: number) => void;
}

const CourseOptions: FC<Props> = ({ active, setActive }) => {
    const options = [
        "Course Information",
        "Course Options",
        "Course Content",
        "Course Preview",
    ];
    
    return (
      <motion.div 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.5 }}
        className="p-6 rounded-xl dark:bg-[#111827]/40 bg-gray-50/60 shadow-md"
      >
        <h2 className="text-xl font-bold dark:text-white text-gray-800 mb-6 border-b dark:border-gray-700 border-gray-200 pb-3">
          Course Creation Progress
        </h2>
        
        <div className="space-y-6">
          {options.map((option:any, index:number) => (
            <motion.div 
              key={index} 
              initial={{ x: -10, opacity: 0 }}
              animate={{ x: 0, opacity: 1 }}
              transition={{ delay: index * 0.1 }}
              className={`flex items-center ${active === index ? 'scale-105' : 'scale-100'} transition-all duration-300`}
              onClick={() => setActive(index)}
            >
              <div className="relative">
                <motion.div
                  whileHover={{ scale: 1.1 }}
                  whileTap={{ scale: 0.95 }}
                  className={`w-[40px] h-[40px] rounded-full flex items-center justify-center shadow-md ${
                    active + 1 > index 
                      ? "bg-gradient-to-r from-blue-500 to-indigo-600" 
                      : "dark:bg-gray-700 bg-gray-300"
                  }`}
                >
                  <IoCheckmarkSharp className="text-white text-xl" />
                  
                  {index !== options.length - 1 && (
                    <div
                      className={`absolute h-[40px] w-[2px] ${
                        active + 1 > index 
                          ? "bg-gradient-to-b from-blue-500 to-indigo-600" 
                          : "dark:bg-gray-700 bg-gray-300"
                      } top-[40px] left-1/2 transform -translate-x-1/2`}
                    />
                  )}
                </motion.div>
              </div>
              
              <h5 className={`ml-4 font-medium text-lg cursor-pointer ${
                active === index
                  ? "dark:text-blue-400 text-blue-600"
                  : "dark:text-gray-300 text-gray-600"
              } hover:dark:text-blue-400 hover:text-blue-600 transition-colors duration-300`}>
                {option}
              </h5>
            </motion.div>
          ))}
        </div>
      </motion.div>
    )
}

export default CourseOptions
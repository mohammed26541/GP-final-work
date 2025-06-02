import { styles } from "@/app/styles/style";
import React, { FC } from "react";
import { RiAddCircleLine } from "react-icons/ri";
import { toast } from "react-hot-toast";
import { motion } from "framer-motion";

type Props = {
  benefits: { title: string }[];
  setBenefits: (benefits: { title: string }[]) => void;
  prerequisites: { title: string }[];
  setPrerequisites: (prerequisites: { title: string }[]) => void;
  active: number;
  setActive: (active: number) => void;
};

const CourseData: FC<Props> = ({
  benefits,
  setBenefits,
  prerequisites,
  setPrerequisites,
  active,
  setActive,
}) => {

  const handleBenefitChange = (index: number, value: any) => {
    const updatedBenefits = [...benefits];
    updatedBenefits[index].title = value;
    setBenefits(updatedBenefits);
  };

  const handleAddBenefit = () => {
    setBenefits([...benefits, { title: "" }]);
  };

  const handlePrerequisitesChange = (index: number, value: any) => {
    const updatedPrerequisites = [...prerequisites];
    updatedPrerequisites[index].title = value;
    setPrerequisites(updatedPrerequisites);
  };

  const handleAddPrerequisites = () => {
    setPrerequisites([...prerequisites, { title: "" }]);
  };

  const prevButton = () => {
    setActive(active - 1);
  }

  const handleOptions = () => {
    if (benefits[benefits.length - 1]?.title !== "" && prerequisites[prerequisites.length - 1]?.title !== "") {
      setActive(active + 1);
    } else{
        toast.error("Please fill the fields for go to next!")
    }
  };
  

  return (
    <div className="w-[90%] 800px:w-[80%] m-auto mt-24 dark:text-white text-black">
      <motion.h1 
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="text-[30px] font-bold text-center bg-clip-text text-transparent bg-gradient-to-r dark:from-blue-400 dark:to-purple-600 from-blue-600 to-purple-800 mb-10"
      >
        Course Benefits & Prerequisites
      </motion.h1>
      
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1, duration: 0.4 }}
        className="dark:bg-[#111827]/40 bg-gray-50/60 p-6 rounded-xl shadow-md space-y-8"
      >
        <div className="space-y-4">
          <h2 className="text-[22px] font-bold dark:text-white text-gray-800 border-b dark:border-gray-700 border-gray-200 pb-2">
            What are the benefits for students in this course?
          </h2>
          
          <div className="space-y-3">
            {benefits.map((benefit: any, index: number) => (
              <motion.div 
                key={index}
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: index * 0.05 }}
                className="relative"
              >
                <input
                  type="text"
                  name="Benefit"
                  placeholder="You will be able to build a full stack LMS Platform..."
                  required
                  className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
                  value={benefit.title}
                  onChange={(e) => handleBenefitChange(index, e.target.value)}
                />
              </motion.div>
            ))}
            
            <motion.button
              whileHover={{ scale: 1.03 }}
              whileTap={{ scale: 0.98 }}
              type="button"
              className="flex items-center px-4 py-2 rounded-lg dark:bg-blue-500/20 bg-blue-100 dark:text-blue-400 text-blue-600 hover:bg-blue-200 dark:hover:bg-blue-500/30 transition-colors duration-300 font-medium text-sm mt-4"
              onClick={handleAddBenefit}
            >
              <RiAddCircleLine className="mr-2 text-lg" /> Add Another Benefit
            </motion.button>
          </div>
        </div>

        <div className="space-y-4 mt-8">
          <h2 className="text-[22px] font-bold dark:text-white text-gray-800 border-b dark:border-gray-700 border-gray-200 pb-2">
            What are the prerequisites for starting this course?
          </h2>
          
          <div className="space-y-3">
            {prerequisites.map((prerequisite: any, index: number) => (
              <motion.div 
                key={index}
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: index * 0.05 }}
                className="relative"
              >
                <input
                  type="text"
                  name="prerequisites"
                  placeholder="You need basic knowledge of MERN stack"
                  required
                  className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
                  value={prerequisite.title}
                  onChange={(e) => handlePrerequisitesChange(index, e.target.value)}
                />
              </motion.div>
            ))}
            
            <motion.button
              whileHover={{ scale: 1.03 }}
              whileTap={{ scale: 0.98 }}
              type="button"
              className="flex items-center px-4 py-2 rounded-lg dark:bg-blue-500/20 bg-blue-100 dark:text-blue-400 text-blue-600 hover:bg-blue-200 dark:hover:bg-blue-500/30 transition-colors duration-300 font-medium text-sm mt-4"
              onClick={handleAddPrerequisites}
            >
              <RiAddCircleLine className="mr-2 text-lg" /> Add Another Prerequisite
            </motion.button>
          </div>
        </div>
        
        <div className="w-full flex items-center justify-between mt-10 flex-col 800px:flex-row gap-4">
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            type="button"
            className="w-full 800px:w-[180px] py-3 px-4 rounded-lg bg-gradient-to-r from-gray-500 to-gray-600 hover:from-gray-600 hover:to-gray-700 text-white font-medium shadow-md hover:shadow-lg transition-all duration-300 flex items-center justify-center"
            onClick={() => prevButton()}
          >
            Previous
          </motion.button>
          
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            type="button"
            className="w-full 800px:w-[180px] py-3 px-4 rounded-lg bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white font-medium shadow-md hover:shadow-lg transition-all duration-300 flex items-center justify-center"
            onClick={() => handleOptions()}
          >
            Continue
          </motion.button>
        </div>
      </motion.div>
    </div>
  );
};

export default CourseData;

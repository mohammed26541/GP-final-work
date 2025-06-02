import { styles } from "@/app/styles/style";
import { useGetHeroDataQuery } from "@/redux/features/layout/layoutApi";
import React, { FC, useEffect, useState } from "react";
import { FaCloudUploadAlt } from "react-icons/fa";
import { motion } from "framer-motion";

type Props = {
  courseInfo: any;
  setCourseInfo: (courseInfo: any) => void;
  active: number;
  setActive: (active: number) => void;
};

const CourseInformation: FC<Props> = ({
  courseInfo,
  setCourseInfo,
  active,
  setActive,
}) => {
  const [dragging, setDragging] = useState(false);
  const { data } = useGetHeroDataQuery("Categories", {});
  const [categories, setCategories] = useState([]);

  useEffect(() => {
    if (data) {
      setCategories(data.layout.categories);
    }
  }, [data]);

  const handleSubmit = (e: any) => {
    e.preventDefault();
    setActive(active + 1);
  };

  const handleFileChange = (e: any) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();

      reader.onload = (e: any) => {
        if (reader.readyState === 2) {
          setCourseInfo({ ...courseInfo, thumbnail: reader.result });
        }
      };
      reader.readAsDataURL(file);
    }
  };

  const handleDragOver = (e: any) => {
    e.preventDefault();
    setDragging(true);
  };

  const handleDragLeave = (e: any) => {
    e.preventDefault();
    setDragging(false);
  };

  const handleDrop = (e: any) => {
    e.preventDefault();
    setDragging(false);

    const file = e.dataTransfer.files?.[0];

    if (file) {
      const reader = new FileReader();

      reader.onload = () => {
        setCourseInfo({ ...courseInfo, thumbnail: reader.result });
      };
      reader.readAsDataURL(file);
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
        Course Information
      </motion.h1>
      
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1, duration: 0.4 }}
        className="dark:bg-[#111827]/40 bg-gray-50/60 p-6 rounded-xl shadow-md"
      >
        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label htmlFor="name" className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
              Course Name
            </label>
            <input
              type="text"
              required
              value={courseInfo.name}
              onChange={(e: any) =>
                setCourseInfo({ ...courseInfo, name: e.target.value })
              }
              id="name"
              placeholder="MERN stack LMS platform with next 13"
              className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
            />
          </div>
          
          <div>
            <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
              Course Description
            </label>
            <textarea
              cols={30}
              rows={6}
              placeholder="Write something amazing..."
              className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full resize-none"
              value={courseInfo.description}
              onChange={(e: any) =>
                setCourseInfo({ ...courseInfo, description: e.target.value })
              }
            ></textarea>
          </div>
          
          <div className="grid grid-cols-1 800px:grid-cols-2 gap-6">
            <div>
              <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
                Course Price ($)
              </label>
              <input
                type="number"
                required
                value={courseInfo.price}
                onChange={(e: any) =>
                  setCourseInfo({ ...courseInfo, price: e.target.value })
                }
                id="price"
                placeholder="29"
                className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
              />
            </div>
            <div>
              <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
                Estimated Price ($) <span className="text-gray-500 text-sm">(optional)</span>
              </label>
              <input
                type="number"
                value={courseInfo.estimatedPrice}
                onChange={(e: any) =>
                  setCourseInfo({ ...courseInfo, estimatedPrice: e.target.value })
                }
                id="estimatedPrice"
                placeholder="79"
                className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
              />
            </div>
          </div>
          
          <div className="grid grid-cols-1 800px:grid-cols-2 gap-6">
            <div>
              <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
                Course Tags
              </label>
              <input
                type="text"
                required
                value={courseInfo.tags}
                onChange={(e: any) =>
                  setCourseInfo({ ...courseInfo, tags: e.target.value })
                }
                id="tags"
                placeholder="MERN,Next 13,Socket io,tailwind css,LMS"
                className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
              />
            </div>
            <div>
              <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
                Course Categories
              </label>
              <select
                className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full appearance-none"
                value={courseInfo.category}
                onChange={(e: any) =>
                  setCourseInfo({ ...courseInfo, categories: e.target.value })
                }
              >
                <option value="">Select Category</option>
                {categories &&
                  categories.map((item: any) => (
                    <option value={item.title} key={item._id}>
                      {item.title}
                    </option>
                  ))}
              </select>
            </div>
          </div>
          
          <div className="grid grid-cols-1 800px:grid-cols-2 gap-6">
            <div>
              <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
                Course Level
              </label>
              <input
                type="text"
                value={courseInfo.level}
                required
                onChange={(e: any) =>
                  setCourseInfo({ ...courseInfo, level: e.target.value })
                }
                id="level"
                placeholder="Beginner/Intermediate/Expert"
                className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
              />
            </div>
            <div>
              <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
                Demo URL
              </label>
              <input
                type="text"
                required
                value={courseInfo.demoUrl}
                onChange={(e: any) =>
                  setCourseInfo({ ...courseInfo, demoUrl: e.target.value })
                }
                id="demoUrl"
                placeholder="eer74fd"
                className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
              />
            </div>
          </div>
          
          <div className="mt-6">
            <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
              Course Thumbnail
            </label>
            <input
              type="file"
              accept="image/*"
              id="file"
              className="hidden"
              onChange={handleFileChange}
            />
            <label
              htmlFor="file"
              className={`w-full h-[200px] border-2 border-dashed rounded-lg flex flex-col items-center justify-center cursor-pointer transition-all duration-300 ${
                dragging 
                  ? "border-blue-500 bg-blue-50 dark:bg-blue-900/20" 
                  : "dark:border-gray-600 border-gray-300 dark:hover:border-gray-500 hover:border-gray-400"
              }`}
              onDragOver={handleDragOver}
              onDragLeave={handleDragLeave}
              onDrop={handleDrop}
            >
              {courseInfo.thumbnail ? (
                <img
                  src={courseInfo.thumbnail}
                  alt="Course thumbnail"
                  className="h-full w-full object-cover rounded-lg"
                />
              ) : (
                <div className="flex flex-col items-center justify-center text-center p-4">
                  <FaCloudUploadAlt className="text-4xl mb-2 text-blue-500" />
                  <p className="dark:text-gray-300 text-gray-600 font-medium">
                    Drag and drop your thumbnail here
                  </p>
                  <p className="dark:text-gray-400 text-gray-500 text-sm mt-1">
                    or click to browse files
                  </p>
                </div>
              )}
            </label>
          </div>
          
          <div className="w-full flex items-center justify-end mt-8">
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              type="submit"
              className="w-full 800px:w-[180px] py-3 px-4 rounded-lg bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white font-medium shadow-md hover:shadow-lg transition-all duration-300 flex items-center justify-center"
            >
              Continue to Next Step
            </motion.button>
          </div>
        </form>
      </motion.div>
    </div>
  );
};

export default CourseInformation;

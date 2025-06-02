import { styles } from "@/app/styles/style";
import React, { FC, useState } from "react";
import { toast } from "react-hot-toast";
import { RiDeleteBin6Line, RiAddCircleLine } from "react-icons/ri";
import { BsLink45Deg, BsPencil } from "react-icons/bs";
import { MdOutlineKeyboardArrowDown, MdOutlineKeyboardArrowUp } from "react-icons/md";
import { motion } from "framer-motion";

type Props = {
  active: number;
  setActive: (active: number) => void;
  courseContentData: any;
  setCourseContentData: (courseContentData: any) => void;
  handleSubmit: any;
};

const CourseContent: FC<Props> = ({
  courseContentData,
  setCourseContentData,
  active,
  setActive,
  handleSubmit: handlleCourseSubmit,
}) => {
  const [isCollapsed, setIsCollapsed] = useState(
    Array(courseContentData.length).fill(false)
  );

  const [activeSection, setActiveSection] = useState(1);

  const handleSubmit = (e: any) => {
    e.preventDefault();
  };

  const handleCollapseToggle = (index: number) => {
    const updatedCollasped = [...isCollapsed];
    updatedCollasped[index] = !updatedCollasped[index];
    setIsCollapsed(updatedCollasped);
  };

  const handleRemoveLink = (index: number, linkIndex: number) => {
    const updatedData = JSON.parse(JSON.stringify(courseContentData));
    updatedData[index].links.splice(linkIndex, 1);
    setCourseContentData(updatedData);
  };

  const handleAddLink = (index: number) => {
    const updatedData = JSON.parse(JSON.stringify(courseContentData));
    updatedData[index].links.push({ title: "", url: "" });
    setCourseContentData(updatedData);
  };

  const newContentHandler = (item: any) => {
    if (
      item.title === "" ||
      item.description === "" ||
      item.videoUrl === "" ||
      item.links[0].title === "" ||
      item.links[0].url === "" ||
      item.videoLength === ""
    ) {
      toast.error("Please fill all the fields first!");
    } else {
      let newVideoSection = "";

      if (courseContentData.length > 0) {
        const lastVideoSection =
          courseContentData[courseContentData.length - 1].videoSection;

        // use the last videoSection if available, else use user input
        if (lastVideoSection) {
          newVideoSection = lastVideoSection;
        }
      }
      const newContent = {
        videoUrl: "",
        title: "",
        description: "",
        videoSection: newVideoSection,
        videoLength: "",
        links: [{ title: "", url: "" }],
      };

      setCourseContentData([...courseContentData, newContent]);
    }
  };

  const addNewSection = () => {
    if (
      courseContentData[courseContentData.length - 1].title === "" ||
      courseContentData[courseContentData.length - 1].description === "" ||
      courseContentData[courseContentData.length - 1].videoUrl === "" ||
      courseContentData[courseContentData.length - 1].links[0].title === "" ||
      courseContentData[courseContentData.length - 1].links[0].url === ""
    ) {
      toast.error("Please fill all the fields first!");
    } else {
      setActiveSection(activeSection + 1);
      const newContent = {
        videoUrl: "",
        title: "",
        description: "",
        videoLength: "",
        videoSection: `Untitled Section ${activeSection}`,
        links: [{ title: "", url: "" }],
      };
      setCourseContentData([...courseContentData, newContent]);
    }
  };

  const prevButton = () => {
    setActive(active - 1);
  };

  const handleOptions = () => {
    if (
      courseContentData[courseContentData.length - 1].title === "" ||
      courseContentData[courseContentData.length - 1].description === "" ||
      courseContentData[courseContentData.length - 1].videoUrl === "" ||
      courseContentData[courseContentData.length - 1].links[0].title === "" ||
      courseContentData[courseContentData.length - 1].links[0].url === ""
    ) {
      toast.error("section can't be empty!");
    } else {
      setActive(active + 1);
      handlleCourseSubmit();
    }
  };

  return (
    <div className="w-[90%] 800px:w-[80%] m-auto mt-24 p-3 dark:text-white text-black">
      <motion.h1 
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="text-[30px] font-bold text-center bg-clip-text text-transparent bg-gradient-to-r dark:from-blue-400 dark:to-purple-600 from-blue-600 to-purple-800 mb-10"
      >
        Course Content
      </motion.h1>
      
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1, duration: 0.4 }}
        className="dark:bg-[#111827]/40 bg-gray-50/60 p-6 rounded-xl shadow-md"
      >
        <form onSubmit={handleSubmit} className="space-y-6">
          {courseContentData?.map((item: any, index: number) => {
            const showSectionInput =
              index === 0 ||
              item.videoSection !== courseContentData[index - 1].videoSection;

            return (
              <motion.div 
                key={index}
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: index * 0.05 }}
                className={`w-full backdrop-blur-sm dark:bg-[rgba(30,41,59,0.4)] bg-[rgba(255,255,255,0.7)] p-5 rounded-lg border border-gray-200 dark:border-gray-700 shadow-sm ${showSectionInput ? "mt-8" : "mt-4"}`}
              >
                {showSectionInput && (
                  <div className="flex w-full items-center mb-4 border-b dark:border-gray-700 border-gray-200 pb-2">
                    <input
                      type="text"
                      className={`text-[20px] ${item.videoSection === "Untitled Section" ? "w-[200px]" : "w-min"} 
                        font-medium cursor-pointer dark:text-white text-gray-800 bg-transparent outline-none focus:border-b-2 focus:border-blue-500 transition-all`}
                      value={item.videoSection}
                      onChange={(e) => {
                        const updatedData = [...courseContentData];
                        updatedData[index].videoSection = e.target.value;
                        setCourseContentData(updatedData);
                      }}
                    />
                    <BsPencil className="cursor-pointer dark:text-gray-300 text-gray-600 ml-2" />
                  </div>
                )}
                
                <div className="w-full flex items-center justify-between py-2 px-3 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800/50 transition-all duration-200">
                  {isCollapsed[index] ? (
                    <>
                      {item.title ? (
                        <p className="font-medium dark:text-white text-gray-800">
                          {index + 1}. {item.title}
                        </p>
                      ) : (
                        <p className="text-gray-400 italic">Untitled content</p>  
                      )}
                    </>
                  ) : (
                    <div className="text-gray-500 dark:text-gray-400 font-medium">
                      {index + 1}. Content details
                    </div>
                  )}

                  {/* Toggle button for collapsed video content */}
                  <motion.div 
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.95 }}
                    className="flex items-center justify-center w-8 h-8 rounded-full dark:bg-gray-800/60 bg-gray-100 cursor-pointer"
                    onClick={() => handleCollapseToggle(index)}
                  >
                    {isCollapsed[index] ? (
                      <MdOutlineKeyboardArrowDown className="text-xl dark:text-gray-300 text-gray-600" />
                    ) : (
                      <MdOutlineKeyboardArrowUp className="text-xl dark:text-gray-300 text-gray-600" />
                    )}
                  </motion.div>
                </div>
                
                {!isCollapsed[index] && (
                  <div className="mt-4 space-y-5 px-3">
                    <div>
                      <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
                        Video Title
                      </label>
                      <input
                        type="text"
                        placeholder="Project Plan..."
                        className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
                        value={item.title}
                        onChange={(e) => {
                          const updatedData = courseContentData.map((content: any, i: number) => {
                            if (i === index) {
                              return { ...content, title: e.target.value };
                            }
                            return content;
                          });
                          setCourseContentData(updatedData);
                        }}
                      />
                    </div>
                    
                    <div>
                      <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
                        Video URL
                      </label>
                      <input
                        type="text"
                        placeholder="Enter video URL here"
                        className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
                        value={item.videoUrl}
                        onChange={(e) => {
                          const updatedData = courseContentData.map((content: any, i: number) => {
                            if (i === index) {
                              return { ...content, videoUrl: e.target.value };
                            }
                            return content;
                          });
                          setCourseContentData(updatedData);
                        }}
                      />
                    </div>
                    
                    <div>
                      <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
                        Video Length (in minutes)
                      </label>
                      <input
                        type="number"
                        placeholder="20"
                        className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
                        value={item.videoLength}
                        onChange={(e) => {
                          const updatedData = courseContentData.map((content: any, i: number) => {
                            if (i === index) {
                              return { ...content, videoLength: e.target.value };
                            }
                            return content;
                          });
                          setCourseContentData(updatedData);
                        }}
                      />
                    </div>

                    <div>
                      <label className="block text-[16px] font-medium dark:text-gray-200 text-gray-700 mb-2">
                        Video Description
                      </label>
                      <textarea
                        rows={5}
                        placeholder="Describe what students will learn in this video"
                        className="px-4 py-3 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full resize-none"
                        value={item.description}
                        onChange={(e) => {
                          const updatedData = courseContentData.map((content: any, i: number) => {
                            if (i === index) {
                              return { ...content, description: e.target.value };
                            }
                            return content;
                          });
                          setCourseContentData(updatedData);
                        }}
                      />
                    </div>
                    
                    <div className="pt-2">
                      <div className="flex items-center justify-between mb-3">
                        <label className="text-[16px] font-medium dark:text-gray-200 text-gray-700">
                          Additional Resources
                        </label>
                      </div>
                      
                      {item?.links.map((link: any, linkIndex: number) => (
                        <div key={linkIndex} className="mb-4 p-3 dark:bg-gray-800/30 bg-gray-100/70 rounded-lg">
                          <div className="w-full flex items-center justify-between mb-2">
                            <label className="text-[15px] font-medium dark:text-gray-300 text-gray-700">
                              Resource {linkIndex + 1}
                            </label>
                            <motion.button
                              whileHover={{ scale: 1.1 }}
                              whileTap={{ scale: 0.95 }}
                              type="button"
                              className={`${linkIndex === 0 ? "opacity-50 cursor-not-allowed" : "cursor-pointer"} 
                                p-1.5 rounded-full dark:bg-red-500/20 bg-red-100 dark:text-red-400 text-red-500 hover:bg-red-200 dark:hover:bg-red-500/30 transition-colors duration-300`}
                              onClick={() => linkIndex === 0 ? null : handleRemoveLink(index, linkIndex)}
                              disabled={linkIndex === 0}
                            >
                              <RiDeleteBin6Line className="text-[16px]" />
                            </motion.button>
                          </div>
                          
                          <div className="grid grid-cols-1 gap-3">
                            <input
                              type="text"
                              placeholder="Resource title (e.g. Source Code, Slides)"
                              className="px-4 py-2.5 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
                              value={link.title}
                              onChange={(e) => {
                                const updatedData = courseContentData.map((content: any, i: number) => {
                                  if (i === index) {
                                    const updatedLinks = content.links.map((link: any, j: number) => {
                                      if (j === linkIndex) {
                                        return { ...link, title: e.target.value };
                                      }
                                      return link;
                                    });
                                    return { ...content, links: updatedLinks };
                                  }
                                  return content;
                                });
                                setCourseContentData(updatedData);
                              }}
                            />
                            
                            <input
                              type="url"
                              placeholder="Resource URL"
                              className="px-4 py-2.5 rounded-lg dark:bg-[#192339] bg-white border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full"
                              value={link.url}
                              onChange={(e) => {
                                const updatedData = [...courseContentData];
                                updatedData[index].links[linkIndex].url = e.target.value;
                                setCourseContentData(updatedData);
                              }}
                            />
                          </div>
                        </div>
                      ))}
                      
                      <motion.button
                        whileHover={{ scale: 1.03 }}
                        whileTap={{ scale: 0.98 }}
                        type="button"
                        className="flex items-center px-4 py-2 rounded-lg dark:bg-blue-500/20 bg-blue-100 dark:text-blue-400 text-blue-600 hover:bg-blue-200 dark:hover:bg-blue-500/30 transition-colors duration-300 font-medium text-sm"
                        onClick={() => handleAddLink(index)}
                      >
                        <BsLink45Deg className="mr-2 text-lg" /> Add Resource Link
                      </motion.button>
                    </div>
                  </div>
                )}
                
                {/* Add new content button */}
                {index === courseContentData.length - 1 && (
                  <div className="mt-6 border-t dark:border-gray-700 border-gray-200 pt-4">
                    <motion.button
                      whileHover={{ scale: 1.03 }}
                      whileTap={{ scale: 0.98 }}
                      type="button"
                      className="flex items-center px-4 py-2 rounded-lg dark:bg-indigo-500/20 bg-indigo-100 dark:text-indigo-400 text-indigo-600 hover:bg-indigo-200 dark:hover:bg-indigo-500/30 transition-colors duration-300 font-medium"
                      onClick={(e: any) => newContentHandler(item)}
                    >
                      <RiAddCircleLine className="mr-2 text-lg" /> Add New Content
                    </motion.button>
                  </div>
                )}
              </motion.div>
            );
          })}
          
          <motion.button
            whileHover={{ scale: 1.03 }}
            whileTap={{ scale: 0.98 }}
            type="button"
            className="flex items-center px-5 py-3 rounded-lg bg-gradient-to-r from-purple-500 to-indigo-600 text-white hover:shadow-lg transition-all duration-300 font-medium mt-8"
            onClick={() => addNewSection()}
          >
            <RiAddCircleLine className="mr-2 text-lg" /> Add New Section
          </motion.button>
        </form>
        
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

export default CourseContent;

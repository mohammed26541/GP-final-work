import React, { FC } from "react";
import CoursePlayer from "../../../utils/CoursePlayer";
import { styles } from "../../../../app/styles/style";
import Ratings from "../../../../app/utils/Ratings";
import { IoCheckmarkDoneOutline } from "react-icons/io5";
import { FaTag } from "react-icons/fa";

type Props = {
  active: number;
  setActive: (active: number) => void;
  courseData: any;
  handleCourseCreate: any;
  isEdit?: boolean;
};

const CoursePreview: FC<Props> = ({
  courseData,
  handleCourseCreate,
  setActive,
  active,
  isEdit
}) => {
  const dicountPercentenge =
    ((courseData?.estimatedPrice - courseData?.price) /
      courseData?.estimatedPrice) *
    100;

  const discountPercentengePrice = dicountPercentenge.toFixed(0);

  const prevButton = () => {
    setActive(active - 1);
  };

  const createCourse = () => {
    handleCourseCreate();
  };

  return (
    <div className="w-[90%] m-auto py-5 mb-5 dark:text-white text-black">
      <div className="w-full relative">
        <div className="w-full mt-10">
          <CoursePlayer
            videoUrl={courseData?.demoUrl}
            title={courseData?.title}
          />
        </div>
        <div className="flex items-center mt-6 flex-wrap gap-2">
          <h1 className="text-[28px] font-bold dark:text-white text-gray-800">
            {courseData?.price === 0 ? "Free" : courseData?.price + "$"}
          </h1>
          <h5 className="pl-3 text-[20px] line-through dark:text-gray-400 text-gray-500">
            {courseData?.estimatedPrice}$
          </h5>

          <div className="ml-4 px-3 py-1 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-full flex items-center">
            <FaTag className="mr-1" />
            <span>{discountPercentengePrice}% Off</span>
          </div>
        </div>

        <div className="flex items-center mt-4">
          <button
            className="px-6 py-2.5 rounded-lg bg-gradient-to-r from-red-500 to-pink-600 text-white font-medium shadow-md hover:shadow-lg transition-all duration-300 opacity-80 cursor-not-allowed"
            disabled
          >
            Buy Now {courseData?.price}$
          </button>
        </div>

        <div className="flex items-center mt-6 flex-wrap gap-2">
          <input
            type="text"
            placeholder="Discount code..."
            className="px-4 py-2.5 rounded-lg dark:bg-[#192339] bg-gray-100 border dark:border-gray-700 border-gray-300 outline-none focus:border-blue-500 dark:focus:border-blue-500 transition-all duration-300 dark:text-white text-gray-800 w-full 800px:w-[60%] 1100px:w-[70%]"
          />
          <button
            className="px-6 py-2.5 rounded-lg bg-gradient-to-r from-blue-500 to-indigo-600 text-white font-medium shadow-md hover:shadow-lg transition-all duration-300 w-full 800px:w-[120px] mt-2 800px:mt-0"
          >
            Apply
          </button>
        </div>
        
        <div className="mt-6 grid grid-cols-1 800px:grid-cols-2 gap-2">
          <div className="flex items-center dark:text-gray-200 text-gray-700">
            <IoCheckmarkDoneOutline className="mr-2 text-green-500" size={18} />
            <p>Source code included</p>
          </div>
          <div className="flex items-center dark:text-gray-200 text-gray-700">
            <IoCheckmarkDoneOutline className="mr-2 text-green-500" size={18} />
            <p>Full lifetime access</p>
          </div>
          <div className="flex items-center dark:text-gray-200 text-gray-700">
            <IoCheckmarkDoneOutline className="mr-2 text-green-500" size={18} />
            <p>Certificate of completion</p>
          </div>
          <div className="flex items-center dark:text-gray-200 text-gray-700">
            <IoCheckmarkDoneOutline className="mr-2 text-green-500" size={18} />
            <p>Premium Support</p>
          </div>
        </div>
      </div>
      
      <div className="w-full mt-10 dark:bg-[#111827]/40 bg-gray-50/60 p-6 rounded-xl">
        <div className="w-full 800px:pr-5">
          <h1 className="text-[25px] font-bold dark:text-white text-gray-800">
            {courseData?.name}
          </h1>
          <div className="flex items-center justify-between pt-3 flex-wrap gap-2">
            <div className="flex items-center">
              <Ratings rating={0} />
              <h5 className="ml-2 dark:text-gray-300 text-gray-600">0 Reviews</h5>
            </div>
            <h5 className="dark:text-gray-300 text-gray-600">0 Students</h5>
          </div>
          
          <div className="mt-8">
            <h2 className="text-[22px] font-bold dark:text-white text-gray-800 border-b dark:border-gray-700 border-gray-200 pb-2">
              What you will learn from this course?
            </h2>
            <div className="mt-4 grid grid-cols-1 800px:grid-cols-2 gap-3">
              {courseData?.benefits?.map((item: any, index: number) => (
                <div className="flex items-start" key={index}>
                  <div className="mt-1 text-green-500">
                    <IoCheckmarkDoneOutline size={18} />
                  </div>
                  <p className="ml-2 dark:text-gray-200 text-gray-700">{item.title}</p>
                </div>
              ))}
            </div>
          </div>
          
          <div className="mt-8">
            <h2 className="text-[22px] font-bold dark:text-white text-gray-800 border-b dark:border-gray-700 border-gray-200 pb-2">
              Prerequisites for this course
            </h2>
            <div className="mt-4 grid grid-cols-1 800px:grid-cols-2 gap-3">
              {courseData?.prerequisites?.map((item: any, index: number) => (
                <div className="flex items-start" key={index}>
                  <div className="mt-1 text-green-500">
                    <IoCheckmarkDoneOutline size={18} />
                  </div>
                  <p className="ml-2 dark:text-gray-200 text-gray-700">{item.title}</p>
                </div>
              ))}
            </div>
          </div>
          
          <div className="mt-8">
            <h2 className="text-[22px] font-bold dark:text-white text-gray-800 border-b dark:border-gray-700 border-gray-200 pb-2">
              Course Details
            </h2>
            <p className="mt-4 text-[16px] dark:text-gray-200 text-gray-700 whitespace-pre-line w-full overflow-hidden leading-relaxed">
              {courseData?.description}
            </p>
          </div>
        </div>
      </div>
      
      <div className="w-full flex items-center justify-between mt-10 flex-col 800px:flex-row gap-4">
        <button
          className="w-full 800px:w-[180px] py-3 px-4 rounded-lg bg-gradient-to-r from-gray-500 to-gray-600 hover:from-gray-600 hover:to-gray-700 text-white font-medium shadow-md hover:shadow-lg transition-all duration-300 flex items-center justify-center"
          onClick={() => prevButton()}
        >
          Previous
        </button>
        <button
          className="w-full 800px:w-[180px] py-3 px-4 rounded-lg bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white font-medium shadow-md hover:shadow-lg transition-all duration-300 flex items-center justify-center"
          onClick={() => createCourse()}
        >
          {isEdit ? 'Update Course' : 'Create Course'}
        </button>
      </div>
    </div>
  );
};

export default CoursePreview;

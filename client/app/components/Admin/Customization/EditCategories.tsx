import {
  useEditLayoutMutation,
  useGetHeroDataQuery,
} from "@/redux/features/layout/layoutApi";
import React, { useEffect, useState } from "react";
import Loader from "../../Loader/Loader";
import { styles } from "@/app/styles/style";
import { RiDeleteBin6Line } from "react-icons/ri";
import { IoAddOutline } from "react-icons/io5";
import { toast } from "react-hot-toast";
import { motion, AnimatePresence } from "framer-motion";

type Props = {};

const EditCategories = (props: Props) => {
  const { data, isLoading,refetch } = useGetHeroDataQuery("Categories", {
    refetchOnMountOrArgChange: true,
  });
  const [editLayout, { isSuccess: layoutSuccess, error }] =
    useEditLayoutMutation();
  const [categories, setCategories] = useState<any>([]);

  useEffect(() => {
    if (data) {
      setCategories(data.layout.categories);
    }
    if (layoutSuccess) {
        refetch();
      toast.success("Categories updated successfully");
    }

    if (error) {
      if ("data" in error) {
        const errorData = error as any;
        toast.error(errorData?.data?.message);
      }
    }
  }, [data, layoutSuccess, error,refetch]);

  const handleCategoriesAdd = (id: any, value: string) => {
    setCategories((prevCategory: any) =>
      prevCategory.map((i: any) => (i._id === id ? { ...i, title: value } : i))
    );
  };

  const newCategoriesHandler = () => {
    if (categories[categories.length - 1].title === "") {
      toast.error("Category title cannot be empty");
    } else {
      setCategories((prevCategory: any) => [...prevCategory, { title: "" }]);
    }
  };

  const areCategoriesUnchanged = (
    originalCategories: any[],
    newCategories: any[]
  ) => {
    return JSON.stringify(originalCategories) === JSON.stringify(newCategories);
  };

  const isAnyCategoryTitleEmpty = (categories: any[]) => {
    return categories.some((q) => q.title === "");
  };

  const editCategoriesHandler = async () => {
    if (
      !areCategoriesUnchanged(data.layout.categories, categories) &&
      !isAnyCategoryTitleEmpty(categories)
    ) {
      await editLayout({
        type: "Categories",
        categories,
      });
    }
  };

  return (
    <>
      {isLoading ? (
        <Loader />
      ) : (
        <div className="w-full h-full text-center pb-24 relative">
          <motion.h1 
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className={`text-[32px] font-bold bg-clip-text text-transparent bg-gradient-to-r dark:from-blue-400 dark:to-purple-600 from-blue-600 to-purple-800 pt-[120px] mb-8`}
          >
            Categories Management
          </motion.h1>
          <div className="w-full max-h-[calc(100vh-250px)] overflow-y-auto scrollbar-hide px-4 py-2">
            <AnimatePresence>
              {categories &&
                categories.map((item: any, index: number) => {
                  return (
                    <motion.div 
                      key={index}
                      initial={{ opacity: 0, scale: 0.9 }}
                      animate={{ opacity: 1, scale: 1 }}
                      exit={{ opacity: 0, scale: 0.9 }}
                      transition={{ duration: 0.2 }}
                      className="p-3"
                    >
                      <div className="flex items-center w-full max-w-[500px] mx-auto justify-between backdrop-blur-sm dark:bg-[rgba(30,41,59,0.4)] bg-[rgba(255,255,255,0.7)] rounded-xl p-3 shadow-lg border border-gray-200 dark:border-gray-700 hover:shadow-xl transition-all duration-300">
                        <input
                          className="w-full bg-transparent border-none outline-none text-[18px] font-medium dark:text-white text-gray-800 placeholder:text-gray-400 dark:placeholder:text-gray-500"
                          value={item.title}
                          onChange={(e) =>
                            handleCategoriesAdd(item._id, e.target.value)
                          }
                          placeholder="Enter category title..."
                        />
                        <motion.button
                          whileHover={{ scale: 1.1 }}
                          whileTap={{ scale: 0.95 }}
                          onClick={() => {
                            setCategories((prevCategory: any) =>
                              prevCategory.filter((i: any) => i._id !== item._id)
                            );
                          }}
                          className="ml-2 p-2 rounded-full dark:bg-red-500/20 bg-red-100 dark:text-red-400 text-red-500 hover:bg-red-200 dark:hover:bg-red-500/30 transition-colors duration-300"
                        >
                          <RiDeleteBin6Line className="text-[18px]" />
                        </motion.button>
                      </div>
                    </motion.div>
                  );
                })}
            </AnimatePresence>
            
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="w-full flex justify-center mt-6 mb-16"
            >
              <motion.button
                whileHover={{ scale: 1.1, rotate: 90 }}
                whileTap={{ scale: 0.95 }}
                onClick={newCategoriesHandler}
                className="p-3 rounded-full bg-gradient-to-r dark:from-blue-500 dark:to-purple-600 from-blue-600 to-purple-700 text-white shadow-lg hover:shadow-xl transition-all duration-300 flex items-center justify-center"
              >
                <IoAddOutline className="text-[24px]" />
              </motion.button>
            </motion.div>
          </div>
          
          <motion.div
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.3 }}
            className={`fixed bottom-12 right-12 z-10`}
          >
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className={`px-6 py-3 rounded-full font-medium text-white shadow-lg
              ${areCategoriesUnchanged(data.layout.categories, categories) ||
                isAnyCategoryTitleEmpty(categories)
                  ? "bg-gray-400 cursor-not-allowed opacity-70"
                  : "bg-gradient-to-r from-emerald-500 to-teal-500 cursor-pointer hover:shadow-emerald-500/20 hover:shadow-xl"}
              transition-all duration-300`}
              onClick={
                areCategoriesUnchanged(data.layout.categories, categories) ||
                isAnyCategoryTitleEmpty(categories)
                  ? () => null
                  : editCategoriesHandler
              }
            >
              Save Changes
            </motion.button>
          </motion.div>
        </div>
      )}
    </>
  );
};

export default EditCategories;

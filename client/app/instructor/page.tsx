"use client";
import React, { useState } from "react";
import Heading from "../utils/Heading";
import InstructorSidebar from "./sidebar/InstructorSidebar";
import InstructorProtected from "../hooks/instructorProtected";
import DashboardHeader from "../components/Instructor/DashboardHeader";
import { useGetInstructorCoursesQuery } from "@/redux/features/courses/coursesApi";

type Props = {};

const Page = (props: Props) => {
  const [open, setOpen] = useState(false);
  const { data, isLoading } = useGetInstructorCoursesQuery({});

  return (
    <div>
      <InstructorProtected>
        <Heading
          title="Elearning - Instructor"
          description="ELearning is a platform for students to learn and get help from teachers"
          keywords="Programming,MERN,Redux,Machine Learning"
        />
        <div className="flex min-h-screen">
          <div className="1500px:w-[16%] w-1/5">
            <InstructorSidebar />
          </div>
          <div className="w-[85%]">
            <DashboardHeader open={open} setOpen={setOpen} />
            <div className="mt-[30px] dark:text-white">
              <div className="p-8">
                <h1 className="text-[25px] font-Poppins font-[500] dark:text-white text-black">
                  Instructor Dashboard
                </h1>
                <div className="w-full flex flex-wrap mt-5 gap-5">
                  <div className="w-full 800px:w-[30%] min-h-[20vh] bg-white dark:bg-[#111C43] shadow rounded-[8px] px-3 py-5 flex flex-col items-center">
                    <div className="flex flex-row items-center justify-between w-full">
                      <h5 className="text-[18px] font-[500] dark:text-white text-black">
                        Total Courses
                      </h5>
                      <span className="text-[22px] font-[500] text-blue-500">
                        {data?.courses?.length || 0}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </InstructorProtected>
    </div>
  );
};

export default Page; 
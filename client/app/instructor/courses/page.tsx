"use client";
import React from "react";
import Heading from "../../utils/Heading";
import InstructorSidebar from "../sidebar/InstructorSidebar";
import InstructorProtected from "../../hooks/instructorProtected";
import DashboardHeader from "../../components/Instructor/DashboardHeader";
import InstructorCourses from "../../components/Instructor/Courses/InstructorCourses";

type Props = {};

const Page = (props: Props) => {
  return (
    <div>
      <InstructorProtected>
        <Heading
          title="All Courses - Instructor"
          description="ELearning is a platform for students to learn and get help from teachers"
          keywords="Programming,MERN,Redux,Machine Learning"
        />
        <div className="flex min-h-screen">
          <div className="1500px:w-[16%] w-1/5">
            <InstructorSidebar />
          </div>
          <div className="w-[85%]">
            <DashboardHeader />
            <div className="w-full p-8">
              <InstructorCourses />
            </div>
          </div>
        </div>
      </InstructorProtected>
    </div>
  );
};

export default Page; 
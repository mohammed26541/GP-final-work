"use client";
import React from "react";
import Heading from "../../utils/Heading";
import InstructorSidebar from "../sidebar/InstructorSidebar";
import InstructorProtected from "../../hooks/instructorProtected";
import DashboardHeader from "../../components/Instructor/DashboardHeader";
import CreateCourse from "../../components/Admin/Course/CreateCourse";

type Props = {};

const Page = (props: Props) => {
  return (
    <div>
      <InstructorProtected>
        <Heading
          title="Create Course - Instructor"
          description="ELearning is a platform for students to learn and get help from teachers"
          keywords="Programming,MERN,Redux,Machine Learning"
        />
        <div className="flex min-h-screen">
          <div className="1500px:w-[16%] w-1/5">
            <InstructorSidebar />
          </div>
          <div className="w-[85%]">
            <DashboardHeader />
            <CreateCourse />
          </div>
        </div>
      </InstructorProtected>
    </div>
  );
};

export default Page; 
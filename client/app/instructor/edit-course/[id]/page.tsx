'use client'
import React from 'react'
import InstructorSidebar from "../../sidebar/InstructorSidebar";
import Heading from '../../../../app/utils/Heading';
import DashboardHeader from '../../../../app/components/Instructor/DashboardHeader';
import EditCourse from "../../../../app/components/Instructor/Course/EditCourse";
import InstructorProtected from '../../../hooks/instructorProtected';

// Define proper type for route parameters
interface CourseParams {
  id: string;
}

type Props = {
  params: CourseParams;
}

const page = ({params}: Props) => {
    // Access params directly since it's not a Promise
    const id = params.id;

  return (
    <div>
      <InstructorProtected>
        <Heading
         title="Edit Course - Instructor"
         description="ELearning is a platform for students to learn and get help from teachers"
         keywords="Programming,MERN,Redux,Machine Learning"
        />
        <div className="flex">
            <div className="1500px:w-[16%] w-1/5">
                <InstructorSidebar />
            </div>
            <div className="w-[85%]">
               <DashboardHeader />
               <EditCourse id={id} />
            </div>
        </div>
      </InstructorProtected>
    </div>
  )
}

export default page 
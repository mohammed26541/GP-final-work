'use client'
import React from "react";
import CourseDetailsPage from "../../components/Course/CourseDetailsPage";

// Define the type for route parameters
interface CoursePageParams {
    id: string;
}

const Page = ({params}:{params: CoursePageParams}) => {
    // Access params directly since it's not a Promise
    return (
        <div>
            <CourseDetailsPage id={params.id} />
        </div>
    )
}

export default Page;
 
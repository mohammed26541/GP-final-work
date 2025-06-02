import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";
import { userLoggedIn } from "../auth/authSlice";

// Create a custom base query with better error handling
console.log('Server URI:', process.env.NEXT_PUBLIC_SERVER_URI);

const customBaseQuery = fetchBaseQuery({
  baseUrl: process.env.NEXT_PUBLIC_SERVER_URI,
  credentials: "include", // Always include credentials for all requests
  prepareHeaders: (headers) => {
    // You can add common headers here if needed
    return headers;
  },
});

// Enhanced base query with error handling
const baseQueryWithErrorHandling = async (args: any, api: any, extraOptions: any) => {
  // Try the request
  const result = await customBaseQuery(args, api, extraOptions);
  
  // Handle common errors
  if (result.error) {
    if (result.error.status === 401) {
      console.log('Unauthorized request - user may need to log in');
    }
    if (result.error.status === 400) {
      console.log('Bad request - check request parameters');
    }
  }
  
  return result;
};

export const apiSlice = createApi({
  reducerPath: "api",
  baseQuery: baseQueryWithErrorHandling,
  endpoints: (builder) => ({
    refreshToken: builder.query({
      query: () => ({
        url: "refresh",
        method: "GET",
      }),
    }),
    loadUser: builder.query({
      query: () => ({
        url: "me",
        method: "GET",
      }),
      // Only cache for a short time
      keepUnusedDataFor: 5, // 5 seconds
      async onQueryStarted(arg, { queryFulfilled, dispatch }) {
        try {
          const result = await queryFulfilled;
          dispatch(
            userLoggedIn({
              accessToken: result.data.accessToken,
              user: result.data.user,
            })
          );
        } catch (error: any) {
          // Handle error gracefully
          console.log("Failed to load user:", error?.error?.status || error);
          // We don't need to do anything else here - the component will handle the error state
        }
      },
    }),
  }),
});

export const { useRefreshTokenQuery, useLoadUserQuery } = apiSlice;

"use client";
import "./globals.css";
import { Poppins } from "next/font/google";
import { Josefin_Sans } from "next/font/google";
import { ThemeProvider } from "./utils/theme-provider";
import { Toaster } from "react-hot-toast";
import { Providers } from "./Provider";
import { SessionProvider } from "next-auth/react";
import React, { FC, useEffect } from "react";
import { useLoadUserQuery } from "@/redux/features/api/apiSlice";
import Loader from "./components/Loader/Loader";
import socketIO from "socket.io-client";
const ENDPOINT = process.env.NEXT_PUBLIC_SOCKET_SERVER_URI || "";
const socketId = socketIO(ENDPOINT, { transports: ["websocket"] });

const poppins = Poppins({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-Poppins",
});

const josefin = Josefin_Sans({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-Josefin",
});

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  React.useEffect(() => {
    const script = document.createElement('script');
    script.innerHTML = `(
      function(){if(!window.chatbase||window.chatbase("getState")!=="initialized"){window.chatbase=(...arguments)=>{if(!window.chatbase.q){window.chatbase.q=[]}window.chatbase.q.push(arguments)};window.chatbase=new Proxy(window.chatbase,{get(target,prop){if(prop==="q"){return target.q}return(...args)=>target(prop,...args)}})}const onLoad=function(){const script=document.createElement("script");script.src="https://www.chatbase.co/embed.min.js";script.id="mkbTARoNx-ISkZCIZCGep";script.domain="www.chatbase.co";document.body.appendChild(script)};if(document.readyState==="complete"){onLoad()}else{window.addEventListener("load",onLoad)}}
    )();`;
    document.body.appendChild(script);
    return () => {
      document.body.removeChild(script);
    };
  }, []);

  return (
    <html lang="en" suppressHydrationWarning={true}>
      <body
        className={`${poppins.variable} ${josefin.variable} !bg-white bg-no-repeat dark:bg-gradient-to-b dark:from-gray-900 dark:to-black duration-300`}
      >
        <Providers>
          <SessionProvider>
            <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
              <Custom>
                <div>{children}</div>
              </Custom>
              <Toaster position="top-center" reverseOrder={false} />
            </ThemeProvider>
          </SessionProvider>
        </Providers>
      </body>
    </html>
  );
}

const Custom: FC<{ children: React.ReactNode }> = ({ children }) => {
  // Track component mount state to avoid hydration mismatch
  const [mounted, setMounted] = React.useState(false);
  // Track if we've attempted authentication
  const [authAttempted, setAuthAttempted] = React.useState(false);
  
  // Use the query with enhanced error handling
  const { isLoading, error, isError } = useLoadUserQuery(
    undefined, // No need to pass empty object
    {
      // Skip the query if we're on the server to avoid 400 errors during SSR
      skip: typeof window === 'undefined',
      // Don't retry on error to avoid repeated 400 errors
      refetchOnMountOrArgChange: false,
      // Only retry once
      refetchOnReconnect: false,
    }
  );

  useEffect(() => {
    // Setup socket connection
    socketId.on("connection", () => {});
    setMounted(true);
    
    // After a short delay, consider auth attempted even if still loading
    // This prevents infinite loading if the server is slow to respond
    const timer = setTimeout(() => {
      setAuthAttempted(true);
    }, 3000); // 3 seconds timeout
    
    return () => {
      clearTimeout(timer);
    };
  }, []);

  // Mark auth as attempted when we get a response (success or error)
  useEffect(() => {
    if (!isLoading || isError) {
      setAuthAttempted(true);
    }
  }, [isLoading, isError]);

  // This ensures we only render the conditional content on the client
  // to avoid hydration mismatch
  return (
    <div suppressHydrationWarning>
      {!mounted ? (
        // During initial render, hide content to prevent hydration mismatch
        <div style={{ visibility: "hidden" }}>{children}</div>
      ) : isLoading && !authAttempted ? (
        // Show loader only during initial loading and before timeout
        <Loader />
      ) : (
        // Show content once loaded or if there was an error
        <div>{children}</div>
      )}
    </div>
  );
};

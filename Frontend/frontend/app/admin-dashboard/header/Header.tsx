"use client";

import React from "react";
import { motion } from "framer-motion";
import Image from "next/image";

interface HeaderProps {
  darkMode: boolean;
  setDarkMode: React.Dispatch<React.SetStateAction<boolean>>;
}

const Header: React.FC<HeaderProps> = ({ darkMode, setDarkMode }) => {
  return (
    <motion.header
      initial={{ y: -30, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.6, ease: "easeOut" }}
      className="
        sticky top-0 z-50
        flex items-center justify-between
        px-6 md:px-10 py-4
        backdrop-blur-md bg-white/40 dark:bg-white/10
        shadow-lg border border-white/40 dark:border-white/10
        rounded-b-2xl
      "
    >
      {/* LOGO */}
      <motion.div
        whileHover={{ scale: 1.05 }}
        className="flex items-center gap-2 cursor-pointer"
      >
        <motion.span
          animate={{ x: [0, 6, 0] }}
          transition={{ repeat: Infinity, duration: 2, ease: "easeInOut" }}
          className="text-2xl"
        >
          <Image src="/bus.png"
            alt="Blue and white bus icon moving slightly to the right and left, representing public transportation in a modern digital dashboard with the text MAGIYA.LK nearby"
            className="w-10 h-10"
            width={35} 
            height={35}
          />
        </motion.span>

        <div className="relative font-bold text-xl md:text-2xl">
          MAGIYA.LK
          <motion.span
            layoutId="routeLine"
            className="absolute left-0 -bottom-1 h-[2px] w-full bg-blue-500 rounded"
            initial={{ scaleX: 0 }}
            animate={{ scaleX: 1 }}
            transition={{ duration: 0.6 }}
            style={{ originX: 0 }}
          />
        </div>
      </motion.div>

      {/* RIGHT SIDE */}
      <div className="flex items-center gap-3 md:gap-4">
        {/* SEARCH */}
        <motion.input
          type="text"
          placeholder="Search route or city..."
          whileFocus={{ width: 260 }}
          className="
            w-36 md:w-52
            px-3 py-2 rounded-xl
            bg-white/60 dark:bg-white/10 backdrop-blur
            border border-white/40 dark:border-white/10
            focus:ring-2 focus:ring-blue-400
            transition-all duration-300
            hidden sm:block
          "
        />

        {/* DARK MODE */}
        <motion.button
          whileTap={{ rotate: 180, scale: 0.9 }}
          whileHover={{ scale: 1.1 }}
          onClick={() => setDarkMode(!darkMode)}
          className="
            px-3 py-2 rounded-xl
            bg-white/60 dark:bg-white/10 backdrop-blur
            border border-white/40 dark:border-white/10
          "
        >
          {darkMode ? "🌙" : "☀️"}
        </motion.button>

        {/* PROFILE */}
        <motion.div
          whileHover={{ scale: 1.15 }}
          className="
            w-9 h-9 rounded-full
            bg-white/60 dark:bg-white/10 backdrop-blur
            flex items-center justify-center font-bold
            border border-white/40 dark:border-white/10
            cursor-pointer
          "
        >
          A
        </motion.div>
      </div>
    </motion.header>
  );
};

export default Header;

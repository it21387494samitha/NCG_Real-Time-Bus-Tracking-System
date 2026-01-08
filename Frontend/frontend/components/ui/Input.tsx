"use client";

import React from "react";

type InputProps = React.InputHTMLAttributes<HTMLInputElement>;

const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className = "", ...props }, ref) => {
    return (
      <input
        ref={ref}
        className={`
          w-full px-5 py-3
          rounded-2xl
          border border-gray-300
          bg-white
          text-gray-900
          placeholder-gray-400
          focus:outline-none
          focus:ring-2 focus:ring-indigo-500
          focus:bg-white
          transition
          ${className}
        `}
        {...props}
      />
    );
  }
);

Input.displayName = "Input";

export default Input;

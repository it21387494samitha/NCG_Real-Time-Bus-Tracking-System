"use client";
import React, { useState } from "react";
import Header from "./admin-dashboard/header/Header";
import { useRouter } from "next/navigation";
import { useRef } from "react";


const summaryCards = [
  { title: "Total Users", value: "1,234", trend: "+5%" },
  { title: "Total Buses", value: "56", trend: "+2%" },
  { title: "Reports", value: "12", trend: "+8%" },
];







const quickActions = ["Add User", "Register Bus", "Download Report"];

export default function AdminDashboard() {
  const [darkMode, setDarkMode] = useState(false);
  
 
 const router = useRouter();





  return (
    <div
      className={
        darkMode
          ? "dark bg-gradient-to-br from-gray-900 via-gray-950 to-black text-white min-h-screen"
          : "bg-gradient-to-br from-blue-50 via-white to-purple-50 text-gray-900 min-h-screen"
      }
    >
      {/* Top Bar */}
        <Header darkMode={darkMode} setDarkMode={setDarkMode} />

      {/* Layout */}
      <div className="flex">

        {/* Sidebar */}
        <aside
          className="w-72 min-h-screen p-8 relative overflow-hidden border-r border-white/20 backdrop-blur-xl bg-white/30 dark:bg-white/5"
          style={{
            backgroundImage: "url('/dashboard-bg.webp')",
            backgroundSize: "cover",
            backgroundPosition: "center",
          }}
        >
          {/* Glass overlay */}
          <div className="absolute inset-0 bg-white/40 dark:bg-black/60 backdrop-blur-xl"></div>

          <div className="relative z-10">
            <button className="w-full mb-8 py-3 rounded-2xl bg-white/60 dark:bg-white/10 backdrop-blur shadow border border-white/40 dark:border-white/10 hover:scale-[1.02] transition">
              Quick Create
            </button>

            <nav className="space-y-2">
              <a className="block py-2 px-4 rounded-xl bg-white/30 dark:bg-white/10 border border-white/30 hover:bg-white/50 hover:-translate-y-[2px] transition" href="#">Manage Users</a>
              <button
                type="button"
                className="block w-full text-left py-2 px-4 rounded-xl bg-white/30 dark:bg-white/10 border border-white/30 hover:bg-white/50 hover:-translate-y-[2px] transition"
                onClick={() => router.push("/admin-dashboard/busRegister")}
              >Manage Buses</button>

              <button
                type="button"
                className="block w-full text-left py-2 px-4 rounded-xl bg-white/30 dark:bg-white/10 border border-white/30 hover:bg-white/50 hover:-translate-y-[2px] transition"
                onClick={() => router.push("/create-route")}
              >Manage Routes</button>

               <button
                type="button"
                className="block w-full text-left py-2 px-4 rounded-xl bg-white/30 dark:bg-white/10 border border-white/30 hover:bg-white/50 hover:-translate-y-[2px] transition"
                onClick={() => router.push("/admin-dashboard/permit")}
              >Manage Permit</button>
              <a className="block py-2 px-4 rounded-xl bg-white/30 dark:bg-white/10 border border-white/30 hover:bg-white/50 hover:-translate-y-[2px] transition" href="#">Reports</a>
              <a className="block py-2 px-4 rounded-xl bg-white/30 dark:bg-white/10 border border-white/30 hover:bg-white/50 hover:-translate-y-[2px] transition" href="#">Quick Actions</a>
            </nav>

            <div className="mt-10 text-sm opacity-80">
              <div>Admin</div>
              <div>hello@admin.com</div>
            </div>
          </div>
        </aside>

        {/* Main */}
        <main className="flex-1 p-10">

          {/* Summary Cards */}
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-10">
            {summaryCards.map((card) => (
              <div
                key={card.title}
                className="rounded-3xl p-8 shadow-xl bg-white/60 dark:bg-white/10 backdrop-blur-xl border border-white/40 dark:border-white/10 hover:scale-[1.02] hover:shadow-2xl transition"
              >
                <h2 className="text-lg font-semibold opacity-90">
                  {card.title}
                </h2>
                <div className="text-4xl font-bold mt-2">{card.value}</div>
                <div className="mt-1 text-emerald-500">{card.trend}</div>
              </div>
            ))}
          </div>

          {/* Chart Placeholder */}
          <div className="rounded-3xl p-10 shadow-xl bg-white/60 dark:bg-white/10 backdrop-blur-xl border border-white/40 dark:border-white/10 mb-10">
            <h2 className="text-xl font-semibold mb-4">Total Visitors</h2>
            <div className="h-44 flex items-center justify-center opacity-60">
              [Chart Placeholder]
            </div>
          </div>

          {/* Quick Actions */}
          <section className="rounded-3xl p-10 shadow-xl bg-white/60 dark:bg-white/10 backdrop-blur-xl border border-white/40 dark:border-white/10 mb-10">
            <h2 className="text-xl font-semibold mb-4">Quick Actions</h2>
            <ul className="list-disc pl-5 space-y-2">
              {quickActions.map((action) => (
                <li key={action}>{action}</li>
              ))}
            </ul>
          </section>
       

         

        </main>
      </div>
    </div>
  );
}

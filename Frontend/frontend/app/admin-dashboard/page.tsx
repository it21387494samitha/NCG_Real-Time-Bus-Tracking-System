
import React, { useState } from 'react';

const summaryCards = [
  { title: 'Total Users', value: '1,234', trend: '+5%' },
  { title: 'Total Buses', value: '56', trend: '+2%' },
  { title: 'Reports', value: '12', trend: '+8%' },
];

const quickActions = [
  'Add User',
  'Register Bus',
  'Download Report',
];

export default function AdminDashboard() {
  const [darkMode, setDarkMode] = useState(false);

  return (
    <div className={darkMode ? 'dark bg-gray-900 text-white min-h-screen' : 'bg-gray-100 text-gray-900 min-h-screen'}>
      {/* Top Bar */}
      <header className="flex items-center justify-between px-10 py-5 bg-white dark:bg-gray-900 shadow-sm rounded-b-xl border-b border-gray-200 dark:border-gray-800">
        <h1 className="text-2xl font-bold tracking-tight">Studio Admin</h1>
        <div className="flex items-center gap-4">
          <input type="text" placeholder="Search..." className="px-3 py-2 rounded-lg bg-gray-100 dark:bg-gray-800 dark:text-white border border-gray-200 dark:border-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500" />
          <button
            onClick={() => setDarkMode(!darkMode)}
            className="px-3 py-2 rounded-lg bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-white border border-gray-300 dark:border-gray-600 hover:bg-gray-300 dark:hover:bg-gray-600 transition"
            aria-label="Toggle theme"
          >
            {darkMode ? '🌙' : '☀️'}
          </button>
          <div className="w-9 h-9 rounded-full bg-gray-300 dark:bg-gray-700 flex items-center justify-center font-bold text-lg border border-gray-400 dark:border-gray-600">A</div>
        </div>
      </header>

      {/* Layout */}
      <div className="flex">
        {/* Sidebar */}
        <aside className="w-72 bg-white dark:bg-gray-950 border-r border-gray-200 dark:border-gray-800 min-h-screen p-8 flex flex-col justify-between shadow-sm rounded-r-xl">
          <div>
            <button className="w-full mb-8 py-2 px-4 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-semibold shadow">Quick Create</button>
            <nav className="space-y-2">
              <a href="#users" className="block py-2 px-4 rounded-lg font-medium hover:bg-gray-100 dark:hover:bg-gray-800 transition">Manage Users</a>
              <a href="#buses" className="block py-2 px-4 rounded-lg font-medium hover:bg-gray-100 dark:hover:bg-gray-800 transition">Manage Buses</a>
              <a href="#reports" className="block py-2 px-4 rounded-lg font-medium hover:bg-gray-100 dark:hover:bg-gray-800 transition">Reports</a>
              <a href="#quick-actions" className="block py-2 px-4 rounded-lg font-medium hover:bg-gray-100 dark:hover:bg-gray-800 transition">Quick Actions</a>
            </nav>
          </div>
          <div className="mt-10 text-xs text-gray-500 dark:text-gray-400">
            <div className="font-bold text-base text-gray-700 dark:text-gray-200 mb-1">Admin</div>
            <div className="mt-1">hello@admin.com</div>
          </div>
        </aside>

        {/* Main Content */}
        <main className="flex-1 p-10">
          {/* Summary Cards */}
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-10">
            {summaryCards.map(card => (
              <div key={card.title} className="bg-white dark:bg-gray-900 rounded-2xl shadow-md p-8 flex flex-col justify-between border border-gray-100 dark:border-gray-800">
                <h2 className="text-lg font-semibold mb-2 text-gray-700 dark:text-gray-200">{card.title}</h2>
                <div className="text-4xl font-bold mb-1">{card.value}</div>
                <div className="text-green-500 font-medium">{card.trend}</div>
              </div>
            ))}
          </div>

          {/* Placeholder for Chart */}
          <div className="bg-white dark:bg-gray-900 rounded-2xl shadow-md p-8 mb-10 border border-gray-100 dark:border-gray-800">
            <h2 className="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-200">Total Visitors</h2>
            <div className="h-40 flex items-center justify-center text-gray-400 dark:text-gray-600">[Chart Placeholder]</div>
          </div>

          {/* Quick Actions */}
          <section id="quick-actions" className="bg-white dark:bg-gray-900 rounded-2xl shadow-md p-8 mb-10 border border-gray-100 dark:border-gray-800">
            <h2 className="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-200">Quick Actions</h2>
            <ul className="list-disc pl-5 space-y-2">
              {quickActions.map(action => (
                <li key={action} className="text-base">{action}</li>
              ))}
            </ul>
          </section>

          {/* Tables for Users, Buses, Reports */}
          <section id="users" className="mb-10">
            <h2 className="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-200">Manage Users</h2>
            <div className="bg-white dark:bg-gray-900 rounded-2xl shadow-md p-8 border border-gray-100 dark:border-gray-800">[Users Table Placeholder]</div>
          </section>
          <section id="buses" className="mb-10">
            <h2 className="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-200">Manage Buses</h2>
            <div className="bg-white dark:bg-gray-900 rounded-2xl shadow-md p-8 border border-gray-100 dark:border-gray-800">[Buses Table Placeholder]</div>
          </section>
          <section id="reports" className="mb-10">
            <h2 className="text-xl font-semibold mb-4 text-gray-700 dark:text-gray-200">Reports</h2>
            <div className="bg-white dark:bg-gray-900 rounded-2xl shadow-md p-8 border border-gray-100 dark:border-gray-800">[Reports Table Placeholder]</div>
          </section>
        </main>
      </div>
    </div>
  );
}

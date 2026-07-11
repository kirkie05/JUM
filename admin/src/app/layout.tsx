import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

import { Sidebar } from "@/components/Sidebar";

export const metadata: Metadata = {
  title: "JUM Admin Dashboard",
  description: "Management Console for Jesus Unhindered Ministry",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex bg-gray-50 text-gray-900">
        <Sidebar />
        <main className="flex-1 p-8 overflow-auto">
          {children}
        </main>
      </body>
    </html>
  );
}

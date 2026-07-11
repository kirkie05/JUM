import Link from 'next/link';

export function Sidebar() {
  return (
    <aside className="w-64 bg-gray-900 text-white min-h-screen p-4 flex flex-col">
      <h1 className="text-2xl font-bold mb-8 text-center tracking-tight">JUM Admin</h1>
      <nav className="flex-1 space-y-2">
        <Link href="/" className="block py-2 px-4 rounded hover:bg-gray-800 transition">Dashboard</Link>
        <Link href="/users" className="block py-2 px-4 rounded hover:bg-gray-800 transition">Members</Link>
        <Link href="/sermons" className="block py-2 px-4 rounded hover:bg-gray-800 transition">Sermons</Link>
        <Link href="/live" className="block py-2 px-4 rounded hover:bg-gray-800 transition">Live Streams</Link>
        <Link href="/events" className="block py-2 px-4 rounded hover:bg-gray-800 transition">Events</Link>
        <Link href="/courses" className="block py-2 px-4 rounded hover:bg-gray-800 transition">School (LMS)</Link>
        <Link href="/giving" className="block py-2 px-4 rounded hover:bg-gray-800 transition">Financials</Link>
      </nav>
      <div className="pt-4 border-t border-gray-700">
        <button className="w-full text-left py-2 px-4 rounded hover:bg-red-600 transition">Sign Out</button>
      </div>
    </aside>
  );
}

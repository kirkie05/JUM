export default function Dashboard() {
  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center border-b pb-4">
        <h1 className="text-3xl font-semibold">Dashboard Overview</h1>
        <button className="bg-blue-600 text-white px-4 py-2 rounded shadow hover:bg-blue-700">Export Report</button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-lg shadow border">
          <h3 className="text-gray-500 text-sm font-medium">Total Members</h3>
          <p className="text-3xl font-bold mt-2">1,240</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow border">
          <h3 className="text-gray-500 text-sm font-medium">Sermons</h3>
          <p className="text-3xl font-bold mt-2">142</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow border">
          <h3 className="text-gray-500 text-sm font-medium">Active Courses</h3>
          <p className="text-3xl font-bold mt-2">8</p>
        </div>
        <div className="bg-white p-6 rounded-lg shadow border">
          <h3 className="text-gray-500 text-sm font-medium">Total Giving (MTD)</h3>
          <p className="text-3xl font-bold mt-2">₦ 450,000</p>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow border mt-8">
        <div className="p-6 border-b">
          <h2 className="text-xl font-semibold">Recent Activity</h2>
        </div>
        <div className="p-6 text-gray-500 text-sm text-center">
          Activity feed will be populated from the backend API.
        </div>
      </div>
    </div>
  );
}

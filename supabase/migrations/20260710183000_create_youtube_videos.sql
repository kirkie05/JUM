-- Create youtube_videos table for public caching of YouTube channel uploads
CREATE TABLE IF NOT EXISTS youtube_videos (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  thumbnail_url TEXT,
  duration TEXT,
  published_at TIMESTAMPTZ,
  view_count BIGINT,
  source_name TEXT,
  source_url TEXT,
  is_live BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE youtube_videos ENABLE ROW LEVEL SECURITY;

-- Add RLS Policies
CREATE POLICY "Allow anyone to read youtube_videos" ON youtube_videos FOR SELECT USING (true);
CREATE POLICY "Allow anyone to insert youtube_videos" ON youtube_videos FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anyone to update youtube_videos" ON youtube_videos FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "Allow anyone to delete youtube_videos" ON youtube_videos FOR DELETE USING (true);

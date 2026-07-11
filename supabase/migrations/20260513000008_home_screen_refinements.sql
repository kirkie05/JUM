-- Home Screen Refinements Migration
-- Add first_name to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS first_name TEXT;

-- Add youtube_video_id and published_at to sermons
ALTER TABLE sermons ADD COLUMN IF NOT EXISTS youtube_video_id TEXT;
ALTER TABLE sermons ADD COLUMN IF NOT EXISTS published_at TIMESTAMPTZ;

-- Add start_time, end_time, is_published to events
ALTER TABLE events ADD COLUMN IF NOT EXISTS start_time TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS end_time TEXT;
ALTER TABLE events ADD COLUMN IF NOT EXISTS is_published BOOLEAN NOT NULL DEFAULT false;

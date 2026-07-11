-- Create media_notes table to store video/media comments and notes
CREATE TABLE IF NOT EXISTS public.media_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  video_id TEXT NOT NULL,
  timestamp_seconds INTEGER NOT NULL,
  text TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.media_notes ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can manage own media notes" 
  ON public.media_notes
  FOR ALL
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

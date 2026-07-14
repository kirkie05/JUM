-- Add updated_at column to public.media_notes
ALTER TABLE public.media_notes 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Trigger to update updated_at automatically on update
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_media_notes_updated_at ON public.media_notes;
CREATE TRIGGER set_media_notes_updated_at
  BEFORE UPDATE ON public.media_notes
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

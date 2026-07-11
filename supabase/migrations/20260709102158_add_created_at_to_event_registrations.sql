-- Add created_at column to event_registrations
ALTER TABLE public.event_registrations ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Backfill existing rows (if any)
UPDATE public.event_registrations SET created_at = registered_at WHERE created_at IS NULL;

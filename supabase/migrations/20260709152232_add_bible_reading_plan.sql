-- 1. Reading Plans Table
CREATE TABLE IF NOT EXISTS public.reading_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    duration_days INT NOT NULL DEFAULT 365,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Plan Days Table
CREATE TABLE IF NOT EXISTS public.plan_days (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    plan_id UUID NOT NULL REFERENCES public.reading_plans(id) ON DELETE CASCADE,
    day_number INT NOT NULL,
    title TEXT NOT NULL,
    readings JSONB NOT NULL DEFAULT '[]'::jsonb,
    estimated_reading_time INT NOT NULL DEFAULT 10,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(plan_id, day_number)
);

-- 3. User Reading Progress Table
CREATE TABLE IF NOT EXISTS public.user_reading_progress (
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    day_number INT NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT true,
    completed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    reading_duration INT NOT NULL DEFAULT 0,
    progress_percentage NUMERIC NOT NULL DEFAULT 100.0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, day_number)
);

-- 4. Reading Streaks Table
CREATE TABLE IF NOT EXISTS public.reading_streaks (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    current_streak INT NOT NULL DEFAULT 0,
    longest_streak INT NOT NULL DEFAULT 0,
    last_read_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 5. Bible Notes Table
CREATE TABLE IF NOT EXISTS public.bible_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    book_id TEXT NOT NULL,
    chapter INT NOT NULL,
    verse INT NOT NULL,
    title TEXT,
    body TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 6. Bible Bookmarks Table
CREATE TABLE IF NOT EXISTS public.bible_bookmarks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    book_id TEXT NOT NULL,
    chapter INT NOT NULL,
    verse INT NOT NULL,
    type TEXT NOT NULL,
    color TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.reading_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.plan_days ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_reading_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reading_streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bible_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bible_bookmarks ENABLE ROW LEVEL SECURITY;

-- Policies for public reading plans and days
CREATE POLICY "Allow public select on reading_plans" ON public.reading_plans FOR SELECT USING (true);
CREATE POLICY "Allow admin write on reading_plans" ON public.reading_plans FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow public select on plan_days" ON public.plan_days FOR SELECT USING (true);
CREATE POLICY "Allow admin write on plan_days" ON public.plan_days FOR ALL USING (auth.role() = 'authenticated');

-- Policies for user reading progress
CREATE POLICY "Allow owner select on user_reading_progress" ON public.user_reading_progress FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Allow owner insert on user_reading_progress" ON public.user_reading_progress FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Allow owner update on user_reading_progress" ON public.user_reading_progress FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Allow owner delete on user_reading_progress" ON public.user_reading_progress FOR DELETE USING (auth.uid() = user_id);

-- Policies for reading streaks
CREATE POLICY "Allow owner select on reading_streaks" ON public.reading_streaks FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Allow owner insert on reading_streaks" ON public.reading_streaks FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Allow owner update on reading_streaks" ON public.reading_streaks FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Allow owner delete on reading_streaks" ON public.reading_streaks FOR DELETE USING (auth.uid() = user_id);

-- Policies for bible notes
CREATE POLICY "Allow owner select on bible_notes" ON public.bible_notes FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Allow owner insert on bible_notes" ON public.bible_notes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Allow owner update on bible_notes" ON public.bible_notes FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Allow owner delete on bible_notes" ON public.bible_notes FOR DELETE USING (auth.uid() = user_id);

-- Policies for bible bookmarks
CREATE POLICY "Allow owner select on bible_bookmarks" ON public.bible_bookmarks FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Allow owner insert on bible_bookmarks" ON public.bible_bookmarks FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Allow owner update on bible_bookmarks" ON public.bible_bookmarks FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Allow owner delete on bible_bookmarks" ON public.bible_bookmarks FOR DELETE USING (auth.uid() = user_id);

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.user_reading_progress;
ALTER PUBLICATION supabase_realtime ADD TABLE public.reading_streaks;
ALTER PUBLICATION supabase_realtime ADD TABLE public.bible_notes;
ALTER PUBLICATION supabase_realtime ADD TABLE public.bible_bookmarks;

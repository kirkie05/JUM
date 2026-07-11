-- ============================================================
-- JUM Backend Schema v3
-- Migration 009: Schema Reconciliation and Mismatches Fix
-- ============================================================

-- ── 1. PROFILES TABLE ADJUSTMENTS ────────────────────────────
-- Add full_name column
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS full_name TEXT;

-- Update existing profiles to set full_name = name
UPDATE public.profiles SET full_name = name WHERE full_name IS NULL;

-- ── 2. DONATIONS TABLE ADJUSTMENTS ───────────────────────────
-- Add gateway column
ALTER TABLE public.donations ADD COLUMN IF NOT EXISTS gateway TEXT;

-- Update existing donations status or set a default gateway
UPDATE public.donations SET gateway = 'stripe' WHERE gateway IS NULL;

-- ── 3. GOSPEL ARMY (COURSES & LESSONS) ADJUSTMENTS ───────────
-- Add is_published to courses
ALTER TABLE public.courses ADD COLUMN IF NOT EXISTS is_published BOOLEAN NOT NULL DEFAULT false;

-- Add sort_order to lessons
ALTER TABLE public.lessons ADD COLUMN IF NOT EXISTS sort_order INT NOT NULL DEFAULT 0;

-- ── 4. QUIZ QUESTIONS & ATTEMPTS TABLES ──────────────────────
-- Create quiz_questions
CREATE TABLE IF NOT EXISTS public.quiz_questions (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id      UUID        NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  question       TEXT        NOT NULL,
  options        TEXT[]      NOT NULL,
  correct_index  INT         NOT NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create quiz_attempts
CREATE TABLE IF NOT EXISTS public.quiz_attempts (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  lesson_id     UUID        NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  score         INT         NOT NULL,
  submitted_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 5. ENABLE ROW LEVEL SECURITY (RLS) ───────────────────────
ALTER TABLE public.quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;

-- ── 6. RLS POLICIES FOR NEW TABLES ───────────────────────────
DROP POLICY IF EXISTS "Quiz questions viewable by enrolled" ON public.quiz_questions;
CREATE POLICY "Quiz questions viewable by enrolled" ON public.quiz_questions FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM public.lessons 
    JOIN public.enrollments ON lessons.course_id = enrollments.course_id 
    WHERE lessons.id = quiz_questions.lesson_id AND enrollments.user_id = auth.uid()
  ) OR public.is_admin()
);

DROP POLICY IF EXISTS "Admins manage quiz questions" ON public.quiz_questions;
CREATE POLICY "Admins manage quiz questions" ON public.quiz_questions FOR ALL USING (
  public.is_admin()
) WITH CHECK (
  public.is_admin()
);

DROP POLICY IF EXISTS "Users manage own attempts" ON public.quiz_attempts;
CREATE POLICY "Users manage own attempts" ON public.quiz_attempts FOR ALL USING (
  user_id = auth.uid()
) WITH CHECK (
  user_id = auth.uid()
);

-- ── 7. UPDATE USER SIGNUP TRIGGER ────────────────────────────
-- Make sure future signups get both name and full_name populated
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  displayName TEXT;
BEGIN
  displayName := COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name', 'New Member');
  INSERT INTO public.profiles (id, name, full_name, email, role)
  VALUES (
    NEW.id,
    displayName,
    displayName,
    NEW.email,
    'member'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

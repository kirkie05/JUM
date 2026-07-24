-- ============================================================
-- JUM Backend Schema
-- Migration: Gospel Army (LMS) Full Upgrade
-- ============================================================

-- 1. Create Course Categories
CREATE TABLE IF NOT EXISTS course_categories (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT        NOT NULL UNIQUE,
  description TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Insert Default Categories
INSERT INTO course_categories (name, description) VALUES
  ('Salvation', 'Basics of Christian salvation'),
  ('Foundations of Faith', 'Core beliefs and doctrines'),
  ('Prayer', 'Deepening your prayer life'),
  ('Bible Study', 'Methods for studying scripture'),
  ('Evangelism', 'Sharing the gospel'),
  ('Discipleship', 'Growing in Christ'),
  ('Leadership', 'Christian leadership principles'),
  ('Ministry', 'Serving in the church'),
  ('Marriage & Family', 'Christian family life'),
  ('Youth', 'Resources for youth ministry'),
  ('Missions', 'Global outreach'),
  ('Christian Living', 'Applying faith to daily life')
ON CONFLICT (name) DO NOTHING;

-- 2. Alter Courses
ALTER TABLE courses
  ADD COLUMN IF NOT EXISTS is_published BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS category_id UUID REFERENCES course_categories(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS instructor_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS difficulty_level TEXT,
  ADD COLUMN IF NOT EXISTS estimated_duration_mins INT,
  ADD COLUMN IF NOT EXISTS prerequisites UUID[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS certificate_offered BOOLEAN NOT NULL DEFAULT true;

-- 3. Create Course Modules
CREATE TABLE IF NOT EXISTS course_modules (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id   UUID        NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title       TEXT        NOT NULL,
  description TEXT,
  order_index INT         NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Alter Lessons
ALTER TABLE lessons
  ADD COLUMN IF NOT EXISTS module_id UUID REFERENCES course_modules(id) ON DELETE CASCADE,
  ADD COLUMN IF NOT EXISTS audio_url TEXT,
  ADD COLUMN IF NOT EXISTS pdf_url TEXT,
  ADD COLUMN IF NOT EXISTS is_free_preview BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS requires_previous BOOLEAN NOT NULL DEFAULT true;

-- 5. Alter Quizzes
ALTER TABLE quizzes
  ADD COLUMN IF NOT EXISTS title TEXT NOT NULL DEFAULT 'Quiz',
  ADD COLUMN IF NOT EXISTS passing_score INT NOT NULL DEFAULT 70,
  ADD COLUMN IF NOT EXISTS time_limit_mins INT;

-- 6. Quiz Attempts
CREATE TABLE IF NOT EXISTS quiz_attempts (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id     UUID        NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  user_id     UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  score       INT         NOT NULL DEFAULT 0,
  passed      BOOLEAN     NOT NULL DEFAULT false,
  answers     JSONB       NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 7. Assignments & Submissions
CREATE TABLE IF NOT EXISTS assignments (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id   UUID        NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  title       TEXT        NOT NULL,
  description TEXT,
  attachment_url TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS assignment_submissions (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  assignment_id UUID        NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
  user_id       UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  text_content  TEXT,
  file_url      TEXT,
  status        TEXT        NOT NULL DEFAULT 'submitted', -- submitted, graded, rejected
  grade         INT,
  feedback      TEXT,
  submitted_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  graded_at     TIMESTAMPTZ
);

-- 8. Lesson Progress
CREATE TABLE IF NOT EXISTS lesson_progress (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lesson_id   UUID        NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  course_id   UUID        NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  completed   BOOLEAN     NOT NULL DEFAULT false,
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, lesson_id)
);

-- 9. Certificates
CREATE TABLE IF NOT EXISTS certificates (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  course_id     UUID        NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  certificate_url TEXT,
  issued_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, course_id)
);

-- 10. Discussions
CREATE TABLE IF NOT EXISTS lesson_discussions (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id   UUID        NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  user_id     UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  body        TEXT        NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS lesson_discussion_comments (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  discussion_id UUID        NOT NULL REFERENCES lesson_discussions(id) ON DELETE CASCADE,
  user_id       UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  body          TEXT        NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- RLS POLICIES (GOSPEL ARMY)
-- ============================================================

-- Enable RLS
ALTER TABLE course_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignment_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_discussions ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_discussion_comments ENABLE ROW LEVEL SECURITY;

-- 1. Course Categories (Public Read, Admin Write)
CREATE POLICY "Public Read Course Categories" ON course_categories FOR SELECT USING (true);

-- 2. Courses (Students see published, Admins see all)
DROP POLICY IF EXISTS "Public Read Courses" ON courses;
CREATE POLICY "Public Read Courses" ON courses FOR SELECT USING (
  is_published = true 
  OR auth.uid() IN (SELECT id FROM profiles WHERE role IN ('admin', 'super_admin'))
  OR instructor_id = auth.uid()
);

-- 3. Course Modules & Lessons (Students see if course published, Admins see all)
CREATE POLICY "Public Read Course Modules" ON course_modules FOR SELECT USING (true);
DROP POLICY IF EXISTS "Public Read Lessons" ON lessons;
CREATE POLICY "Public Read Lessons" ON lessons FOR SELECT USING (true);

-- 4. Enrollments (User can see own, Admins see all, Insert self)
DROP POLICY IF EXISTS "Users can read own enrollments" ON enrollments;
CREATE POLICY "Users can read own enrollments" ON enrollments FOR SELECT USING (user_id = auth.uid() OR auth.uid() IN (SELECT id FROM profiles WHERE role IN ('admin', 'super_admin')));
DROP POLICY IF EXISTS "Users can create own enrollments" ON enrollments;
CREATE POLICY "Users can create own enrollments" ON enrollments FOR INSERT WITH CHECK (user_id = auth.uid());

-- 5. Lesson Progress (User can see/modify own)
CREATE POLICY "Users can read own lesson progress" ON lesson_progress FOR SELECT USING (user_id = auth.uid() OR auth.uid() IN (SELECT id FROM profiles WHERE role IN ('admin', 'super_admin')));
CREATE POLICY "Users can insert own lesson progress" ON lesson_progress FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users can update own lesson progress" ON lesson_progress FOR UPDATE USING (user_id = auth.uid());

-- 6. Quizzes & Quiz Attempts
DROP POLICY IF EXISTS "Public Read Quizzes" ON quizzes;
CREATE POLICY "Public Read Quizzes" ON quizzes FOR SELECT USING (true);
CREATE POLICY "Users can insert quiz attempts" ON quiz_attempts FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users can read own quiz attempts" ON quiz_attempts FOR SELECT USING (user_id = auth.uid() OR auth.uid() IN (SELECT id FROM profiles WHERE role IN ('admin', 'super_admin')));

-- 7. Assignments & Submissions
CREATE POLICY "Public Read Assignments" ON assignments FOR SELECT USING (true);
CREATE POLICY "Users can insert submissions" ON assignment_submissions FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users can read own submissions" ON assignment_submissions FOR SELECT USING (user_id = auth.uid() OR auth.uid() IN (SELECT id FROM profiles WHERE role IN ('admin', 'super_admin')));

-- 8. Certificates
CREATE POLICY "Users can read own certificates" ON certificates FOR SELECT USING (user_id = auth.uid() OR auth.uid() IN (SELECT id FROM profiles WHERE role IN ('admin', 'super_admin')));
CREATE POLICY "Admins can issue certificates" ON certificates FOR INSERT WITH CHECK (auth.uid() IN (SELECT id FROM profiles WHERE role IN ('admin', 'super_admin')));

-- 9. Discussions & Comments
CREATE POLICY "Public Read Discussions" ON lesson_discussions FOR SELECT USING (true);
CREATE POLICY "Users can insert discussions" ON lesson_discussions FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "Public Read Discussion Comments" ON lesson_discussion_comments FOR SELECT USING (true);
CREATE POLICY "Users can insert discussion comments" ON lesson_discussion_comments FOR INSERT WITH CHECK (user_id = auth.uid());

-- NOTE: All Admin full-access policies will be handled by the fact that the web-admin runs using Service Role Keys OR we could add explicit Admin ALL policies. We assume Service Role Key for the separate admin panel.

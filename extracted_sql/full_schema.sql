-- ============================================================
-- JUM Backend Schema v2 — Single Church Edition
-- Migration 001: Extensions
-- ============================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- webhook HMAC verification
CREATE EXTENSION IF NOT EXISTS "pg_trgm";    -- trigram search on sermons/posts
-- ============================================================
-- JUM Backend Schema v2 — Single Church Edition
-- Migration 002: All Tables
--
-- NO churches table. NO church_id on every row.
-- This is the app for Jesus Unhindered Ministry only.
-- All RLS is based on user role, not church membership.
-- ============================================================

-- ── 1. USERS ─────────────────────────────────────────────────
-- All members of Jesus Unhindered Ministry.
-- clerk_id is the link to the Clerk auth identity.
-- role controls what each user can see and do.
CREATE TABLE users (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  clerk_id    TEXT        NOT NULL UNIQUE,
  name        TEXT        NOT NULL DEFAULT '',
  email       TEXT        NOT NULL,
  phone       TEXT,
  role        TEXT        NOT NULL DEFAULT 'member'
              CHECK (role IN ('admin','leader','member')),
  avatar_url  TEXT,
  bio         TEXT        CHECK (char_length(bio) <= 160),
  department  TEXT,       -- e.g. "Worship", "Ushers", "Youth"
  joined_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- Roles:
--   admin   → full access (pastor / church admin)
--   leader  → cell leaders, unit heads — sees member list, forms inbox
--   member  → standard congregation member

-- ── 2. SERMONS ───────────────────────────────────────────────
-- JUM sermon archive — audio and video.
CREATE TABLE sermons (
  id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  title            TEXT        NOT NULL,
  description      TEXT,
  speaker          TEXT        NOT NULL DEFAULT 'Pastor',
  series           TEXT,       -- sermon series grouping
  media_url        TEXT        NOT NULL,
  thumbnail_url    TEXT,
  type             TEXT        NOT NULL CHECK (type IN ('audio','video')),
  duration_seconds INT,
  published_at     TIMESTAMPTZ DEFAULT NOW(),  -- NULL = draft, not visible to members
  created_by       UUID        REFERENCES users(id) ON DELETE SET NULL
);

-- ── 3. SERMON NOTES ──────────────────────────────────────────
-- Personal notes a member takes during a sermon.
CREATE TABLE sermon_notes (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  sermon_id   UUID        NOT NULL REFERENCES sermons(id) ON DELETE CASCADE,
  content     TEXT        NOT NULL DEFAULT '',
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, sermon_id)
);

-- ── 4. COMMUNITY: Posts, Likes, Comments ─────────────────────
-- The social/community feed for JUM members.
CREATE TABLE posts (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  body        TEXT        NOT NULL
              CHECK (char_length(body) > 0 AND char_length(body) <= 2000),
  media_url   TEXT,
  media_type  TEXT        CHECK (media_type IN ('image','video')),
  likes_count INT         NOT NULL DEFAULT 0,  -- maintained by trigger
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE post_likes (
  post_id  UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  PRIMARY KEY (post_id, user_id)
);

CREATE TABLE comments (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id     UUID        NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  body        TEXT        NOT NULL
              CHECK (char_length(body) > 0 AND char_length(body) <= 500),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 5. GROUPS ────────────────────────────────────────────────
-- JUM internal groups: cells, departments, prayer groups, etc.
CREATE TABLE groups (
  id           UUID    PRIMARY KEY DEFAULT uuid_generate_v4(),
  name         TEXT    NOT NULL,
  description  TEXT,
  is_private   BOOL    NOT NULL DEFAULT false,  -- private = invite only
  cover_url    TEXT,
  created_by   UUID    REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE group_members (
  group_id  UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  user_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role      TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('admin','member')),
  joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (group_id, user_id)
);

-- ── 6. MESSAGING ─────────────────────────────────────────────
-- 1:1 and group chat between members.
CREATE TABLE messages (
  id           UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id    UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  receiver_id  UUID        REFERENCES users(id) ON DELETE SET NULL,  -- 1:1 only
  group_id     UUID        REFERENCES groups(id) ON DELETE CASCADE,   -- group only
  body         TEXT        NOT NULL CHECK (char_length(body) > 0),
  read_at      TIMESTAMPTZ,   -- NULL = unread
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- Exactly one destination: either receiver_id or group_id, never both
  CONSTRAINT chk_message_recipient CHECK (
    (receiver_id IS NOT NULL AND group_id IS NULL) OR
    (receiver_id IS NULL     AND group_id IS NOT NULL)
  )
);

-- ── 7. LIVE STREAMS ──────────────────────────────────────────
-- JUM Sunday services and special broadcasts via Mux.
CREATE TABLE live_streams (
  id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  mux_stream_id    TEXT,       -- Mux RTMP stream key (set by admin)
  mux_playback_id  TEXT,       -- Mux HLS playback ID
  title            TEXT        NOT NULL,
  description      TEXT,
  status           TEXT        NOT NULL DEFAULT 'idle'
                   CHECK (status IN ('idle','active','ended')),
  scheduled_at     TIMESTAMPTZ,
  ended_at         TIMESTAMPTZ,
  created_by       UUID        REFERENCES users(id) ON DELETE SET NULL
);

-- Live chat messages during a stream
CREATE TABLE stream_messages (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  stream_id   UUID        NOT NULL REFERENCES live_streams(id) ON DELETE CASCADE,
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  body        TEXT        NOT NULL
              CHECK (char_length(body) > 0 AND char_length(body) <= 300),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 8. EVENTS ────────────────────────────────────────────────
-- JUM events: conferences, socials, prayer nights, etc.
CREATE TABLE events (
  id            UUID           PRIMARY KEY DEFAULT uuid_generate_v4(),
  title         TEXT           NOT NULL,
  description   TEXT,
  date          TIMESTAMPTZ    NOT NULL,
  end_date      TIMESTAMPTZ,
  location      TEXT,
  cover_url     TEXT,
  is_paid       BOOL           NOT NULL DEFAULT false,
  ticket_price  NUMERIC(12,2),
  created_by    UUID           REFERENCES users(id) ON DELETE SET NULL
);

-- Member RSVPs with QR ticket codes
CREATE TABLE rsvps (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  event_id    UUID        NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  qr_code     TEXT        NOT NULL UNIQUE,   -- "JUM-{eventId}-{userId}-{uuid}"
  checked_in  BOOL        NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, event_id)
);

-- ── 9. PASTORAL FORMS ────────────────────────────────────────
-- Salvation decisions, visitor cards, prayer requests, testimonies.
-- All routed to a leader for follow-up.
CREATE TABLE forms (
  id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  type          TEXT        NOT NULL
                CHECK (type IN ('salvation','visitor','prayer','testimony')),
  data_json     JSONB       NOT NULL DEFAULT '{}',  -- flexible per form type
  submitted_by  UUID        REFERENCES users(id) ON DELETE SET NULL,  -- nullable = anonymous
  assigned_to   UUID        REFERENCES users(id) ON DELETE SET NULL,  -- auto-assigned leader
  status        TEXT        NOT NULL DEFAULT 'new'
                CHECK (status IN ('new','in_progress','done')),
  notes         TEXT,       -- pastoral follow-up notes
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 10. GIVING ───────────────────────────────────────────────
-- Tithes, offerings, donations, and seeds via Paystack (Nigeria) + Stripe (global).
CREATE TABLE giving_transactions (
  id          UUID           PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID           NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount      NUMERIC(12,2)  NOT NULL CHECK (amount > 0),
  currency    TEXT           NOT NULL DEFAULT 'NGN',
  category    TEXT           NOT NULL
              CHECK (category IN ('tithe','offering','donation','seed')),
  gateway     TEXT           NOT NULL CHECK (gateway IN ('paystack','stripe')),
  reference   TEXT           NOT NULL UNIQUE,  -- gateway transaction ID (idempotency key)
  status      TEXT           NOT NULL DEFAULT 'pending'
              CHECK (status IN ('pending','paid','failed','refunded')),
  receipt_url TEXT,          -- Supabase Storage URL to generated PDF receipt
  created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

-- ── 11. GOSPEL ARMY SCHOOL (LMS) ─────────────────────────────
-- JUM's internal discipleship school.
CREATE TABLE courses (
  id            UUID  PRIMARY KEY DEFAULT uuid_generate_v4(),
  title         TEXT  NOT NULL,
  description   TEXT,
  cover_url     TEXT,
  is_published  BOOL  NOT NULL DEFAULT false,  -- false = draft, hidden from members
  created_by    UUID  REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE lessons (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id        UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title            TEXT NOT NULL,
  video_url        TEXT,
  pdf_url          TEXT,
  duration_seconds INT,
  sort_order       INT  NOT NULL DEFAULT 0  -- ORDER BY sort_order ASC always
);

CREATE TABLE enrollments (
  id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id          UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id        UUID        NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  progress_percent INT         NOT NULL DEFAULT 0
                   CHECK (progress_percent BETWEEN 0 AND 100),
  completed_at     TIMESTAMPTZ,  -- set automatically when progress_percent = 100
  UNIQUE (user_id, course_id)
);

CREATE TABLE quiz_questions (
  id             UUID  PRIMARY KEY DEFAULT uuid_generate_v4(),
  lesson_id      UUID  NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  question       TEXT  NOT NULL,
  options_json   JSONB NOT NULL,   -- ["Option A", "Option B", "Option C", "Option D"]
  correct_index  INT   NOT NULL    -- 0-based index into options_json array
);

CREATE TABLE quiz_attempts (
  id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id       UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  lesson_id     UUID        NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  score         INT         NOT NULL,  -- number of correct answers
  total         INT         NOT NULL,  -- total questions (for % calculation)
  submitted_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 12. PODCAST ──────────────────────────────────────────────
-- JUM podcast episodes (audio only).
CREATE TABLE podcast_episodes (
  id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  title            TEXT        NOT NULL,
  description      TEXT,
  audio_url        TEXT        NOT NULL,
  duration_seconds INT,
  published_at     TIMESTAMPTZ DEFAULT NOW(),  -- NULL = draft
  created_by       UUID        REFERENCES users(id) ON DELETE SET NULL
);

-- ── 13. MARKETPLACE ──────────────────────────────────────────
-- JUM bookstore / resource store: books, CDs, courses, merch.
CREATE TABLE products (
  id           UUID           PRIMARY KEY DEFAULT uuid_generate_v4(),
  title        TEXT           NOT NULL,
  description  TEXT,
  type         TEXT           NOT NULL CHECK (type IN ('digital','physical')),
  price        NUMERIC(12,2)  NOT NULL CHECK (price >= 0),
  currency     TEXT           NOT NULL DEFAULT 'NGN',
  media_url    TEXT,          -- download URL for digital products
  cover_url    TEXT,
  stock        INT,           -- NULL = unlimited (digital products)
  is_active    BOOL           NOT NULL DEFAULT true
);

CREATE TABLE orders (
  id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id       UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id    UUID        NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  stripe_pi_id  TEXT,       -- Stripe PaymentIntent ID (for global purchases)
  paystack_ref  TEXT,       -- Paystack reference (for Nigeria purchases)
  status        TEXT        NOT NULL DEFAULT 'pending'
                CHECK (status IN ('pending','paid','shipped','cancelled')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 14. NOTIFICATIONS ────────────────────────────────────────
-- In-app notification inbox, triggered by Edge Functions.
CREATE TABLE notifications (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type        TEXT        NOT NULL,  -- 'new_sermon' | 'live_starting' | 'new_event' | 'form_assigned' | 'message'
  title       TEXT        NOT NULL,
  body        TEXT,
  data_json   JSONB       DEFAULT '{}',   -- deep-link params e.g. {"sermon_id":"..."}
  read_at     TIMESTAMPTZ,               -- NULL = unread
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 15. SERVICE SCHEDULE ─────────────────────────────────────
-- JUM's recurring service times shown on the home screen.
CREATE TABLE service_schedules (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title        TEXT NOT NULL,    -- e.g. "Sunday Morning Service"
  day_of_week  INT  NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),  -- 0=Sunday
  time         TEXT NOT NULL,    -- "HH:MM" format
  location     TEXT,
  recurrence   TEXT NOT NULL DEFAULT 'weekly'
               CHECK (recurrence IN ('weekly','biweekly','monthly','once')),
  is_active    BOOL NOT NULL DEFAULT true
);

-- ── 16. ATTENDANCE ───────────────────────────────────────────
-- Track service attendance — scanned at the door or self-checked-in.
CREATE TABLE attendance (
  id           UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id      UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  schedule_id  UUID        REFERENCES service_schedules(id) ON DELETE SET NULL,
  event_id     UUID        REFERENCES events(id) ON DELETE SET NULL,
  attended_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  method       TEXT        NOT NULL DEFAULT 'qr'
               CHECK (method IN ('qr','manual','self'))
);
-- ============================================================
-- JUM Backend Schema v2 — Single Church Edition
-- Migration 003: Triggers
-- ============================================================

-- ── Trigger: auto-maintain posts.likes_count ─────────────────
-- Avoids expensive COUNT(*) on every feed load.
CREATE OR REPLACE FUNCTION fn_update_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE posts SET likes_count = likes_count + 1 WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE posts SET likes_count = GREATEST(likes_count - 1, 0) WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_likes_count
  AFTER INSERT OR DELETE ON post_likes
  FOR EACH ROW EXECUTE FUNCTION fn_update_likes_count();


-- ── Trigger: auto-set enrollment.completed_at ────────────────
-- Fires when progress_percent is updated to 100.
CREATE OR REPLACE FUNCTION fn_enrollment_completion()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.progress_percent = 100 AND (OLD.progress_percent IS NULL OR OLD.progress_percent < 100) THEN
    NEW.completed_at = NOW();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_enrollment_completion
  BEFORE UPDATE ON enrollments
  FOR EACH ROW EXECUTE FUNCTION fn_enrollment_completion();


-- ── Trigger: auto-update sermon_notes.updated_at ─────────────
CREATE OR REPLACE FUNCTION fn_touch_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_sermon_notes_updated_at
  BEFORE UPDATE ON sermon_notes
  FOR EACH ROW EXECUTE FUNCTION fn_touch_updated_at();
-- ============================================================
-- JUM Backend Schema v2 — Single Church Edition
-- Migration 004: Row Level Security
--
-- Three roles only: admin | leader | member
-- No church_id scoping — this is a single-church app.
-- All authenticated users are members of Jesus Unhindered Ministry.
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE users               ENABLE ROW LEVEL SECURITY;
ALTER TABLE sermons             ENABLE ROW LEVEL SECURITY;
ALTER TABLE sermon_notes        ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts               ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_likes          ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments            ENABLE ROW LEVEL SECURITY;
ALTER TABLE groups              ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_members       ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages            ENABLE ROW LEVEL SECURITY;
ALTER TABLE live_streams        ENABLE ROW LEVEL SECURITY;
ALTER TABLE stream_messages     ENABLE ROW LEVEL SECURITY;
ALTER TABLE events              ENABLE ROW LEVEL SECURITY;
ALTER TABLE rsvps               ENABLE ROW LEVEL SECURITY;
ALTER TABLE forms               ENABLE ROW LEVEL SECURITY;
ALTER TABLE giving_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses             ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons             ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments         ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions      ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts       ENABLE ROW LEVEL SECURITY;
ALTER TABLE podcast_episodes    ENABLE ROW LEVEL SECURITY;
ALTER TABLE products            ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders              ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications       ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_schedules   ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance          ENABLE ROW LEVEL SECURITY;

-- ────────────────────────────────────────────────────────────
-- Helper functions (SECURITY DEFINER — run as superuser,
-- bypassing RLS inside the function itself)
-- ────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION auth_uid() RETURNS UUID AS $$
  SELECT id FROM users WHERE clerk_id = (auth.uid())::text
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION auth_role() RETURNS TEXT AS $$
  SELECT role FROM users WHERE clerk_id = (auth.uid())::text
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION is_admin() RETURNS BOOL AS $$
  SELECT auth_role() = 'admin'
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION is_leader_plus() RETURNS BOOL AS $$
  SELECT auth_role() IN ('admin','leader')
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

-- ════════════════════════════════════════════════════════════
-- USERS
-- ════════════════════════════════════════════════════════════

-- Members see only their own profile
CREATE POLICY "users_select_own" ON users
  FOR SELECT USING (clerk_id = (auth.uid())::text);

-- Leaders and admins see all members
CREATE POLICY "users_select_leaders" ON users
  FOR SELECT USING (is_leader_plus());

-- Members update only their own profile
CREATE POLICY "users_update_own" ON users
  FOR UPDATE USING (clerk_id = (auth.uid())::text)
  WITH CHECK (clerk_id = (auth.uid())::text);

-- Only service_role (Clerk webhook Edge Function) inserts users
-- No INSERT policy needed for authenticated role.

-- Admins can update any user (e.g. change role)
CREATE POLICY "users_update_admin" ON users
  FOR UPDATE USING (is_admin());


-- ════════════════════════════════════════════════════════════
-- SERMONS
-- ════════════════════════════════════════════════════════════

-- All authenticated members see published sermons
CREATE POLICY "sermons_select_published" ON sermons
  FOR SELECT USING (published_at IS NOT NULL);

-- Admins see all sermons including drafts
CREATE POLICY "sermons_select_admin" ON sermons
  FOR SELECT USING (is_admin());

-- Only admins can create, update, delete sermons
CREATE POLICY "sermons_write_admin" ON sermons
  FOR ALL USING (is_admin());


-- ════════════════════════════════════════════════════════════
-- SERMON NOTES
-- ════════════════════════════════════════════════════════════

-- Members see and manage only their own notes
CREATE POLICY "sermon_notes_own" ON sermon_notes
  FOR ALL USING (user_id = auth_uid());


-- ════════════════════════════════════════════════════════════
-- POSTS (Community Feed)
-- ════════════════════════════════════════════════════════════

-- All authenticated members see all posts
CREATE POLICY "posts_select_all" ON posts
  FOR SELECT USING (true);

-- Members create posts only as themselves
CREATE POLICY "posts_insert_own" ON posts
  FOR INSERT WITH CHECK (user_id = auth_uid());

-- Authors delete their own posts; admins delete any
CREATE POLICY "posts_delete_own_or_admin" ON posts
  FOR DELETE USING (user_id = auth_uid() OR is_admin());

-- Authors update their own posts only
CREATE POLICY "posts_update_own" ON posts
  FOR UPDATE USING (user_id = auth_uid());


-- ════════════════════════════════════════════════════════════
-- POST LIKES
-- ════════════════════════════════════════════════════════════

CREATE POLICY "likes_select_all" ON post_likes
  FOR SELECT USING (true);

CREATE POLICY "likes_insert_own" ON post_likes
  FOR INSERT WITH CHECK (user_id = auth_uid());

CREATE POLICY "likes_delete_own" ON post_likes
  FOR DELETE USING (user_id = auth_uid());


-- ════════════════════════════════════════════════════════════
-- COMMENTS
-- ════════════════════════════════════════════════════════════

CREATE POLICY "comments_select_all" ON comments
  FOR SELECT USING (true);

CREATE POLICY "comments_insert_own" ON comments
  FOR INSERT WITH CHECK (user_id = auth_uid());

CREATE POLICY "comments_delete_own_or_admin" ON comments
  FOR DELETE USING (user_id = auth_uid() OR is_admin());


-- ════════════════════════════════════════════════════════════
-- GROUPS
-- ════════════════════════════════════════════════════════════

-- Public groups visible to all; private groups visible to members only
CREATE POLICY "groups_select_public" ON groups
  FOR SELECT USING (
    is_private = false
    OR id IN (SELECT group_id FROM group_members WHERE user_id = auth_uid())
    OR is_admin()
  );

-- Admins and leaders create groups
CREATE POLICY "groups_insert_leader" ON groups
  FOR INSERT WITH CHECK (is_leader_plus());

-- Group admins and church admins can update/delete
CREATE POLICY "groups_write_admin" ON groups
  FOR ALL USING (is_admin());

CREATE POLICY "group_members_select" ON group_members
  FOR SELECT USING (
    group_id IN (SELECT group_id FROM group_members WHERE user_id = auth_uid())
    OR is_admin()
  );

CREATE POLICY "group_members_insert" ON group_members
  FOR INSERT WITH CHECK (is_leader_plus() OR user_id = auth_uid());

CREATE POLICY "group_members_delete" ON group_members
  FOR DELETE USING (user_id = auth_uid() OR is_admin());


-- ════════════════════════════════════════════════════════════
-- MESSAGES
-- ════════════════════════════════════════════════════════════

-- Members see messages they sent, received, or are in a shared group
CREATE POLICY "messages_select_participant" ON messages
  FOR SELECT USING (
    sender_id = auth_uid()
    OR receiver_id = auth_uid()
    OR group_id IN (SELECT group_id FROM group_members WHERE user_id = auth_uid())
  );

-- Members send messages only as themselves
CREATE POLICY "messages_insert_own" ON messages
  FOR INSERT WITH CHECK (sender_id = auth_uid());


-- ════════════════════════════════════════════════════════════
-- LIVE STREAMS
-- ════════════════════════════════════════════════════════════

-- All members see all streams (active, idle, ended)
CREATE POLICY "streams_select_all" ON live_streams
  FOR SELECT USING (true);

-- Only admins create/update/delete streams
CREATE POLICY "streams_write_admin" ON live_streams
  FOR ALL USING (is_admin());

-- All members see live chat
CREATE POLICY "stream_messages_select_all" ON stream_messages
  FOR SELECT USING (true);

-- Members send chat only to active streams
CREATE POLICY "stream_messages_insert" ON stream_messages
  FOR INSERT WITH CHECK (
    user_id = auth_uid()
    AND stream_id IN (SELECT id FROM live_streams WHERE status = 'active')
  );


-- ════════════════════════════════════════════════════════════
-- EVENTS
-- ════════════════════════════════════════════════════════════

-- All members see events
CREATE POLICY "events_select_all" ON events
  FOR SELECT USING (true);

-- Only admins manage events
CREATE POLICY "events_write_admin" ON events
  FOR ALL USING (is_admin());

-- Members see only their own RSVPs
CREATE POLICY "rsvps_select_own" ON rsvps
  FOR SELECT USING (user_id = auth_uid());

-- Leaders and admins see all RSVPs (for attendance)
CREATE POLICY "rsvps_select_leaders" ON rsvps
  FOR SELECT USING (is_leader_plus());

-- Members RSVP as themselves only
CREATE POLICY "rsvps_insert_own" ON rsvps
  FOR INSERT WITH CHECK (user_id = auth_uid());


-- ════════════════════════════════════════════════════════════
-- FORMS (Pastoral follow-up)
-- ════════════════════════════════════════════════════════════

-- Any authenticated member (or anonymous via service_role) can submit
CREATE POLICY "forms_insert_member" ON forms
  FOR INSERT WITH CHECK (true);  -- submitted_by is nullable for anonymous forms

-- Only leaders and admins see submitted forms
CREATE POLICY "forms_select_leader" ON forms
  FOR SELECT USING (is_leader_plus());

-- Leaders and admins update status, assign, add notes
CREATE POLICY "forms_update_leader" ON forms
  FOR UPDATE USING (is_leader_plus());


-- ════════════════════════════════════════════════════════════
-- GIVING
-- ════════════════════════════════════════════════════════════

-- Members see only their own transactions
CREATE POLICY "giving_select_own" ON giving_transactions
  FOR SELECT USING (user_id = auth_uid());

-- Admins see all transactions (giving dashboard)
CREATE POLICY "giving_select_admin" ON giving_transactions
  FOR SELECT USING (is_admin());

-- INSERT and UPDATE handled by service_role only (payment webhook Edge Function)
-- Never allow members to directly insert/update giving_transactions


-- ════════════════════════════════════════════════════════════
-- COURSES, LESSONS, ENROLLMENTS, QUIZZES
-- ════════════════════════════════════════════════════════════

-- Members see published courses only
CREATE POLICY "courses_select_published" ON courses
  FOR SELECT USING (is_published = true);

-- Admins see all courses (including drafts)
CREATE POLICY "courses_select_admin" ON courses
  FOR SELECT USING (is_admin());

-- Admins manage all courses
CREATE POLICY "courses_write_admin" ON courses
  FOR ALL USING (is_admin());

-- Lessons visible to enrolled members only
CREATE POLICY "lessons_select_enrolled" ON lessons
  FOR SELECT USING (
    course_id IN (SELECT course_id FROM enrollments WHERE user_id = auth_uid())
    OR is_admin()
  );

CREATE POLICY "lessons_write_admin" ON lessons
  FOR ALL USING (is_admin());

-- Members see and manage their own enrollments
CREATE POLICY "enrollments_select_own" ON enrollments
  FOR SELECT USING (user_id = auth_uid());

CREATE POLICY "enrollments_insert_own" ON enrollments
  FOR INSERT WITH CHECK (
    user_id = auth_uid()
    AND EXISTS (SELECT 1 FROM courses WHERE id = course_id AND is_published = true)
  );

CREATE POLICY "enrollments_update_own" ON enrollments
  FOR UPDATE USING (user_id = auth_uid());

-- Admins see all enrollments
CREATE POLICY "enrollments_select_admin" ON enrollments
  FOR SELECT USING (is_admin());

-- Quiz questions visible to enrolled members
CREATE POLICY "quiz_questions_enrolled" ON quiz_questions
  FOR SELECT USING (
    lesson_id IN (
      SELECT l.id FROM lessons l
      JOIN enrollments e ON e.course_id = l.course_id
      WHERE e.user_id = auth_uid()
    )
    OR is_admin()
  );

CREATE POLICY "quiz_attempts_own" ON quiz_attempts
  FOR ALL USING (user_id = auth_uid());


-- ════════════════════════════════════════════════════════════
-- PODCAST, PRODUCTS, ORDERS
-- ════════════════════════════════════════════════════════════

-- All members see published podcast episodes
CREATE POLICY "podcast_select_published" ON podcast_episodes
  FOR SELECT USING (published_at IS NOT NULL OR is_admin());

CREATE POLICY "podcast_write_admin" ON podcast_episodes
  FOR ALL USING (is_admin());

-- All members see active products
CREATE POLICY "products_select_active" ON products
  FOR SELECT USING (is_active = true OR is_admin());

CREATE POLICY "products_write_admin" ON products
  FOR ALL USING (is_admin());

-- Members see only their own orders
CREATE POLICY "orders_select_own" ON orders
  FOR SELECT USING (user_id = auth_uid());

-- Admins see all orders
CREATE POLICY "orders_select_admin" ON orders
  FOR SELECT USING (is_admin());


-- ════════════════════════════════════════════════════════════
-- NOTIFICATIONS
-- ════════════════════════════════════════════════════════════

-- Members see and update only their own notifications
CREATE POLICY "notifications_own" ON notifications
  FOR ALL USING (user_id = auth_uid());


-- ════════════════════════════════════════════════════════════
-- SERVICE SCHEDULES + ATTENDANCE
-- ════════════════════════════════════════════════════════════

-- All members see active schedules
CREATE POLICY "schedules_select_active" ON service_schedules
  FOR SELECT USING (is_active = true OR is_admin());

CREATE POLICY "schedules_write_admin" ON service_schedules
  FOR ALL USING (is_admin());

-- Members see their own attendance; leaders see all
CREATE POLICY "attendance_select_own" ON attendance
  FOR SELECT USING (user_id = auth_uid());

CREATE POLICY "attendance_select_leaders" ON attendance
  FOR SELECT USING (is_leader_plus());

CREATE POLICY "attendance_insert" ON attendance
  FOR INSERT WITH CHECK (user_id = auth_uid());
-- ============================================================
-- JUM Backend Schema v2 — Single Church Edition
-- Migration 005: Indexes
-- ============================================================

-- USERS
CREATE UNIQUE INDEX idx_users_clerk_id  ON users (clerk_id);
CREATE        INDEX idx_users_role      ON users (role);  -- filter members by role

-- SERMONS
CREATE INDEX idx_sermons_published  ON sermons (published_at DESC NULLS LAST);
CREATE INDEX idx_sermons_series     ON sermons (series);
CREATE INDEX idx_sermons_trgm       ON sermons USING GIN (title gin_trgm_ops);

-- POSTS
CREATE INDEX idx_posts_created   ON posts (created_at DESC);
CREATE INDEX idx_posts_user_id   ON posts (user_id);

-- MESSAGES
CREATE INDEX idx_messages_sender    ON messages (sender_id);
CREATE INDEX idx_messages_receiver  ON messages (receiver_id);
CREATE INDEX idx_messages_group     ON messages (group_id, created_at ASC);

-- GIVING
CREATE UNIQUE INDEX idx_giving_reference    ON giving_transactions (reference);
CREATE        INDEX idx_giving_user_date    ON giving_transactions (user_id, created_at DESC);
CREATE        INDEX idx_giving_status       ON giving_transactions (status);
CREATE        INDEX idx_giving_created      ON giving_transactions (created_at DESC);  -- admin dashboard

-- FORMS
CREATE INDEX idx_forms_status      ON forms (status);
CREATE INDEX idx_forms_type        ON forms (type);
CREATE INDEX idx_forms_assigned    ON forms (assigned_to);
CREATE INDEX idx_forms_created     ON forms (created_at DESC);

-- EVENTS
CREATE INDEX idx_events_date        ON events (date ASC);
CREATE INDEX idx_rsvps_event        ON rsvps (event_id);
CREATE INDEX idx_rsvps_user_event   ON rsvps (user_id, event_id);  -- duplicate check

-- SCHOOL
CREATE INDEX idx_enrollments_user     ON enrollments (user_id);
CREATE INDEX idx_enrollments_course   ON enrollments (course_id);
CREATE INDEX idx_lessons_course_order ON lessons (course_id, sort_order ASC);

-- LIVE
CREATE INDEX idx_live_status        ON live_streams (status);   -- WHERE status = 'active'
CREATE INDEX idx_stream_msgs_stream ON stream_messages (stream_id, created_at ASC);

-- NOTIFICATIONS
CREATE INDEX idx_notifications_user_unread ON notifications (user_id, read_at NULLS FIRST);

-- ATTENDANCE
CREATE INDEX idx_attendance_user    ON attendance (user_id, attended_at DESC);
CREATE INDEX idx_attendance_date    ON attendance (attended_at DESC);
-- ============================================================
-- JUM Backend Schema v2 — Single Church Edition
-- Migration 006: Storage Bucket Definitions
--
-- Run in Supabase SQL Editor OR configure in the Dashboard.
-- Bucket creation via SQL requires the storage schema.
-- ============================================================

-- Create all buckets
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  -- Public buckets (no auth needed to read via URL)
  ('avatars',          'avatars',          true,  5242880,    ARRAY['image/jpeg','image/png','image/webp']),
  ('sermon-covers',    'sermon-covers',    true,  5242880,    ARRAY['image/jpeg','image/png','image/webp']),
  ('event-covers',     'event-covers',     true,  5242880,    ARRAY['image/jpeg','image/png','image/webp']),
  ('course-covers',    'course-covers',    true,  5242880,    ARRAY['image/jpeg','image/png','image/webp']),

  -- Private buckets (auth required)
  ('sermons',          'sermons',          false, 524288000,  ARRAY['video/mp4','audio/mpeg','audio/m4a','audio/ogg']),
  ('post-media',       'post-media',       false, 52428800,   ARRAY['image/jpeg','image/png','image/webp','video/mp4']),
  ('lesson-videos',    'lesson-videos',    false, 524288000,  ARRAY['video/mp4']),
  ('lesson-pdfs',      'lesson-pdfs',      false, 20971520,   ARRAY['application/pdf']),
  ('receipts',         'receipts',         false, 1048576,    ARRAY['application/pdf']),
  ('products',         'products',         false, 209715200,  ARRAY['application/pdf','video/mp4','audio/mpeg'])
ON CONFLICT (id) DO NOTHING;

-- ── Storage RLS Policies ──────────────────────────────────────

-- AVATARS (public read, own user writes)
CREATE POLICY "avatars_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'avatars');

CREATE POLICY "avatars_own_upload" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = (auth_uid())::text
  );

CREATE POLICY "avatars_own_update" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = (auth_uid())::text
  );

-- SERMON COVERS (public read, admin writes)
CREATE POLICY "sermon_covers_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'sermon-covers');

CREATE POLICY "sermon_covers_admin_write" ON storage.objects
  FOR ALL USING (bucket_id = 'sermon-covers' AND is_admin());

-- EVENT COVERS (public read, admin writes)
CREATE POLICY "event_covers_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'event-covers');

CREATE POLICY "event_covers_admin_write" ON storage.objects
  FOR ALL USING (bucket_id = 'event-covers' AND is_admin());

-- COURSE COVERS (public read, admin writes)
CREATE POLICY "course_covers_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'course-covers');

CREATE POLICY "course_covers_admin_write" ON storage.objects
  FOR ALL USING (bucket_id = 'course-covers' AND is_admin());

-- SERMONS (authenticated members read, admin writes)
CREATE POLICY "sermons_auth_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'sermons' AND auth.role() = 'authenticated');

CREATE POLICY "sermons_admin_write" ON storage.objects
  FOR ALL USING (bucket_id = 'sermons' AND is_admin());

-- POST MEDIA (authenticated members read, own user uploads)
CREATE POLICY "post_media_auth_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'post-media' AND auth.role() = 'authenticated');

CREATE POLICY "post_media_own_upload" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'post-media'
    AND (storage.foldername(name))[1] = (auth_uid())::text
  );

-- LESSON VIDEOS (enrolled members only)
CREATE POLICY "lesson_videos_enrolled" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'lesson-videos'
    AND EXISTS (SELECT 1 FROM enrollments WHERE user_id = auth_uid())
  );

CREATE POLICY "lesson_videos_admin_write" ON storage.objects
  FOR ALL USING (bucket_id = 'lesson-videos' AND is_admin());

-- LESSON PDFs (enrolled members only)
CREATE POLICY "lesson_pdfs_enrolled" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'lesson-pdfs'
    AND EXISTS (SELECT 1 FROM enrollments WHERE user_id = auth_uid())
  );

CREATE POLICY "lesson_pdfs_admin_write" ON storage.objects
  FOR ALL USING (bucket_id = 'lesson-pdfs' AND is_admin());

-- RECEIPTS (own user only)
CREATE POLICY "receipts_own_read" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'receipts'
    AND (storage.foldername(name))[1] = (auth_uid())::text
  );

-- PRODUCTS (paid order holders read, admin writes)
CREATE POLICY "products_paid_read" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'products'
    AND EXISTS (
      SELECT 1 FROM orders o
      JOIN products p ON p.id = o.product_id
      WHERE o.user_id = auth_uid()
        AND o.status = 'paid'
        AND p.media_url LIKE '%' || name || '%'
    )
  );

CREATE POLICY "products_admin_write" ON storage.objects
  FOR ALL USING (bucket_id = 'products' AND is_admin());

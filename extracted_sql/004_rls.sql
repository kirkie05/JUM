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

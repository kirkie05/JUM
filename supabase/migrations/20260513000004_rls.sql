-- ============================================================
-- JUM Backend Schema v3
-- Migration 004: Row Level Security (RLS)
-- ============================================================

-- Enable RLS on all 24 tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE sermon_series ENABLE ROW LEVEL SECURITY;
ALTER TABLE sermons ENABLE ROW LEVEL SECURITY;
ALTER TABLE podcasts ENABLE ROW LEVEL SECURITY;
ALTER TABLE podcast_episodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE donations ENABLE ROW LEVEL SECURITY;
ALTER TABLE prayer_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE planner_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- ── 0. HELPER FUNCTION TO PREVENT INFINITE RECURSION ──────────
-- Fetch role from auth.jwt() metadata instead of querying profiles
-- Ensure custom claims are set in JWT or fallback to direct DB query with SECURITY DEFINER
CREATE OR REPLACE FUNCTION get_user_role() RETURNS text AS $$
  SELECT role FROM profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_admin() RETURNS boolean AS $$
  SELECT get_user_role() IN ('admin', 'super_admin');
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_moderator() RETURNS boolean AS $$
  SELECT get_user_role() IN ('admin', 'super_admin', 'leader');
$$ LANGUAGE sql SECURITY DEFINER;


-- ── 1. PROFILES ──────────────────────────────────────────────
-- Users can read all profiles (needed for comments, messaging)
CREATE POLICY "Public profiles are viewable by everyone" ON profiles FOR SELECT USING (true);
-- Users can update their own profile
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (id = auth.uid()) WITH CHECK (id = auth.uid());
-- Edge functions or triggers handle INSERT
CREATE POLICY "Service role can insert profiles" ON profiles FOR INSERT WITH CHECK (true);


-- ── 2. COMMUNITY (Posts, Comments, Likes) ────────────────────
CREATE POLICY "Posts are viewable by everyone" ON posts FOR SELECT USING (true);
CREATE POLICY "Users can create posts" ON posts FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users can update own posts" ON posts FOR UPDATE USING (user_id = auth.uid() OR is_moderator());
CREATE POLICY "Users can delete own posts" ON posts FOR DELETE USING (user_id = auth.uid() OR is_moderator());

CREATE POLICY "Comments are viewable by everyone" ON comments FOR SELECT USING (true);
CREATE POLICY "Users can create comments" ON comments FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users can update own comments" ON comments FOR UPDATE USING (user_id = auth.uid() OR is_moderator());
CREATE POLICY "Users can delete own comments" ON comments FOR DELETE USING (user_id = auth.uid() OR is_moderator());

CREATE POLICY "Likes are viewable by everyone" ON likes FOR SELECT USING (true);
CREATE POLICY "Users can manage own likes" ON likes FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());


-- ── 3. GROUPS & MEMBERS ──────────────────────────────────────
CREATE POLICY "Groups are viewable by everyone" ON groups FOR SELECT USING (true);
CREATE POLICY "Admins can manage groups" ON groups FOR ALL USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "Group members viewable by everyone" ON group_members FOR SELECT USING (true);
CREATE POLICY "Users can join groups" ON group_members FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users can leave groups" ON group_members FOR DELETE USING (user_id = auth.uid());


-- ── 4. MESSAGING ─────────────────────────────────────────────
CREATE POLICY "Users can view conversations they are part of" ON conversations FOR SELECT USING (
  EXISTS (SELECT 1 FROM messages WHERE conversation_id = conversations.id AND (sender_id = auth.uid() OR receiver_id = auth.uid()))
);
CREATE POLICY "Users can create conversations" ON conversations FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can read their messages" ON messages FOR SELECT USING (sender_id = auth.uid() OR receiver_id = auth.uid());
CREATE POLICY "Users can send messages" ON messages FOR INSERT WITH CHECK (sender_id = auth.uid());
CREATE POLICY "Users can update read status" ON messages FOR UPDATE USING (receiver_id = auth.uid());


-- ── 5. EVENTS ────────────────────────────────────────────────
CREATE POLICY "Events are viewable by everyone" ON events FOR SELECT USING (true);
CREATE POLICY "Admins manage events" ON events FOR ALL USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "Users can view own registrations" ON event_registrations FOR SELECT USING (user_id = auth.uid() OR is_admin());
CREATE POLICY "Users can register for events" ON event_registrations FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users can cancel registrations" ON event_registrations FOR DELETE USING (user_id = auth.uid());


-- ── 6. MEDIA (Sermons & Podcasts) ────────────────────────────
CREATE POLICY "Sermon series viewable by everyone" ON sermon_series FOR SELECT USING (true);
CREATE POLICY "Sermons viewable by everyone" ON sermons FOR SELECT USING (true);
CREATE POLICY "Podcasts viewable by everyone" ON podcasts FOR SELECT USING (true);
CREATE POLICY "Podcast episodes viewable by everyone" ON podcast_episodes FOR SELECT USING (true);
-- Write access to Admins only
CREATE POLICY "Admins manage sermon_series" ON sermon_series FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "Admins manage sermons" ON sermons FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "Admins manage podcasts" ON podcasts FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "Admins manage podcast_episodes" ON podcast_episodes FOR ALL USING (is_admin()) WITH CHECK (is_admin());


-- ── 7. GOSPEL ARMY (Courses) ─────────────────────────────────
CREATE POLICY "Courses viewable by everyone" ON courses FOR SELECT USING (true);
CREATE POLICY "Lessons viewable by enrolled" ON lessons FOR SELECT USING (
  EXISTS (SELECT 1 FROM enrollments WHERE course_id = lessons.course_id AND user_id = auth.uid()) OR is_admin()
);
CREATE POLICY "Quizzes viewable by enrolled" ON quizzes FOR SELECT USING (
  EXISTS (SELECT 1 FROM lessons JOIN enrollments ON lessons.course_id = enrollments.course_id WHERE lessons.id = quizzes.lesson_id AND user_id = auth.uid()) OR is_admin()
);

CREATE POLICY "Admins manage courses" ON courses FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "Admins manage lessons" ON lessons FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "Admins manage quizzes" ON quizzes FOR ALL USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "Users manage own enrollments" ON enrollments FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());


-- ── 8. MARKETPLACE ───────────────────────────────────────────
CREATE POLICY "Products viewable by everyone" ON products FOR SELECT USING (true);
CREATE POLICY "Admins manage products" ON products FOR ALL USING (is_admin()) WITH CHECK (is_admin());

CREATE POLICY "Users can view own orders" ON orders FOR SELECT USING (user_id = auth.uid() OR is_admin());
CREATE POLICY "Users can create orders" ON orders FOR INSERT WITH CHECK (user_id = auth.uid());


-- ── 9. DONATIONS ─────────────────────────────────────────────
CREATE POLICY "Users can view own donations" ON donations FOR SELECT USING (user_id = auth.uid() OR is_admin());
CREATE POLICY "Users can insert donations" ON donations FOR INSERT WITH CHECK (user_id = auth.uid());


-- ── 10. FORMS & UTILS ────────────────────────────────────────
CREATE POLICY "Users view own prayer requests" ON prayer_requests FOR SELECT USING (user_id = auth.uid() OR is_moderator());
CREATE POLICY "Users create prayer requests" ON prayer_requests FOR INSERT WITH CHECK (true); -- Anon allowed
CREATE POLICY "Moderators update prayer requests" ON prayer_requests FOR UPDATE USING (is_moderator()) WITH CHECK (is_moderator());

CREATE POLICY "Users manage own planner entries" ON planner_entries FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users view own notifications" ON notifications FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Users update own notifications" ON notifications FOR UPDATE USING (user_id = auth.uid());

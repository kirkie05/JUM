-- ============================================================
-- JUM Backend Schema v3
-- Migration 005: Performance Indexes
-- ============================================================

-- PROFILES
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);

-- POSTS & COMMENTS
CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(user_id);
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_comments_post_id ON comments(post_id);
CREATE INDEX IF NOT EXISTS idx_likes_post_id ON likes(post_id);
CREATE INDEX IF NOT EXISTS idx_likes_user_id ON likes(user_id);

-- TRIGRAM SEARCH (using pg_trgm extension created in 001)
CREATE INDEX IF NOT EXISTS idx_posts_body_trgm ON posts USING GIN (body gin_trgm_ops);

-- MESSAGING
CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_receiver_id ON messages(receiver_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at DESC);

-- EVENTS
CREATE INDEX IF NOT EXISTS idx_events_date ON events(event_date DESC);
CREATE INDEX IF NOT EXISTS idx_event_registrations_event_id ON event_registrations(event_id);
CREATE INDEX IF NOT EXISTS idx_event_registrations_user_id ON event_registrations(user_id);

-- MEDIA (Sermons & Podcasts)
CREATE INDEX IF NOT EXISTS idx_sermons_series_id ON sermons(series_id);
CREATE INDEX IF NOT EXISTS idx_sermons_date ON sermons(date_preached DESC);
CREATE INDEX IF NOT EXISTS idx_sermons_title_trgm ON sermons USING GIN (title gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_podcast_episodes_podcast_id ON podcast_episodes(podcast_id);
CREATE INDEX IF NOT EXISTS idx_podcast_episodes_published_at ON podcast_episodes(published_at DESC);

-- GOSPEL ARMY (Courses)
CREATE INDEX IF NOT EXISTS idx_lessons_course_id ON lessons(course_id);
CREATE INDEX IF NOT EXISTS idx_quizzes_lesson_id ON quizzes(lesson_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_user_id ON enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_course_id ON enrollments(course_id);

-- MARKETPLACE
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);

-- DONATIONS
CREATE INDEX IF NOT EXISTS idx_donations_user_id ON donations(user_id);
CREATE INDEX IF NOT EXISTS idx_donations_status ON donations(status);

-- FORMS & UTILS
CREATE INDEX IF NOT EXISTS idx_planner_entries_user_id ON planner_entries(user_id);
CREATE INDEX IF NOT EXISTS idx_planner_entries_date ON planner_entries(entry_date);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_prayer_requests_user_id ON prayer_requests(user_id);

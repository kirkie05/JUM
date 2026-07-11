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

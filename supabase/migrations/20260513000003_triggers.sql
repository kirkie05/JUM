-- ============================================================
-- JUM Backend Schema v3
-- Migration 003: Functions and Triggers
-- ============================================================

-- ── 1. AUTO-UPDATE UPDATED_AT TIMESTAMP ──────────────────────
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to profiles
DROP TRIGGER IF EXISTS update_profiles_updated_at ON profiles;
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ── 2. AUTO-CREATE PROFILE ON SIGN UP ────────────────────────
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, name, email, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name', 'New Member'),
    NEW.email,
    'member'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger the function every time a user is created
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ── 3. AUTO-UPDATE COMMENTS/LIKES COUNTS ─────────────────────
CREATE OR REPLACE FUNCTION update_post_counts()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' AND TG_TABLE_NAME = 'comments' THEN
    UPDATE posts SET comments_count = comments_count + 1 WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' AND TG_TABLE_NAME = 'comments' THEN
    UPDATE posts SET comments_count = comments_count - 1 WHERE id = OLD.post_id;
  ELSIF TG_OP = 'INSERT' AND TG_TABLE_NAME = 'likes' THEN
    UPDATE posts SET likes_count = likes_count + 1 WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' AND TG_TABLE_NAME = 'likes' THEN
    UPDATE posts SET likes_count = likes_count - 1 WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_comment_insert AFTER INSERT ON comments FOR EACH ROW EXECUTE FUNCTION update_post_counts();
CREATE TRIGGER on_comment_delete AFTER DELETE ON comments FOR EACH ROW EXECUTE FUNCTION update_post_counts();
CREATE TRIGGER on_like_insert AFTER INSERT ON likes FOR EACH ROW EXECUTE FUNCTION update_post_counts();
CREATE TRIGGER on_like_delete AFTER DELETE ON likes FOR EACH ROW EXECUTE FUNCTION update_post_counts();

-- ── 4. AUTO-COMPLETE COURSE PROGRESS ─────────────────────────
CREATE OR REPLACE FUNCTION check_course_completion()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.progress_percent >= 100 AND OLD.progress_percent < 100 THEN
    NEW.completed_at = NOW();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_enrollment_progress
  BEFORE UPDATE OF progress_percent ON enrollments
  FOR EACH ROW EXECUTE FUNCTION check_course_completion();

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

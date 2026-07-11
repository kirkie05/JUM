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

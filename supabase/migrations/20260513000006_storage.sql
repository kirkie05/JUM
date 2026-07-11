-- ============================================================
-- JUM Backend Schema v3
-- Migration 006: Storage Buckets & Policies
-- ============================================================

-- ── 1. CREATE ALL BUCKETS ────────────────────────────────────
INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('sermons', 'sermons', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('videos', 'videos', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('audio', 'audio', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('podcasts', 'podcasts', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('courses', 'courses', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('products', 'products', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('events', 'events', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('documents', 'documents', false) ON CONFLICT (id) DO NOTHING;

-- ── 2. CREATE STORAGE POLICIES ───────────────────────────────

-- AVATARS (Public Read, Owner Write)
CREATE POLICY "Avatar images are publicly accessible" ON storage.objects FOR SELECT USING (bucket_id = 'avatars');
CREATE POLICY "Users can upload their own avatar" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);
CREATE POLICY "Users can update their own avatar" ON storage.objects FOR UPDATE USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

-- SERMONS, VIDEOS, AUDIO, PODCASTS, COURSES, PRODUCTS, EVENTS (Public Read, Admin Write)
-- Note: 'is_admin()' function from 004_rls.sql is used for secure validation
CREATE POLICY "Media objects are publicly accessible" ON storage.objects FOR SELECT USING (
  bucket_id IN ('sermons', 'videos', 'audio', 'podcasts', 'courses', 'products', 'events')
);

CREATE POLICY "Admins can upload media objects" ON storage.objects FOR INSERT WITH CHECK (
  bucket_id IN ('sermons', 'videos', 'audio', 'podcasts', 'courses', 'products', 'events') AND public.is_admin()
);

CREATE POLICY "Admins can update media objects" ON storage.objects FOR UPDATE USING (
  bucket_id IN ('sermons', 'videos', 'audio', 'podcasts', 'courses', 'products', 'events') AND public.is_admin()
);

CREATE POLICY "Admins can delete media objects" ON storage.objects FOR DELETE USING (
  bucket_id IN ('sermons', 'videos', 'audio', 'podcasts', 'courses', 'products', 'events') AND public.is_admin()
);

-- DOCUMENTS (Private: Users Read own, Service Role Write)
-- Example: Giving receipts are uploaded by edge functions, users read their own
CREATE POLICY "Users can view their own documents" ON storage.objects FOR SELECT USING (
  bucket_id = 'documents' AND auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Admins can view all documents" ON storage.objects FOR SELECT USING (
  bucket_id = 'documents' AND public.is_admin()
);

CREATE POLICY "Service Role can insert documents" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'documents');

-- ============================================================
-- JUM Seed Data File
-- Generated programmatically for JUM Ministry App
-- ============================================================

SET session_replication_role = 'replica';

TRUNCATE auth.users CASCADE;
TRUNCATE public.profiles CASCADE;
TRUNCATE public.sermon_series CASCADE;
TRUNCATE public.sermons CASCADE;
TRUNCATE public.podcasts CASCADE;
TRUNCATE public.podcast_episodes CASCADE;
TRUNCATE public.groups CASCADE;
TRUNCATE public.group_members CASCADE;
TRUNCATE public.events CASCADE;
TRUNCATE public.event_registrations CASCADE;
TRUNCATE public.courses CASCADE;
TRUNCATE public.lessons CASCADE;
TRUNCATE public.quiz_questions CASCADE;
TRUNCATE public.quiz_attempts CASCADE;
TRUNCATE public.enrollments CASCADE;
TRUNCATE public.products CASCADE;
TRUNCATE public.orders CASCADE;
TRUNCATE public.donations CASCADE;
TRUNCATE public.posts CASCADE;
TRUNCATE public.comments CASCADE;
TRUNCATE public.likes CASCADE;
TRUNCATE public.conversations CASCADE;
TRUNCATE public.messages CASCADE;
TRUNCATE public.prayer_requests CASCADE;
TRUNCATE public.planner_entries CASCADE;
TRUNCATE public.notifications CASCADE;

-- ── 1. INSERTING USERS ──────────────────────────────────────
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '6b0dd36d-93f9-504c-abc6-4bf98e01c770',
  'kingsley.aniche@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Kingsley Aniche","name":"Kingsley Aniche"}',
  NOW() - interval '86 days',
  NOW(),
  'authenticated',
  'authenticated',
  true
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '6b0dd36d-93f9-504c-abc6-4bf98e01c770',
  'Kingsley Aniche',
  'Kingsley Aniche',
  'Kingsley',
  'kingsley.aniche@jum.org',
  '+2348031234567',
  'super_admin',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
  'Senior Pastor and Founder of Jesus Unhindered Ministry. Dedicated to raising disciples and spreading unhindered grace.',
  NOW() - interval '18 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  'grace.adebayo@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Grace Adebayo","name":"Grace Adebayo"}',
  NOW() - interval '59 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  'Grace Adebayo',
  'Grace Adebayo',
  'Grace',
  'grace.adebayo@jum.org',
  '+2348021112222',
  'admin',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
  'Associate Pastor at JUM. Passionate about family life, counseling, and youth outreach.',
  NOW() - interval '58 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  'emmanuel.n@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Emmanuel Nwachukwu","name":"Emmanuel Nwachukwu"}',
  NOW() - interval '86 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  'Emmanuel Nwachukwu',
  'Emmanuel Nwachukwu',
  'Emmanuel',
  'emmanuel.n@jum.org',
  '+447712345678',
  'admin',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
  'Managing operational structures and logistics across JUM global campuses.',
  NOW() - interval '69 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  'david.vance@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"David Vance","name":"David Vance"}',
  NOW() - interval '77 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  'David Vance',
  'David Vance',
  'David',
  'david.vance@jum.org',
  '+17135550199',
  'admin',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
  'Overseeing global broadcasting, streaming platforms, and digital outreach for JUM.',
  NOW() - interval '42 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  'sarah.j@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Sarah Jenkins","name":"Sarah Jenkins"}',
  NOW() - interval '80 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  'Sarah Jenkins',
  'Sarah Jenkins',
  'Sarah',
  'sarah.j@jum.org',
  '+447787654321',
  'leader',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
  'Worship director leading the Levites Choir to create an atmosphere of praise.',
  NOW() - interval '11 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  'joshua.o@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Joshua Okonkwo","name":"Joshua Okonkwo"}',
  NOW() - interval '97 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  'Joshua Okonkwo',
  'Joshua Okonkwo',
  'Joshua',
  'joshua.o@jum.org',
  '+2348033334444',
  'leader',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
  'Empowering young minds through discipleship, seminars, and community service.',
  NOW() - interval '24 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  'ruth.b@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Ruth Bello","name":"Ruth Bello"}',
  NOW() - interval '97 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  'Ruth Bello',
  'Ruth Bello',
  'Ruth',
  'ruth.b@jum.org',
  '+2348099998888',
  'leader',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
  'Coordinating intercession teams and prayer chains for the local and global assembly.',
  NOW() - interval '78 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  'michael.t@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Michael Thomas","name":"Michael Thomas"}',
  NOW() - interval '44 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  'Michael Thomas',
  'Michael Thomas',
  'Michael',
  'michael.t@jum.org',
  '+2348055556666',
  'leader',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
  'Leading JUM outreach efforts in disadvantaged communities across West Africa.',
  NOW() - interval '92 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  'esther.m@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Esther Mensah","name":"Esther Mensah"}',
  NOW() - interval '53 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  'Esther Mensah',
  'Esther Mensah',
  'Esther',
  'esther.m@jum.org',
  '+233241234567',
  'leader',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
  'Guiding JUM Kids to grow in the admonition and knowledge of the Lord.',
  NOW() - interval '24 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  'caleb.o@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Caleb Okereke","name":"Caleb Okereke"}',
  NOW() - interval '47 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  'Caleb Okereke',
  'Caleb Okereke',
  'Caleb',
  'caleb.o@jum.org',
  '+2348123456789',
  'leader',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
  'Ensuring orderliness and a welcoming environment during church services.',
  NOW() - interval '65 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  'daniel.ogunleye11@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Daniel Ogunleye","name":"Daniel Ogunleye"}',
  NOW() - interval '30 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  'Daniel Ogunleye',
  'Daniel Ogunleye',
  'Daniel',
  'daniel.ogunleye11@jum.org',
  '+234805614226',
  'volunteer',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Abuja assembly. Active in fellowship and serving the community.',
  NOW() - interval '68 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  'rebecca.smith12@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Rebecca Smith","name":"Rebecca Smith"}',
  NOW() - interval '10 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  'Rebecca Smith',
  'Rebecca Smith',
  'Rebecca',
  'rebecca.smith12@jum.org',
  '+44773341057',
  'volunteer',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Houston assembly. Active in fellowship and serving the community.',
  NOW() - interval '43 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '8a11f317-311d-5241-b8a0-455f712265b5',
  'samuel.eze13@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Samuel Eze","name":"Samuel Eze"}',
  NOW() - interval '74 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '8a11f317-311d-5241-b8a0-455f712265b5',
  'Samuel Eze',
  'Samuel Eze',
  'Samuel',
  'samuel.eze13@jum.org',
  '+234802458591',
  'volunteer',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Abuja assembly. Active in fellowship and serving the community.',
  NOW() - interval '32 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  'elizabeth.johnson14@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Elizabeth Johnson","name":"Elizabeth Johnson"}',
  NOW() - interval '74 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  'Elizabeth Johnson',
  'Elizabeth Johnson',
  'Elizabeth',
  'elizabeth.johnson14@jum.org',
  '+44771533224',
  'volunteer',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Manchester assembly. Active in fellowship and serving the community.',
  NOW() - interval '23 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  'joseph.adesina15@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Joseph Adesina","name":"Joseph Adesina"}',
  NOW() - interval '90 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  'Joseph Adesina',
  'Joseph Adesina',
  'Joseph',
  'joseph.adesina15@jum.org',
  '+234804668136',
  'volunteer',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Lagos assembly. Active in fellowship and serving the community.',
  NOW() - interval '48 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  'hannah.williams16@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Hannah Williams","name":"Hannah Williams"}',
  NOW() - interval '91 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  'Hannah Williams',
  'Hannah Williams',
  'Hannah',
  'hannah.williams16@jum.org',
  '+44771445199',
  'volunteer',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Houston assembly. Active in fellowship and serving the community.',
  NOW() - interval '74 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '1164ec13-a4de-5cc0-8eac-eb8833b16640',
  'john.okafor17@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"John Okafor","name":"John Okafor"}',
  NOW() - interval '87 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '1164ec13-a4de-5cc0-8eac-eb8833b16640',
  'John Okafor',
  'John Okafor',
  'John',
  'john.okafor17@jum.org',
  '+44778038374',
  'volunteer',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM New York assembly. Active in fellowship and serving the community.',
  NOW() - interval '35 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '1c27aaa9-2781-5750-9b68-25fee3a17b99',
  'deborah.brown18@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Deborah Brown","name":"Deborah Brown"}',
  NOW() - interval '29 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '1c27aaa9-2781-5750-9b68-25fee3a17b99',
  'Deborah Brown',
  'Deborah Brown',
  'Deborah',
  'deborah.brown18@jum.org',
  '+44775667265',
  'volunteer',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Houston assembly. Active in fellowship and serving the community.',
  NOW() - interval '57 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '7126763d-b662-5599-8069-51cbfe88a56a',
  'paul.ajayi19@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Paul Ajayi","name":"Paul Ajayi"}',
  NOW() - interval '30 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '7126763d-b662-5599-8069-51cbfe88a56a',
  'Paul Ajayi',
  'Paul Ajayi',
  'Paul',
  'paul.ajayi19@jum.org',
  '+234808090293',
  'volunteer',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Lagos assembly. Active in fellowship and serving the community.',
  NOW() - interval '79 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '7a9058c3-61ed-5188-b233-69fca99e66c0',
  'mary.davis20@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Mary Davis","name":"Mary Davis"}',
  NOW() - interval '77 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '7a9058c3-61ed-5188-b233-69fca99e66c0',
  'Mary Davis',
  'Mary Davis',
  'Mary',
  'mary.davis20@jum.org',
  '+44773608513',
  'volunteer',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Nairobi assembly. Active in fellowship and serving the community.',
  NOW() - interval '10 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'e453775a-166a-54df-a5b2-0081c12608dd',
  'james.igwe21@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"James Igwe","name":"James Igwe"}',
  NOW() - interval '86 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'e453775a-166a-54df-a5b2-0081c12608dd',
  'James Igwe',
  'James Igwe',
  'James',
  'james.igwe21@jum.org',
  '+44772714803',
  'volunteer',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Houston assembly. Active in fellowship and serving the community.',
  NOW() - interval '51 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '051c1a02-6308-5a77-a3f1-f6cd8229242e',
  'victoria.jones22@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Victoria Jones","name":"Victoria Jones"}',
  NOW() - interval '72 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '051c1a02-6308-5a77-a3f1-f6cd8229242e',
  'Victoria Jones',
  'Victoria Jones',
  'Victoria',
  'victoria.jones22@jum.org',
  '+234802622631',
  'volunteer',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Abuja assembly. Active in fellowship and serving the community.',
  NOW() - interval '12 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '14078da6-ea92-59c8-aa32-fa74fec6e2c4',
  'stephen.balogun23@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Stephen Balogun","name":"Stephen Balogun"}',
  NOW() - interval '24 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '14078da6-ea92-59c8-aa32-fa74fec6e2c4',
  'Stephen Balogun',
  'Stephen Balogun',
  'Stephen',
  'stephen.balogun23@jum.org',
  '+44775437923',
  'volunteer',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Nairobi assembly. Active in fellowship and serving the community.',
  NOW() - interval '56 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '13dcf743-d13f-5642-816c-e2421e3b775b',
  'eunice.miller24@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Eunice Miller","name":"Eunice Miller"}',
  NOW() - interval '49 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '13dcf743-d13f-5642-816c-e2421e3b775b',
  'Eunice Miller',
  'Eunice Miller',
  'Eunice',
  'eunice.miller24@jum.org',
  '+234808707870',
  'volunteer',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM Lagos assembly. Active in fellowship and serving the community.',
  NOW() - interval '40 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '5cceeb1d-7a95-5f43-8b5b-069ed1de1651',
  'peter.nwosu25@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Peter Nwosu","name":"Peter Nwosu"}',
  NOW() - interval '17 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '5cceeb1d-7a95-5f43-8b5b-069ed1de1651',
  'Peter Nwosu',
  'Peter Nwosu',
  'Peter',
  'peter.nwosu25@jum.org',
  '+44777350753',
  'volunteer',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
  'Faithful volunteer at JUM New York assembly. Active in fellowship and serving the community.',
  NOW() - interval '40 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '49326b61-166d-5ae6-b288-dfd08f776172',
  'kezia.wilson26@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Kezia Wilson","name":"Kezia Wilson"}',
  NOW() - interval '82 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '49326b61-166d-5ae6-b288-dfd08f776172',
  'Kezia Wilson',
  'Kezia Wilson',
  'Kezia',
  'kezia.wilson26@jum.org',
  '+234805918715',
  'member',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Abuja assembly. Active in fellowship and serving the community.',
  NOW() - interval '20 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '241613d3-48a5-5736-a503-fbbe390e8d02',
  'timothy.okeke27@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Timothy Okeke","name":"Timothy Okeke"}',
  NOW() - interval '20 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '241613d3-48a5-5736-a503-fbbe390e8d02',
  'Timothy Okeke',
  'Timothy Okeke',
  'Timothy',
  'timothy.okeke27@jum.org',
  '+44774226067',
  'member',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Manchester assembly. Active in fellowship and serving the community.',
  NOW() - interval '72 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '8e08990d-1c10-52d4-95d5-a7a24656ac16',
  'lois.moore28@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Lois Moore","name":"Lois Moore"}',
  NOW() - interval '18 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '8e08990d-1c10-52d4-95d5-a7a24656ac16',
  'Lois Moore',
  'Lois Moore',
  'Lois',
  'lois.moore28@jum.org',
  '+234804823498',
  'member',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Abuja assembly. Active in fellowship and serving the community.',
  NOW() - interval '78 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '8a279fe1-0ccc-5ad6-a3b4-01f13882be16',
  'andrew.alabi29@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Andrew Alabi","name":"Andrew Alabi"}',
  NOW() - interval '26 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '8a279fe1-0ccc-5ad6-a3b4-01f13882be16',
  'Andrew Alabi',
  'Andrew Alabi',
  'Andrew',
  'andrew.alabi29@jum.org',
  '+44774905582',
  'member',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Atlanta assembly. Active in fellowship and serving the community.',
  NOW() - interval '26 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '17037c2d-a6ba-5ff3-a083-64d2b96b6000',
  'dorcas.taylor30@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Dorcas Taylor","name":"Dorcas Taylor"}',
  NOW() - interval '94 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '17037c2d-a6ba-5ff3-a083-64d2b96b6000',
  'Dorcas Taylor',
  'Dorcas Taylor',
  'Dorcas',
  'dorcas.taylor30@jum.org',
  '+234805663623',
  'member',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Abuja assembly. Active in fellowship and serving the community.',
  NOW() - interval '70 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'a23a905b-10d3-5c22-8f08-ba193b5fed24',
  'philip.olayemi31@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Philip Olayemi","name":"Philip Olayemi"}',
  NOW() - interval '80 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'a23a905b-10d3-5c22-8f08-ba193b5fed24',
  'Philip Olayemi',
  'Philip Olayemi',
  'Philip',
  'philip.olayemi31@jum.org',
  '+44777120868',
  'member',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Cape Town assembly. Active in fellowship and serving the community.',
  NOW() - interval '31 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '6b2dee77-c383-5011-aa9b-f2934b57ad3c',
  'priscilla.anderson32@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Priscilla Anderson","name":"Priscilla Anderson"}',
  NOW() - interval '43 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '6b2dee77-c383-5011-aa9b-f2934b57ad3c',
  'Priscilla Anderson',
  'Priscilla Anderson',
  'Priscilla',
  'priscilla.anderson32@jum.org',
  '+44776960453',
  'member',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM London assembly. Active in fellowship and serving the community.',
  NOW() - interval '77 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '0b0fc815-5048-5f88-a8e8-80ee60459e1b',
  'thomas.nduka33@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Thomas Nduka","name":"Thomas Nduka"}',
  NOW() - interval '87 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '0b0fc815-5048-5f88-a8e8-80ee60459e1b',
  'Thomas Nduka',
  'Thomas Nduka',
  'Thomas',
  'thomas.nduka33@jum.org',
  '+44775479144',
  'member',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Houston assembly. Active in fellowship and serving the community.',
  NOW() - interval '64 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'd3e86c7c-5012-5fb9-99d6-40c4a04961d3',
  'martha.thomas34@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Martha Thomas","name":"Martha Thomas"}',
  NOW() - interval '37 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'd3e86c7c-5012-5fb9-99d6-40c4a04961d3',
  'Martha Thomas',
  'Martha Thomas',
  'Martha',
  'martha.thomas34@jum.org',
  '+234803871230',
  'member',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Abuja assembly. Active in fellowship and serving the community.',
  NOW() - interval '79 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'eca334aa-bf34-503b-ba8b-aaed8566256d',
  'matthew.adeyemi35@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Matthew Adeyemi","name":"Matthew Adeyemi"}',
  NOW() - interval '98 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'eca334aa-bf34-503b-ba8b-aaed8566256d',
  'Matthew Adeyemi',
  'Matthew Adeyemi',
  'Matthew',
  'matthew.adeyemi35@jum.org',
  '+44775107245',
  'member',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM New York assembly. Active in fellowship and serving the community.',
  NOW() - interval '35 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'f7781772-4b52-5e49-8948-95f14685bb7d',
  'abigail.jackson36@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Abigail Jackson","name":"Abigail Jackson"}',
  NOW() - interval '49 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'f7781772-4b52-5e49-8948-95f14685bb7d',
  'Abigail Jackson',
  'Abigail Jackson',
  'Abigail',
  'abigail.jackson36@jum.org',
  '+44777366205',
  'member',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM London assembly. Active in fellowship and serving the community.',
  NOW() - interval '61 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '4b6c0db2-8f0a-5dad-8505-667ad8f00e8d',
  'simon.chukwu37@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Simon Chukwu","name":"Simon Chukwu"}',
  NOW() - interval '95 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '4b6c0db2-8f0a-5dad-8505-667ad8f00e8d',
  'Simon Chukwu',
  'Simon Chukwu',
  'Simon',
  'simon.chukwu37@jum.org',
  '+44774684531',
  'member',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Atlanta assembly. Active in fellowship and serving the community.',
  NOW() - interval '93 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '25a41fdc-b039-501f-af00-e6cb77497994',
  'lydia.white38@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Lydia White","name":"Lydia White"}',
  NOW() - interval '57 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '25a41fdc-b039-501f-af00-e6cb77497994',
  'Lydia White',
  'Lydia White',
  'Lydia',
  'lydia.white38@jum.org',
  '+44774842788',
  'member',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Nairobi assembly. Active in fellowship and serving the community.',
  NOW() - interval '66 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '0c01fe67-dc09-582a-9ec2-d9f5119d14fa',
  'jude.fatoda39@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Jude Fatoda","name":"Jude Fatoda"}',
  NOW() - interval '76 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '0c01fe67-dc09-582a-9ec2-d9f5119d14fa',
  'Jude Fatoda',
  'Jude Fatoda',
  'Jude',
  'jude.fatoda39@jum.org',
  '+234807730428',
  'member',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Lagos assembly. Active in fellowship and serving the community.',
  NOW() - interval '67 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '2b34af49-23ce-53a0-ba9e-0ddc7662b96e',
  'phoebe.harris40@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Phoebe Harris","name":"Phoebe Harris"}',
  NOW() - interval '25 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '2b34af49-23ce-53a0-ba9e-0ddc7662b96e',
  'Phoebe Harris',
  'Phoebe Harris',
  'Phoebe',
  'phoebe.harris40@jum.org',
  '+44774539704',
  'member',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Atlanta assembly. Active in fellowship and serving the community.',
  NOW() - interval '41 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '99dd01fe-5504-5101-ab8c-311cef05ec2f',
  'mark.ibrahim41@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Mark Ibrahim","name":"Mark Ibrahim"}',
  NOW() - interval '38 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '99dd01fe-5504-5101-ab8c-311cef05ec2f',
  'Mark Ibrahim',
  'Mark Ibrahim',
  'Mark',
  'mark.ibrahim41@jum.org',
  '+44776279418',
  'member',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Manchester assembly. Active in fellowship and serving the community.',
  NOW() - interval '18 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '1584522d-e8df-5ca4-b3b1-8d8d6d592aab',
  'chloe.martin42@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Chloe Martin","name":"Chloe Martin"}',
  NOW() - interval '53 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '1584522d-e8df-5ca4-b3b1-8d8d6d592aab',
  'Chloe Martin',
  'Chloe Martin',
  'Chloe',
  'chloe.martin42@jum.org',
  '+44779375710',
  'member',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Houston assembly. Active in fellowship and serving the community.',
  NOW() - interval '12 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'ce604ae9-9457-559c-b0eb-f2066025c432',
  'luke.oyetola43@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Luke Oyetola","name":"Luke Oyetola"}',
  NOW() - interval '85 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'ce604ae9-9457-559c-b0eb-f2066025c432',
  'Luke Oyetola',
  'Luke Oyetola',
  'Luke',
  'luke.oyetola43@jum.org',
  '+44778698256',
  'member',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Accra assembly. Active in fellowship and serving the community.',
  NOW() - interval '80 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '84eb7717-eca7-5f31-8de8-6428d9fb3a5b',
  'joanna.thompson44@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Joanna Thompson","name":"Joanna Thompson"}',
  NOW() - interval '39 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '84eb7717-eca7-5f31-8de8-6428d9fb3a5b',
  'Joanna Thompson',
  'Joanna Thompson',
  'Joanna',
  'joanna.thompson44@jum.org',
  '+44773342608',
  'member',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM London assembly. Active in fellowship and serving the community.',
  NOW() - interval '85 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '2a217c04-42ca-58b2-90e9-1be20d2a1932',
  'jonathan.obi45@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Jonathan Obi","name":"Jonathan Obi"}',
  NOW() - interval '38 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '2a217c04-42ca-58b2-90e9-1be20d2a1932',
  'Jonathan Obi',
  'Jonathan Obi',
  'Jonathan',
  'jonathan.obi45@jum.org',
  '+44775408072',
  'member',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Houston assembly. Active in fellowship and serving the community.',
  NOW() - interval '10 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'ef7ea51c-bcc3-5a18-aa91-f12fbdc904d9',
  'salome.garcia46@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Salome Garcia","name":"Salome Garcia"}',
  NOW() - interval '19 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'ef7ea51c-bcc3-5a18-aa91-f12fbdc904d9',
  'Salome Garcia',
  'Salome Garcia',
  'Salome',
  'salome.garcia46@jum.org',
  '+44777700828',
  'member',
  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Manchester assembly. Active in fellowship and serving the community.',
  NOW() - interval '100 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '12dd726a-5da0-598a-97a1-e68380a42e5b',
  'barnabas.babalola47@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Barnabas Babalola","name":"Barnabas Babalola"}',
  NOW() - interval '90 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '12dd726a-5da0-598a-97a1-e68380a42e5b',
  'Barnabas Babalola',
  'Barnabas Babalola',
  'Barnabas',
  'barnabas.babalola47@jum.org',
  '+44773320821',
  'member',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Nairobi assembly. Active in fellowship and serving the community.',
  NOW() - interval '17 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  'dc484d29-e587-5d05-a5d2-33676131d98d',
  'bernice.martinez48@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Bernice Martinez","name":"Bernice Martinez"}',
  NOW() - interval '39 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  'dc484d29-e587-5d05-a5d2-33676131d98d',
  'Bernice Martinez',
  'Bernice Martinez',
  'Bernice',
  'bernice.martinez48@jum.org',
  '+44772525206',
  'member',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM New York assembly. Active in fellowship and serving the community.',
  NOW() - interval '18 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '7faa6c92-a906-511a-aec9-2d32c5754bcd',
  'titus.umeh49@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Titus Umeh","name":"Titus Umeh"}',
  NOW() - interval '14 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '7faa6c92-a906-511a-aec9-2d32c5754bcd',
  'Titus Umeh',
  'Titus Umeh',
  'Titus',
  'titus.umeh49@jum.org',
  '+234803564251',
  'member',
  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM Lagos assembly. Active in fellowship and serving the community.',
  NOW() - interval '52 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)
VALUES (
  '55ef8a93-c32f-5f5e-a5c7-0923a351e57b',
  'rhoda.robinson50@jum.org',
  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Rhoda Robinson","name":"Rhoda Robinson"}',
  NOW() - interval '19 days',
  NOW(),
  'authenticated',
  'authenticated',
  false
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)
VALUES (
  '55ef8a93-c32f-5f5e-a5c7-0923a351e57b',
  'Rhoda Robinson',
  'Rhoda Robinson',
  'Rhoda',
  'rhoda.robinson50@jum.org',
  '+44778082668',
  'member',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200',
  'Faithful member at JUM London assembly. Active in fellowship and serving the community.',
  NOW() - interval '75 days',
  NOW()
) ON CONFLICT (id) DO NOTHING;

-- ── 2. SERMON SERIES ────────────────────────────────────────
INSERT INTO public.sermon_series (id, title, description, banner_url, created_at)
VALUES ('bb0a699e-3942-5514-adaa-2455a3ffe1ef', 'Unshakable Faith', 'Building a solid foundation of trust in God''s promises amidst life''s challenges.', 'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800', NOW() - interval '90 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sermon_series (id, title, description, banner_url, created_at)
VALUES ('a1e50289-de11-512a-b753-fef428856379', 'Walking in Victory', 'Keys to overcoming spiritual, financial, and personal limitations through the word.', 'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800', NOW() - interval '90 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sermon_series (id, title, description, banner_url, created_at)
VALUES ('54792132-3743-5d42-b3cc-832fac32a5bf', 'The Power of Praise', 'Exploring how thanksgiving and worship unlock breakthroughs and spiritual authority.', 'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&q=80&w=800', NOW() - interval '90 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sermon_series (id, title, description, banner_url, created_at)
VALUES ('a30746c2-de64-59b0-ad63-950f76a81593', 'Grace That Restores', 'Understanding the depth of God''s unmerited favor to heal brokenness and renew hope.', 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80&w=800', NOW() - interval '90 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.sermon_series (id, title, description, banner_url, created_at)
VALUES ('d0132517-6870-5319-99dc-81812054687c', 'Kingdom Leadership', 'Principles for leading families, workplaces, and assemblies according to Biblical standards.', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=800', NOW() - interval '90 days') ON CONFLICT (id) DO NOTHING;

-- ── 3. SERMONS ──────────────────────────────────────────────
INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  'fac30312-1676-52e3-bfdc-ab60b3f00287',
  'a1e50289-de11-512a-b753-fef428856379',
  'Reclaiming Your Spiritual Authority',
  'In this sermon, Pastor Kingsley preaches on the believer authority in Christ, teaching practical steps to overcome doubt and walk in absolute victory in every sphere of life.',
  'Pastor Kingsley Aniche',
  NOW(),
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  2450,
  'dQw4w9WgXcQ',
  NOW(),
  NOW()
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '7cc93638-a486-5ace-99cd-056bc620420e',
  'a1e50289-de11-512a-b753-fef428856379',
  'Sermon Part 1: Walking in Victory Deep Dive',
  'An in-depth study expanding on Walking in Victory. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Dr. David Vance',
  NOW() - interval '1 days',
  'https://www.youtube.com/watch?v=2Vv-BfVoq4g',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  1850,
  '2Vv-BfVoq4g',
  NOW() - interval '1 days',
  NOW() - interval '1 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  'e3463dcf-f00b-5c69-9aac-7ce87247e9b3',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 2: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Grace Adebayo',
  NOW() - interval '2 days',
  'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  1900,
  '3JZ_D3ELwOQ',
  NOW() - interval '2 days',
  NOW() - interval '2 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  'c7ec32bf-be0b-564d-b2ae-4fdefafac186',
  'd0132517-6870-5319-99dc-81812054687c',
  'Sermon Part 3: Kingdom Leadership Deep Dive',
  'An in-depth study expanding on Kingdom Leadership. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Grace Adebayo',
  NOW() - interval '3 days',
  'https://www.youtube.com/watch?v=VbfpW0yocdQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  1950,
  'VbfpW0yocdQ',
  NOW() - interval '3 days',
  NOW() - interval '3 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  'f020354b-bc58-578f-9592-92030338ac96',
  'd0132517-6870-5319-99dc-81812054687c',
  'Sermon Part 4: Kingdom Leadership Deep Dive',
  'An in-depth study expanding on Kingdom Leadership. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Evangelist Joshua Okonkwo',
  NOW() - interval '4 days',
  'https://www.youtube.com/watch?v=L_LUpnjgPso',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  2000,
  'L_LUpnjgPso',
  NOW() - interval '4 days',
  NOW() - interval '4 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '9b7e704e-a6db-5526-a67f-01762db63e02',
  'a1e50289-de11-512a-b753-fef428856379',
  'Sermon Part 5: Walking in Victory Deep Dive',
  'An in-depth study expanding on Walking in Victory. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Evangelist Joshua Okonkwo',
  NOW() - interval '5 days',
  'https://www.youtube.com/watch?v=hT_nvWreIhg',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  2050,
  'hT_nvWreIhg',
  NOW() - interval '5 days',
  NOW() - interval '5 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '9320db99-7bc3-56f4-8f16-9254329ff00f',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 6: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Grace Adebayo',
  NOW() - interval '6 days',
  'https://www.youtube.com/watch?v=9bZkp7q19f0',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  2100,
  '9bZkp7q19f0',
  NOW() - interval '6 days',
  NOW() - interval '6 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '00aeae8a-be23-5559-92ce-62b9b310c6f2',
  'bb0a699e-3942-5514-adaa-2455a3ffe1ef',
  'Sermon Part 7: Unshakable Faith Deep Dive',
  'An in-depth study expanding on Unshakable Faith. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Kingsley Aniche',
  NOW() - interval '7 days',
  'https://www.youtube.com/watch?v=2Vv-BfVoq4g',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  2150,
  '2Vv-BfVoq4g',
  NOW() - interval '7 days',
  NOW() - interval '7 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '9627fbd2-ad53-5db5-bbfa-763f6d1dcdc6',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 8: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Dr. David Vance',
  NOW() - interval '8 days',
  'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  2200,
  '3JZ_D3ELwOQ',
  NOW() - interval '8 days',
  NOW() - interval '8 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '3d10de6b-293e-5734-8f5a-58573e15c7a7',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 9: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Evangelist Joshua Okonkwo',
  NOW() - interval '9 days',
  'https://www.youtube.com/watch?v=VbfpW0yocdQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  2250,
  'VbfpW0yocdQ',
  NOW() - interval '9 days',
  NOW() - interval '9 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '11669f95-0a28-5642-aa35-f2c408ea6e74',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 10: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Kingsley Aniche',
  NOW() - interval '10 days',
  'https://www.youtube.com/watch?v=L_LUpnjgPso',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  2300,
  'L_LUpnjgPso',
  NOW() - interval '10 days',
  NOW() - interval '10 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  'c31b68b7-8440-5bf6-bada-4cf6c8aad9c7',
  'bb0a699e-3942-5514-adaa-2455a3ffe1ef',
  'Sermon Part 11: Unshakable Faith Deep Dive',
  'An in-depth study expanding on Unshakable Faith. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Kingsley Aniche',
  NOW() - interval '11 days',
  'https://www.youtube.com/watch?v=hT_nvWreIhg',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  2350,
  'hT_nvWreIhg',
  NOW() - interval '11 days',
  NOW() - interval '11 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '4512cd3d-5b1b-517d-9d46-b8c31860587a',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 12: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Dr. David Vance',
  NOW() - interval '12 days',
  'https://www.youtube.com/watch?v=9bZkp7q19f0',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  2400,
  '9bZkp7q19f0',
  NOW() - interval '12 days',
  NOW() - interval '12 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '4d28353e-f8b3-5c41-ab01-22242b575710',
  'bb0a699e-3942-5514-adaa-2455a3ffe1ef',
  'Sermon Part 13: Unshakable Faith Deep Dive',
  'An in-depth study expanding on Unshakable Faith. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Grace Adebayo',
  NOW() - interval '13 days',
  'https://www.youtube.com/watch?v=2Vv-BfVoq4g',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  2450,
  '2Vv-BfVoq4g',
  NOW() - interval '13 days',
  NOW() - interval '13 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '29ec0f86-0d21-51ab-b39e-c21fb9cf7c0a',
  'a1e50289-de11-512a-b753-fef428856379',
  'Sermon Part 14: Walking in Victory Deep Dive',
  'An in-depth study expanding on Walking in Victory. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Grace Adebayo',
  NOW() - interval '14 days',
  'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  2500,
  '3JZ_D3ELwOQ',
  NOW() - interval '14 days',
  NOW() - interval '14 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  'f96a310f-1433-5d09-aff1-f87517578783',
  'd0132517-6870-5319-99dc-81812054687c',
  'Sermon Part 15: Kingdom Leadership Deep Dive',
  'An in-depth study expanding on Kingdom Leadership. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Evangelist Joshua Okonkwo',
  NOW() - interval '15 days',
  'https://www.youtube.com/watch?v=VbfpW0yocdQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  2550,
  'VbfpW0yocdQ',
  NOW() - interval '15 days',
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '171460e7-3635-5521-9064-d87fcaae2398',
  'a1e50289-de11-512a-b753-fef428856379',
  'Sermon Part 16: Walking in Victory Deep Dive',
  'An in-depth study expanding on Walking in Victory. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Evangelist Joshua Okonkwo',
  NOW() - interval '16 days',
  'https://www.youtube.com/watch?v=L_LUpnjgPso',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  2600,
  'L_LUpnjgPso',
  NOW() - interval '16 days',
  NOW() - interval '16 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  'faf7b205-0eb3-5380-970a-f4a6bd19e4be',
  'a1e50289-de11-512a-b753-fef428856379',
  'Sermon Part 17: Walking in Victory Deep Dive',
  'An in-depth study expanding on Walking in Victory. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Dr. David Vance',
  NOW() - interval '17 days',
  'https://www.youtube.com/watch?v=hT_nvWreIhg',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  2650,
  'hT_nvWreIhg',
  NOW() - interval '17 days',
  NOW() - interval '17 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '66e669c3-52bf-5b6f-aae7-319321f95139',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 18: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Grace Adebayo',
  NOW() - interval '18 days',
  'https://www.youtube.com/watch?v=9bZkp7q19f0',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  2700,
  '9bZkp7q19f0',
  NOW() - interval '18 days',
  NOW() - interval '18 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '013a90cf-d80a-55a5-aff5-d04b2a673e59',
  'bb0a699e-3942-5514-adaa-2455a3ffe1ef',
  'Sermon Part 19: Unshakable Faith Deep Dive',
  'An in-depth study expanding on Unshakable Faith. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Evangelist Joshua Okonkwo',
  NOW() - interval '19 days',
  'https://www.youtube.com/watch?v=2Vv-BfVoq4g',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  2750,
  '2Vv-BfVoq4g',
  NOW() - interval '19 days',
  NOW() - interval '19 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '79f2dd7a-2283-5bef-80c4-f9a2a269e535',
  'd0132517-6870-5319-99dc-81812054687c',
  'Sermon Part 20: Kingdom Leadership Deep Dive',
  'An in-depth study expanding on Kingdom Leadership. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Kingsley Aniche',
  NOW() - interval '20 days',
  'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  2800,
  '3JZ_D3ELwOQ',
  NOW() - interval '20 days',
  NOW() - interval '20 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '3cb4ef11-2de4-5bfd-801a-d8a097ac377e',
  'bb0a699e-3942-5514-adaa-2455a3ffe1ef',
  'Sermon Part 21: Unshakable Faith Deep Dive',
  'An in-depth study expanding on Unshakable Faith. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Kingsley Aniche',
  NOW() - interval '21 days',
  'https://www.youtube.com/watch?v=VbfpW0yocdQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  2850,
  'VbfpW0yocdQ',
  NOW() - interval '21 days',
  NOW() - interval '21 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '144ac8a9-2484-58d2-a216-a3af68bb67c7',
  'bb0a699e-3942-5514-adaa-2455a3ffe1ef',
  'Sermon Part 22: Unshakable Faith Deep Dive',
  'An in-depth study expanding on Unshakable Faith. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Grace Adebayo',
  NOW() - interval '22 days',
  'https://www.youtube.com/watch?v=L_LUpnjgPso',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  2900,
  'L_LUpnjgPso',
  NOW() - interval '22 days',
  NOW() - interval '22 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '93939b70-3298-5447-9226-d3716ab22e22',
  'a1e50289-de11-512a-b753-fef428856379',
  'Sermon Part 23: Walking in Victory Deep Dive',
  'An in-depth study expanding on Walking in Victory. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Evangelist Joshua Okonkwo',
  NOW() - interval '23 days',
  'https://www.youtube.com/watch?v=hT_nvWreIhg',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  2950,
  'hT_nvWreIhg',
  NOW() - interval '23 days',
  NOW() - interval '23 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  'af9f9db2-fc04-55d9-a30b-464ab5f73718',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 24: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Evangelist Joshua Okonkwo',
  NOW() - interval '24 days',
  'https://www.youtube.com/watch?v=9bZkp7q19f0',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  3000,
  '9bZkp7q19f0',
  NOW() - interval '24 days',
  NOW() - interval '24 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  'ca944877-a8b2-520c-be99-373be32de889',
  'a1e50289-de11-512a-b753-fef428856379',
  'Sermon Part 25: Walking in Victory Deep Dive',
  'An in-depth study expanding on Walking in Victory. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Evangelist Joshua Okonkwo',
  NOW() - interval '25 days',
  'https://www.youtube.com/watch?v=2Vv-BfVoq4g',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  3050,
  '2Vv-BfVoq4g',
  NOW() - interval '25 days',
  NOW() - interval '25 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '8d7b89de-4ddd-5aaf-a9a4-7a412d755ac5',
  'bb0a699e-3942-5514-adaa-2455a3ffe1ef',
  'Sermon Part 26: Unshakable Faith Deep Dive',
  'An in-depth study expanding on Unshakable Faith. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Grace Adebayo',
  NOW() - interval '26 days',
  'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  3100,
  '3JZ_D3ELwOQ',
  NOW() - interval '26 days',
  NOW() - interval '26 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  'b22f1a32-2ecc-54a6-a6d4-e1f0435fe836',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 27: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Pastor Kingsley Aniche',
  NOW() - interval '27 days',
  'https://www.youtube.com/watch?v=VbfpW0yocdQ',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  3150,
  'VbfpW0yocdQ',
  NOW() - interval '27 days',
  NOW() - interval '27 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '8ece3a37-0189-5c51-a655-86b9b36608af',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 28: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Dr. David Vance',
  NOW() - interval '28 days',
  'https://www.youtube.com/watch?v=L_LUpnjgPso',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
  'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800',
  3200,
  'L_LUpnjgPso',
  NOW() - interval '28 days',
  NOW() - interval '28 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)
VALUES (
  '7a22c810-7863-51af-acd1-974e57775697',
  'a30746c2-de64-59b0-ad63-950f76a81593',
  'Sermon Part 29: Grace That Restores Deep Dive',
  'An in-depth study expanding on Grace That Restores. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.',
  'Dr. David Vance',
  NOW() - interval '29 days',
  'https://www.youtube.com/watch?v=hT_nvWreIhg',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
  'https://images.unsplash.com/photo-1465847899084?auto=format&fit=crop&q=80&w=800',
  3250,
  'hT_nvWreIhg',
  NOW() - interval '29 days',
  NOW() - interval '29 days'
) ON CONFLICT (id) DO NOTHING;

-- ── 4. PODCASTS ─────────────────────────────────────────────
INSERT INTO public.podcasts (id, title, description, cover_url, created_at)
VALUES ('1f349514-6c2b-5587-aa75-031711250a8e', 'Unhindered Grace Podcast', 'Conversations on radical grace, faith, and practical christian living with Senior Pastor Kingsley Aniche and guests.', 'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?auto=format&fit=crop&q=80&w=400', NOW() - interval '60 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.podcasts (id, title, description, cover_url, created_at)
VALUES ('e2f7187c-1d5b-5915-a99f-e22999a8b8a0', 'Kingdom Wisdom Daily', 'Daily mini-episodes packing powerful kingdom principles for leading, working, and growing in grace.', 'https://images.unsplash.com/photo-1478737270239-2f02b77fc618?auto=format&fit=crop&q=80&w=400', NOW() - interval '60 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.podcasts (id, title, description, cover_url, created_at)
VALUES ('a5fbaf76-ecd2-5556-b5de-4c70b780de5d', 'The Faith Builder Show', 'Testimonies, deep studies, and discussions targeted at expanding personal faith and understanding of scriptural truths.', 'https://images.unsplash.com/photo-1589903308904-1010c2294adc?auto=format&fit=crop&q=80&w=400', NOW() - interval '60 days') ON CONFLICT (id) DO NOTHING;

-- ── 5. PODCAST EPISODES ─────────────────────────────────────
INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  '687014aa-9263-599c-97da-2e7c98703f7b',
  'e2f7187c-1d5b-5915-a99f-e22999a8b8a0',
  'Episode 1: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  1240,
  NOW() - interval '2 days',
  NOW() - interval '2 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  'fb8a3a5f-342c-51eb-bc16-e772e573cb21',
  'a5fbaf76-ecd2-5556-b5de-4c70b780de5d',
  'Episode 2: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  1280,
  NOW() - interval '4 days',
  NOW() - interval '4 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  '42bc6fda-d805-5b82-a086-d8cc17cd0f2b',
  '1f349514-6c2b-5587-aa75-031711250a8e',
  'Episode 3: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
  1320,
  NOW() - interval '6 days',
  NOW() - interval '6 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  '28de1a37-ce08-50e0-80ec-f25c2402f72a',
  'e2f7187c-1d5b-5915-a99f-e22999a8b8a0',
  'Episode 4: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
  1360,
  NOW() - interval '8 days',
  NOW() - interval '8 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  '74a797e3-eca3-56c7-b0cc-2f4c51ae593a',
  'a5fbaf76-ecd2-5556-b5de-4c70b780de5d',
  'Episode 5: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
  1400,
  NOW() - interval '10 days',
  NOW() - interval '10 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  '7ccb70cd-6983-569e-bb79-d0d877c62d1d',
  '1f349514-6c2b-5587-aa75-031711250a8e',
  'Episode 6: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  1440,
  NOW() - interval '12 days',
  NOW() - interval '12 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  'ad923777-b800-55a3-bbec-f4e1adfa3479',
  'e2f7187c-1d5b-5915-a99f-e22999a8b8a0',
  'Episode 7: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  1480,
  NOW() - interval '14 days',
  NOW() - interval '14 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  '41a9bbc8-459e-5b5e-8544-3816b2087221',
  'a5fbaf76-ecd2-5556-b5de-4c70b780de5d',
  'Episode 8: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  1520,
  NOW() - interval '16 days',
  NOW() - interval '16 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  'f6e8f5b7-ec94-576e-8e76-2e89c09629db',
  '1f349514-6c2b-5587-aa75-031711250a8e',
  'Episode 9: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
  1560,
  NOW() - interval '18 days',
  NOW() - interval '18 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  '065764a8-4f9b-5b4d-adf7-167be7d1cd83',
  'e2f7187c-1d5b-5915-a99f-e22999a8b8a0',
  'Episode 10: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
  1600,
  NOW() - interval '20 days',
  NOW() - interval '20 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  '0a727005-e462-5511-93c7-40a57cc6e820',
  'a5fbaf76-ecd2-5556-b5de-4c70b780de5d',
  'Episode 11: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
  1640,
  NOW() - interval '22 days',
  NOW() - interval '22 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  'fb8280d2-1dc8-57b2-b47a-552fe2ff7092',
  '1f349514-6c2b-5587-aa75-031711250a8e',
  'Episode 12: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  1680,
  NOW() - interval '24 days',
  NOW() - interval '24 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  '736cef54-d14a-5297-83b4-40d4cb721c7c',
  'e2f7187c-1d5b-5915-a99f-e22999a8b8a0',
  'Episode 13: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  1720,
  NOW() - interval '26 days',
  NOW() - interval '26 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  'fd7d1b3c-6c12-53d5-803f-a76a67991d54',
  'a5fbaf76-ecd2-5556-b5de-4c70b780de5d',
  'Episode 14: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  1760,
  NOW() - interval '28 days',
  NOW() - interval '28 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)
VALUES (
  '637aace4-917e-5e58-bf5b-0b722353b91c',
  '1f349514-6c2b-5587-aa75-031711250a8e',
  'Episode 15: Radical Generosity & Stewardship',
  'In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
  1800,
  NOW() - interval '30 days',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

-- ── 6. EVENTS ───────────────────────────────────────────────
INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  'a9d2e81f-567d-50f9-bdb7-7726ef8da82a',
  'JUM Annual Thanksgiving Retreat 2025',
  'A three-day spiritual renewal retreat for families to fellowship and start the new year in prayers.',
  NOW() + interval '-180 days',
  'JUM Campgrounds, Lagos',
  'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=800',
  false,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '9a0eff76-2319-5da8-b471-6569495d4e76',
  'Christmas Praise & Carol Night',
  'Worship, music recital, and fellowship night honoring the birth of Christ Jesus.',
  NOW() + interval '-190 days',
  'Main Auditorium, JUM Lagos campus',
  'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&q=80&w=800',
  false,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '481f3fe1-29c1-52cd-a28a-1d5cf5e458cf',
  'Workers and Leaders Consecration',
  'Consecration and charge service for all JUM workforce leaders and volunteers.',
  NOW() + interval '-15 days',
  'Seminar Hall, Lagos',
  'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=800',
  false,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '157443b7-c739-5c3a-b837-652cba4a18b6',
  'Leadership Summit 2026',
  'Empowering leaders across all domains with solid biblical truths, networking, and strategy.',
  NOW() + interval '0 days',
  'Main Auditorium & Live broadcast',
  'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&q=80&w=800',
  true,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  'fc84ded5-abb8-53c9-a74b-55ea3169c17c',
  'National Youth Power Conference 2026',
  'An explosive conference for youths featuring powerful preaching, career workshops, and worship.',
  NOW() + interval '15 days',
  'Lagos Exhibition Center',
  'https://images.unsplash.com/photo-1517263904808-5dc91e3e7044?auto=format&fit=crop&q=80&w=800',
  true,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '33fc58b3-5f00-5b9c-afa9-4970fbf55a43',
  'Global Prayer and Intercession Assembly',
  'Standing in the gap for nations. A 24-hour prayer chain connecting believers from all continents.',
  NOW() + interval '30 days',
  'Virtual Assembly & JUM campuses',
  'https://images.unsplash.com/photo-1544027993-37dbfe43562a?auto=format&fit=crop&q=80&w=800',
  true,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '8af1553b-66ba-5dd2-a2bf-1150827d685d',
  'Grace and Healing Miracle Night',
  'A night dedicated to prayers for the sick, deliverance, and experience of God''s restoration power.',
  NOW() + interval '45 days',
  'Lagos State Stadium Grounds',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  false,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '49cf4315-7f5c-54d6-a133-39a555d271c2',
  'Kingdom Finances and Wealth Seminar',
  'Biblical financial management, investments, and understanding covenant keys to business success.',
  NOW() + interval '60 days',
  'JUM Lagos Multi-purpose Hall',
  'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&q=80&w=800',
  false,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  'e47a1fb7-4fb3-5224-a7d1-64463d00dd74',
  'JUM Global Praise Festival 2026',
  'Praise concert hosting multiple gospel ministers and choirs, celebrating unhindered miracles.',
  NOW() + interval '75 days',
  'Main Auditorium, Lagos Campus',
  'https://images.unsplash.com/photo-1506157786151-b8491531f063?auto=format&fit=crop&q=80&w=800',
  false,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '2ca56a9c-7c88-5349-b80f-fa27af562e85',
  'Ministry Outreach Seminar Part 1',
  'Equipping volunteers for local missions and community engagements.',
  NOW() + interval '90 days',
  'Online / Zoom Conference',
  'https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&q=80&w=800',
  false,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '6c80f297-ccba-53bd-a84f-84c892e9cda9',
  'Ministry Outreach Seminar Part 2',
  'Equipping volunteers for local missions and community engagements.',
  NOW() + interval '100 days',
  'Online / Zoom Conference',
  'https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&q=80&w=800',
  false,
  false,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '54b90f3f-5db8-546a-a157-cedbf47a8af8',
  'Ministry Outreach Seminar Part 3',
  'Equipping volunteers for local missions and community engagements.',
  NOW() + interval '110 days',
  'Online / Zoom Conference',
  'https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&q=80&w=800',
  false,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  'd4496b72-b568-5b79-aef3-59345936cc71',
  'Ministry Outreach Seminar Part 4',
  'Equipping volunteers for local missions and community engagements.',
  NOW() + interval '120 days',
  'Online / Zoom Conference',
  'https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&q=80&w=800',
  false,
  false,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '83dd8a36-badc-5a80-a800-6bf02b9ac3e4',
  'Ministry Outreach Seminar Part 5',
  'Equipping volunteers for local missions and community engagements.',
  NOW() + interval '130 days',
  'Online / Zoom Conference',
  'https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&q=80&w=800',
  false,
  true,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)
VALUES (
  '5aeaac67-0358-52a6-8e44-2dd542d714b6',
  'Ministry Outreach Seminar Part 6',
  'Equipping volunteers for local missions and community engagements.',
  NOW() + interval '140 days',
  'Online / Zoom Conference',
  'https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&q=80&w=800',
  false,
  false,
  '09:00 AM',
  '01:00 PM',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

-- ── 7. EVENT REGISTRATIONS ──────────────────────────────────
INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '8c10417d-67dd-5487-870a-90d3bf735700',
  '9a0eff76-2319-5da8-b471-6569495d4e76',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  'registered',
  'JUM-9a0eff76-9cd5f6ad-1',
  NOW() - interval '1 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '28ce7bfe-a5bb-5d0b-9af4-12d850e55720',
  '481f3fe1-29c1-52cd-a28a-1d5cf5e458cf',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  'registered',
  'JUM-481f3fe1-b43f27b8-2',
  NOW() - interval '2 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '8fc2f21c-8c63-56b7-83f5-a956e4a1e9b4',
  '157443b7-c739-5c3a-b837-652cba4a18b6',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  'registered',
  'JUM-157443b7-71f38ffd-3',
  NOW() - interval '3 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '8656004b-c3df-5240-9ad8-af498ddbd056',
  'fc84ded5-abb8-53c9-a74b-55ea3169c17c',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  'registered',
  'JUM-fc84ded5-9aea834a-4',
  NOW() - interval '4 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '8507e537-b515-5696-82df-e27c15483ee2',
  'a9d2e81f-567d-50f9-bdb7-7726ef8da82a',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  'registered',
  'JUM-a9d2e81f-3ffeaaf1-5',
  NOW() - interval '5 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  'e438d73f-6841-58f2-8c14-89e8bb4dbe66',
  '9a0eff76-2319-5da8-b471-6569495d4e76',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  'registered',
  'JUM-9a0eff76-5006102e-6',
  NOW() - interval '6 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  'd7aee9a5-f1d4-5fe1-bf97-248057c8a97a',
  '481f3fe1-29c1-52cd-a28a-1d5cf5e458cf',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  'registered',
  'JUM-481f3fe1-b47acb94-7',
  NOW() - interval '7 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  'ab2c6e99-108b-594a-b964-c8473df71bfe',
  '157443b7-c739-5c3a-b837-652cba4a18b6',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  'registered',
  'JUM-157443b7-cdf0b106-8',
  NOW() - interval '8 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '3711dec1-bf1d-54ff-8b1e-888efa94e1ab',
  'fc84ded5-abb8-53c9-a74b-55ea3169c17c',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  'registered',
  'JUM-fc84ded5-fdef44c0-9',
  NOW() - interval '9 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  'e35dea9a-9ea9-5175-8267-c61eccb535a7',
  'a9d2e81f-567d-50f9-bdb7-7726ef8da82a',
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  'registered',
  'JUM-a9d2e81f-2e67cc75-10',
  NOW() - interval '10 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  'ceb1b171-2283-5239-9352-656fd79affd7',
  '9a0eff76-2319-5da8-b471-6569495d4e76',
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  'registered',
  'JUM-9a0eff76-d270b6cf-11',
  NOW() - interval '11 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '45ef0e8a-6ae5-508a-a693-e0d1d4245644',
  '481f3fe1-29c1-52cd-a28a-1d5cf5e458cf',
  '8a11f317-311d-5241-b8a0-455f712265b5',
  'registered',
  'JUM-481f3fe1-8a11f317-12',
  NOW() - interval '12 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '38bc41b0-1be9-5160-8719-8f9818cf1b00',
  '157443b7-c739-5c3a-b837-652cba4a18b6',
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  'registered',
  'JUM-157443b7-51e088ae-13',
  NOW() - interval '13 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  'f1bf8847-edea-5055-b42c-ef30e7a5c72f',
  'fc84ded5-abb8-53c9-a74b-55ea3169c17c',
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  'registered',
  'JUM-fc84ded5-030eb783-14',
  NOW() - interval '14 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '93699ec7-cbe6-5772-a225-da16401cabc5',
  'a9d2e81f-567d-50f9-bdb7-7726ef8da82a',
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  'registered',
  'JUM-a9d2e81f-981d2863-15',
  NOW() - interval '15 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  'e152e8df-4bb4-589f-ac9e-ed5bc846d5d9',
  '9a0eff76-2319-5da8-b471-6569495d4e76',
  '1164ec13-a4de-5cc0-8eac-eb8833b16640',
  'registered',
  'JUM-9a0eff76-1164ec13-16',
  NOW() - interval '16 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  'bd1113d1-214a-5e38-b188-55e5bf5b5347',
  '481f3fe1-29c1-52cd-a28a-1d5cf5e458cf',
  '1c27aaa9-2781-5750-9b68-25fee3a17b99',
  'registered',
  'JUM-481f3fe1-1c27aaa9-17',
  NOW() - interval '17 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '0db9c40e-1764-5606-a6d4-a82d19a4ad7f',
  '157443b7-c739-5c3a-b837-652cba4a18b6',
  '7126763d-b662-5599-8069-51cbfe88a56a',
  'registered',
  'JUM-157443b7-7126763d-18',
  NOW() - interval '18 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  '646a5435-77b0-518e-af80-c7aa4e08b155',
  'fc84ded5-abb8-53c9-a74b-55ea3169c17c',
  '7a9058c3-61ed-5188-b233-69fca99e66c0',
  'registered',
  'JUM-fc84ded5-7a9058c3-19',
  NOW() - interval '19 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)
VALUES (
  'a75de323-0672-5048-8ebf-7e88887f3970',
  'a9d2e81f-567d-50f9-bdb7-7726ef8da82a',
  'e453775a-166a-54df-a5b2-0081c12608dd',
  'registered',
  'JUM-a9d2e81f-e453775a-20',
  NOW() - interval '20 days'
) ON CONFLICT (event_id, user_id) DO NOTHING;

-- ── 8. GROUPS ───────────────────────────────────────────────
INSERT INTO public.groups (id, name, description, banner_url, leader_id, created_at)
VALUES ('1777a39a-f512-5938-9d0c-9fa62d3dcf1c', 'Ushering Unit', 'Service unit ensuring orderliness, ushering guests, and maintaining sanctuary decorum.', 'https://images.unsplash.com/photo-1528605248644-14dd04022da1?auto=format&fit=crop&q=80&w=600', 'fdef44c0-1ceb-5bc3-966a-4f1054c46fac', NOW() - interval '120 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.groups (id, name, description, banner_url, leader_id, created_at)
VALUES ('7bc218ea-f5d4-51c1-956a-aa03647d3941', 'Levites Choir', 'Sanctuary choir leading praise, worship, and vocal ministrations during services.', 'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&q=80&w=600', '9aea834a-81d0-586a-986e-987fa8a71d2a', NOW() - interval '120 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.groups (id, name, description, banner_url, leader_id, created_at)
VALUES ('b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', 'Media & Streaming', 'Technical service unit managing sound, video recording, live feeds, and screens.', 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&q=80&w=600', '71f38ffd-beb1-5ecb-90cf-014856476afe', NOW() - interval '120 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.groups (id, name, description, banner_url, leader_id, created_at)
VALUES ('dc2fae36-554f-53b2-96d0-4d89bac43fac', 'Youth Fellowship', 'Vibrant fellowship for youths, students, and young professionals. Ignite & Shine.', 'https://images.unsplash.com/photo-1517263904808-5dc91e3e7044?auto=format&fit=crop&q=80&w=600', '3ffeaaf1-0cae-5bc2-b729-55f9a447691e', NOW() - interval '120 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.groups (id, name, description, banner_url, leader_id, created_at)
VALUES ('2f16d8da-5c97-5c47-9bd5-d276e84cfce5', 'Prayer Warriors', 'Intercessory prayer squad meeting weekly for spiritual warfare and church protection.', 'https://images.unsplash.com/photo-1544027993-37dbfe43562a?auto=format&fit=crop&q=80&w=600', '5006102e-5fe9-5473-82f1-f67c327172d0', NOW() - interval '120 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.groups (id, name, description, banner_url, leader_id, created_at)
VALUES ('0d252de5-467a-598a-842f-dfa948f483d5', 'Missions Outpost', 'Evangelism and community welfare outreach organizing local campaigns and food drives.', 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=600', 'b47acb94-e783-59b0-a1ea-4d1a7ad9a423', NOW() - interval '120 days') ON CONFLICT (id) DO NOTHING;

-- ── 9. GROUP MEMBERS ────────────────────────────────────────
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('015e5351-c942-5dc7-a513-fdcd52a27e3c', '1777a39a-f512-5938-9d0c-9fa62d3dcf1c', 'fdef44c0-1ceb-5bc3-966a-4f1054c46fac', NOW() - interval '110 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('f355d772-93f3-525e-8ae3-2f8e868ac6c4', '1777a39a-f512-5938-9d0c-9fa62d3dcf1c', '6b0dd36d-93f9-504c-abc6-4bf98e01c770', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('24422043-96ee-5378-9b39-cd2c08b9f41f', '1777a39a-f512-5938-9d0c-9fa62d3dcf1c', '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('1d9089e6-c7a9-5782-be12-a00210828531', '1777a39a-f512-5938-9d0c-9fa62d3dcf1c', 'b43f27b8-1c37-5d32-a129-7c2e41e94135', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('35e4902e-12a1-50e7-b722-1984608665ab', '1777a39a-f512-5938-9d0c-9fa62d3dcf1c', '71f38ffd-beb1-5ecb-90cf-014856476afe', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('e5b55470-865b-5da8-b0a4-3345b2f9091f', '1777a39a-f512-5938-9d0c-9fa62d3dcf1c', '9aea834a-81d0-586a-986e-987fa8a71d2a', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('0a6ae946-04a5-5a74-a2e2-5531c5e4dc78', '1777a39a-f512-5938-9d0c-9fa62d3dcf1c', '3ffeaaf1-0cae-5bc2-b729-55f9a447691e', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('fc7e9689-7f96-5e6a-ae14-f19026f0a6f1', '1777a39a-f512-5938-9d0c-9fa62d3dcf1c', '5006102e-5fe9-5473-82f1-f67c327172d0', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('99f93554-ff3b-5491-b2db-6281eb807e4a', '1777a39a-f512-5938-9d0c-9fa62d3dcf1c', 'b47acb94-e783-59b0-a1ea-4d1a7ad9a423', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('0968aa47-1508-52c7-b854-a390f5595532', '1777a39a-f512-5938-9d0c-9fa62d3dcf1c', 'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('78997bab-46f2-510d-a04d-baec919af82a', '7bc218ea-f5d4-51c1-956a-aa03647d3941', '9aea834a-81d0-586a-986e-987fa8a71d2a', NOW() - interval '110 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('55117d9f-340f-5624-8ba5-25dc6c5146a8', '7bc218ea-f5d4-51c1-956a-aa03647d3941', 'fdef44c0-1ceb-5bc3-966a-4f1054c46fac', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('823ad75e-22d6-5e1d-9371-f4dc7f7a7511', '7bc218ea-f5d4-51c1-956a-aa03647d3941', '2e67cc75-477f-5e66-a641-fa76985d10e4', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('0f62dc88-1a76-5329-a5b6-2fa890673ddd', '7bc218ea-f5d4-51c1-956a-aa03647d3941', 'd270b6cf-af4b-5c9b-bada-d37b12e7083d', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('b6717174-4c70-5d8a-9f08-631ead17128a', '7bc218ea-f5d4-51c1-956a-aa03647d3941', '8a11f317-311d-5241-b8a0-455f712265b5', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('b305ec15-dd83-58e8-92fe-06fc64aff0aa', '7bc218ea-f5d4-51c1-956a-aa03647d3941', '51e088ae-312d-5511-8546-14f07c1dd8b2', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('2e20c9a3-081a-5aee-8a4c-d48a48c52bc4', '7bc218ea-f5d4-51c1-956a-aa03647d3941', '030eb783-fe4c-5b65-aee2-a921a1977359', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('b12099d5-250a-55a2-a144-af765054e6a7', '7bc218ea-f5d4-51c1-956a-aa03647d3941', '981d2863-e1cf-5a73-9863-b0b573c71eb7', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('f47ef3e4-8803-5d9c-9669-64fdedc6bbd7', '7bc218ea-f5d4-51c1-956a-aa03647d3941', '1164ec13-a4de-5cc0-8eac-eb8833b16640', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('5dc56648-b147-59a3-9a4b-fac1079318d5', '7bc218ea-f5d4-51c1-956a-aa03647d3941', '1c27aaa9-2781-5750-9b68-25fee3a17b99', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('30157406-d1e8-5bc0-8676-ff4fa53d544f', 'b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', '71f38ffd-beb1-5ecb-90cf-014856476afe', NOW() - interval '110 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('d7944372-f59c-5a0d-8d68-2fa066b80377', 'b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', '7126763d-b662-5599-8069-51cbfe88a56a', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('89aab5ed-0726-5483-8f80-f046249f42d8', 'b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', '7a9058c3-61ed-5188-b233-69fca99e66c0', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('c7747b42-853e-5637-b231-600a8df7aaf1', 'b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', 'e453775a-166a-54df-a5b2-0081c12608dd', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('e681e5ea-6edc-54c0-ac03-8b65680d82b7', 'b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', '051c1a02-6308-5a77-a3f1-f6cd8229242e', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('e2f1c344-28f6-526c-882e-643cddcfa1c9', 'b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', '14078da6-ea92-59c8-aa32-fa74fec6e2c4', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('80b806fa-9961-5b08-8627-daf241a6e240', 'b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', '13dcf743-d13f-5642-816c-e2421e3b775b', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('0cfe3141-abf9-5abe-8032-4dd8f5efd528', 'b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', '5cceeb1d-7a95-5f43-8b5b-069ed1de1651', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('ebd2229a-c3fd-5b15-bf4e-3fc7fc00dc4a', 'b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', '49326b61-166d-5ae6-b288-dfd08f776172', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('f46e8e44-2c38-53fe-9211-1c4c701e5d59', 'b90c3204-5a4a-5ed4-8a1d-2c7140a3c147', '241613d3-48a5-5736-a503-fbbe390e8d02', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('e80a5e21-5466-5c87-8e70-3766ef14957d', 'dc2fae36-554f-53b2-96d0-4d89bac43fac', '3ffeaaf1-0cae-5bc2-b729-55f9a447691e', NOW() - interval '110 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('1c7b7c8f-10a5-53a6-a473-a14b92196607', 'dc2fae36-554f-53b2-96d0-4d89bac43fac', '8e08990d-1c10-52d4-95d5-a7a24656ac16', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('3901a1a9-37e4-5940-92ea-69248aa4c4ab', 'dc2fae36-554f-53b2-96d0-4d89bac43fac', '8a279fe1-0ccc-5ad6-a3b4-01f13882be16', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('241060a6-cbe1-5405-8aa2-e9462cd91a03', 'dc2fae36-554f-53b2-96d0-4d89bac43fac', '17037c2d-a6ba-5ff3-a083-64d2b96b6000', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('f030f216-a308-51c1-8fbf-033930648b51', 'dc2fae36-554f-53b2-96d0-4d89bac43fac', 'a23a905b-10d3-5c22-8f08-ba193b5fed24', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('c8b9a912-c95c-5f27-a949-e7507a67e355', 'dc2fae36-554f-53b2-96d0-4d89bac43fac', '6b2dee77-c383-5011-aa9b-f2934b57ad3c', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('f274c7a6-be19-5e25-9995-1c21ed4e154a', 'dc2fae36-554f-53b2-96d0-4d89bac43fac', '0b0fc815-5048-5f88-a8e8-80ee60459e1b', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('1f2610cb-88b0-5d10-930e-1c7d79708025', 'dc2fae36-554f-53b2-96d0-4d89bac43fac', 'd3e86c7c-5012-5fb9-99d6-40c4a04961d3', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('b96b771b-e6b8-5601-98c2-c274f23de4ad', 'dc2fae36-554f-53b2-96d0-4d89bac43fac', 'eca334aa-bf34-503b-ba8b-aaed8566256d', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('94205dd2-c0c5-51ff-8583-21d41813f52d', 'dc2fae36-554f-53b2-96d0-4d89bac43fac', 'f7781772-4b52-5e49-8948-95f14685bb7d', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('31694282-5e79-53fe-bc89-5211c01dd4a5', '2f16d8da-5c97-5c47-9bd5-d276e84cfce5', '5006102e-5fe9-5473-82f1-f67c327172d0', NOW() - interval '110 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('2b41ddf9-6806-5b31-8bc0-6ce1b0bcbb24', '2f16d8da-5c97-5c47-9bd5-d276e84cfce5', '4b6c0db2-8f0a-5dad-8505-667ad8f00e8d', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('c5a1038c-0880-51ca-b50c-8f191e4ed8e1', '2f16d8da-5c97-5c47-9bd5-d276e84cfce5', '25a41fdc-b039-501f-af00-e6cb77497994', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('299b97a3-743c-514e-9568-b34e2220a6a2', '2f16d8da-5c97-5c47-9bd5-d276e84cfce5', '0c01fe67-dc09-582a-9ec2-d9f5119d14fa', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('6f9a6090-11ba-5809-8acc-292a4e3c1e6a', '2f16d8da-5c97-5c47-9bd5-d276e84cfce5', '2b34af49-23ce-53a0-ba9e-0ddc7662b96e', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('698ae566-f525-57c1-a908-b719ab0f423b', '2f16d8da-5c97-5c47-9bd5-d276e84cfce5', '99dd01fe-5504-5101-ab8c-311cef05ec2f', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('ac370f25-1d4c-5c37-935f-5b58860e545b', '2f16d8da-5c97-5c47-9bd5-d276e84cfce5', '1584522d-e8df-5ca4-b3b1-8d8d6d592aab', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('2cd3917b-bdeb-58bc-ab15-f3ab0b397606', '2f16d8da-5c97-5c47-9bd5-d276e84cfce5', 'ce604ae9-9457-559c-b0eb-f2066025c432', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('469a03e9-0c06-52f7-8741-2b666f75f359', '2f16d8da-5c97-5c47-9bd5-d276e84cfce5', '84eb7717-eca7-5f31-8de8-6428d9fb3a5b', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('118038d2-5418-54ff-9a2c-565e8d02c119', '2f16d8da-5c97-5c47-9bd5-d276e84cfce5', '2a217c04-42ca-58b2-90e9-1be20d2a1932', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('d55e47f6-e6fe-524a-a8bb-46e88d2ced4a', '0d252de5-467a-598a-842f-dfa948f483d5', 'b47acb94-e783-59b0-a1ea-4d1a7ad9a423', NOW() - interval '110 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('3d10d5f4-6ea0-5078-99d6-37cd77a92bdb', '0d252de5-467a-598a-842f-dfa948f483d5', 'ef7ea51c-bcc3-5a18-aa91-f12fbdc904d9', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('1fc9ec00-c888-57e7-b620-14838baffb43', '0d252de5-467a-598a-842f-dfa948f483d5', '12dd726a-5da0-598a-97a1-e68380a42e5b', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('71921d74-4d60-5f0c-9a3f-84ae563ec21e', '0d252de5-467a-598a-842f-dfa948f483d5', 'dc484d29-e587-5d05-a5d2-33676131d98d', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('a817bbad-bcc8-5417-8081-90892bc1df05', '0d252de5-467a-598a-842f-dfa948f483d5', '7faa6c92-a906-511a-aec9-2d32c5754bcd', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('4d6ca4ce-8959-5044-a5cc-9f83a8113776', '0d252de5-467a-598a-842f-dfa948f483d5', '55ef8a93-c32f-5f5e-a5c7-0923a351e57b', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('1d603c77-27d6-5554-a367-c161aea678c8', '0d252de5-467a-598a-842f-dfa948f483d5', '6b0dd36d-93f9-504c-abc6-4bf98e01c770', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('30184ad5-2436-510c-8220-56f4e31e86c4', '0d252de5-467a-598a-842f-dfa948f483d5', '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('f62e8541-29af-5cf4-b651-32518ef24914', '0d252de5-467a-598a-842f-dfa948f483d5', 'b43f27b8-1c37-5d32-a129-7c2e41e94135', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;
INSERT INTO public.group_members (id, group_id, user_id, joined_at)
VALUES ('b33b9cf5-2665-5318-95a9-c485185bea0e', '0d252de5-467a-598a-842f-dfa948f483d5', '71f38ffd-beb1-5ecb-90cf-014856476afe', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;

-- ── 10. POSTS (COMMUNITY FEED) ──────────────────────────────
INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'e9fcf88d-84e9-5126-95df-a9e409400f1c',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  'Glory to God! The Miracle Service yesterday was mind-blowing. I was healed of severe chronic back pain that lasted for 3 years!',
  NULL,
  NULL,
  0,
  0,
  true,
  NOW() - interval '6 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '5be06406-245b-53aa-97f3-3aa146488113',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  'Brothers and sisters, please stand in the gap with me as I prepare for my doctoral defense this Friday. I need divine clarity and wisdom.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '12 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'c0b8bade-a6fa-585a-a478-989cd1bdadaa',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  'We thank God for a successful outreach at the local orphanage. JUM volunteers distributed food and clothing to over 150 children!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '18 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '7eb171e7-3faa-5c53-9c55-5c452da82123',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  'What a profound word from Pastor Kingsley today: ''Walking in faith means taking steps even when you can only see the next inch.''',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  'image',
  0,
  0,
  false,
  NOW() - interval '24 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '2b9cb0cd-f46f-5070-a066-d66e0f0f9812',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  'Encouraging scripture of the day: ''Fear not, for I am with you; be not dismayed, for I am your God; I will strengthen you...'' - Isaiah 41:10',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '30 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'a0de84d9-6a71-55e7-bb90-8435656615ef',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  'Happy anniversary to my amazing wife! We thank Pastor Kingsley and the JUM marriage counseling committee for guiding us.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '36 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '90308fc6-37dc-5484-ae33-81bde3c4c474',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  'Just completed the ''Foundations of Faith'' course in the Gospel Army School! Highly recommend it to anyone seeking spiritual grounding.',
  NULL,
  NULL,
  0,
  0,
  true,
  NOW() - interval '42 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '7fa2c27b-e4e3-5550-99ca-554892ed64f4',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  'My business was struggling for months, but after offering a faith seed and prayers last Sunday, I secured a major contract yesterday!',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  'image',
  0,
  0,
  false,
  NOW() - interval '48 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'f67abaa4-7788-57fb-82cf-ab78b84fe67b',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  'Requesting prayers for our sister Hannah. She was admitted to the hospital, but we know Jesus is the Great Physician.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '54 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '4dcd065d-84b8-59f2-8b33-72b6b0f91c98',
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  'Praise report: Sister Hannah is back home and fully recovered! God is still in the business of performing miracles!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '60 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'ac67beb9-d30c-5959-8139-d6de560853ae',
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  'Reflecting on God''s goodness (Post #11): Glory to God! The Miracle Service yesterday was mind-blowing. I was healed of severe chronic back pain that lasted for 3 years!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '66 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '95f76dd4-6cab-5b9b-b913-4d07ab494953',
  '8a11f317-311d-5241-b8a0-455f712265b5',
  'Reflecting on God''s goodness (Post #12): Brothers and sisters, please stand in the gap with me as I prepare for my doctoral defense this Friday. I need divine clarity and wisdom.',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  'image',
  0,
  0,
  false,
  NOW() - interval '72 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'c75c106f-1295-5556-a4b0-f00dd1dd3d4b',
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  'Reflecting on God''s goodness (Post #13): We thank God for a successful outreach at the local orphanage. JUM volunteers distributed food and clothing to over 150 children!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '78 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '89b80b2e-4cca-56cf-80bd-282a008aa582',
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  'Reflecting on God''s goodness (Post #14): What a profound word from Pastor Kingsley today: ''Walking in faith means taking steps even when you can only see the next inch.''',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '84 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '86a22ff4-e51f-5fe0-a92c-95f46500b0e4',
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  'Reflecting on God''s goodness (Post #15): Encouraging scripture of the day: ''Fear not, for I am with you; be not dismayed, for I am your God; I will strengthen you...'' - Isaiah 41:10',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '90 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'f70fc07f-2b4b-5bcf-b0c1-086ef7248c1b',
  '1164ec13-a4de-5cc0-8eac-eb8833b16640',
  'Reflecting on God''s goodness (Post #16): Happy anniversary to my amazing wife! We thank Pastor Kingsley and the JUM marriage counseling committee for guiding us.',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  'image',
  0,
  0,
  false,
  NOW() - interval '96 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'b80c21f2-8df9-57a7-a978-b1f8f4ae868b',
  '1c27aaa9-2781-5750-9b68-25fee3a17b99',
  'Reflecting on God''s goodness (Post #17): Just completed the ''Foundations of Faith'' course in the Gospel Army School! Highly recommend it to anyone seeking spiritual grounding.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '102 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '3f0ad867-d783-5957-b28c-37c758094413',
  '7126763d-b662-5599-8069-51cbfe88a56a',
  'Reflecting on God''s goodness (Post #18): My business was struggling for months, but after offering a faith seed and prayers last Sunday, I secured a major contract yesterday!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '108 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'f35f9705-0f77-594a-844c-2ac649695ee0',
  '7a9058c3-61ed-5188-b233-69fca99e66c0',
  'Reflecting on God''s goodness (Post #19): Requesting prayers for our sister Hannah. She was admitted to the hospital, but we know Jesus is the Great Physician.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '114 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'd166f722-ffd7-5b57-9306-4530329e7713',
  'e453775a-166a-54df-a5b2-0081c12608dd',
  'Reflecting on God''s goodness (Post #20): Praise report: Sister Hannah is back home and fully recovered! God is still in the business of performing miracles!',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  'image',
  0,
  0,
  false,
  NOW() - interval '120 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'bffe70b1-b1e1-507c-8b40-b1cef6a5746f',
  '051c1a02-6308-5a77-a3f1-f6cd8229242e',
  'Reflecting on God''s goodness (Post #21): Glory to God! The Miracle Service yesterday was mind-blowing. I was healed of severe chronic back pain that lasted for 3 years!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '126 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '82f7059d-30c5-5605-9534-7def035025a1',
  '14078da6-ea92-59c8-aa32-fa74fec6e2c4',
  'Reflecting on God''s goodness (Post #22): Brothers and sisters, please stand in the gap with me as I prepare for my doctoral defense this Friday. I need divine clarity and wisdom.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '132 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '22c9b26c-3ac8-5665-a42a-0612feaf434f',
  '13dcf743-d13f-5642-816c-e2421e3b775b',
  'Reflecting on God''s goodness (Post #23): We thank God for a successful outreach at the local orphanage. JUM volunteers distributed food and clothing to over 150 children!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '138 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'b55fe021-b4ae-5b02-a8be-c083dd11e0fc',
  '5cceeb1d-7a95-5f43-8b5b-069ed1de1651',
  'Reflecting on God''s goodness (Post #24): What a profound word from Pastor Kingsley today: ''Walking in faith means taking steps even when you can only see the next inch.''',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  'image',
  0,
  0,
  false,
  NOW() - interval '144 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '4f28dfd2-bc83-5d32-a0f3-742aecca3c05',
  '49326b61-166d-5ae6-b288-dfd08f776172',
  'Reflecting on God''s goodness (Post #25): Encouraging scripture of the day: ''Fear not, for I am with you; be not dismayed, for I am your God; I will strengthen you...'' - Isaiah 41:10',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '150 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'bf11fb53-96b1-50bc-a799-419d7817980a',
  '241613d3-48a5-5736-a503-fbbe390e8d02',
  'Reflecting on God''s goodness (Post #26): Happy anniversary to my amazing wife! We thank Pastor Kingsley and the JUM marriage counseling committee for guiding us.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '156 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'efc941c5-ec00-5bce-ac60-e81b70b7a36b',
  '8e08990d-1c10-52d4-95d5-a7a24656ac16',
  'Reflecting on God''s goodness (Post #27): Just completed the ''Foundations of Faith'' course in the Gospel Army School! Highly recommend it to anyone seeking spiritual grounding.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '162 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'a4360a66-929a-582c-8a54-b55cebee1d9e',
  '8a279fe1-0ccc-5ad6-a3b4-01f13882be16',
  'Reflecting on God''s goodness (Post #28): My business was struggling for months, but after offering a faith seed and prayers last Sunday, I secured a major contract yesterday!',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  'image',
  0,
  0,
  false,
  NOW() - interval '168 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '2e3ad76c-b181-525a-8fab-c4832dfaeaf8',
  '17037c2d-a6ba-5ff3-a083-64d2b96b6000',
  'Reflecting on God''s goodness (Post #29): Requesting prayers for our sister Hannah. She was admitted to the hospital, but we know Jesus is the Great Physician.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '174 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'b735182a-0c80-5879-8da3-c82c9bc13c08',
  'a23a905b-10d3-5c22-8f08-ba193b5fed24',
  'Reflecting on God''s goodness (Post #30): Praise report: Sister Hannah is back home and fully recovered! God is still in the business of performing miracles!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '180 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '2273c8db-3550-5c70-a3de-92db481b2657',
  '6b2dee77-c383-5011-aa9b-f2934b57ad3c',
  'Reflecting on God''s goodness (Post #31): Glory to God! The Miracle Service yesterday was mind-blowing. I was healed of severe chronic back pain that lasted for 3 years!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '186 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '455dc9c6-292a-59ad-92db-c8e4a1400479',
  '0b0fc815-5048-5f88-a8e8-80ee60459e1b',
  'Reflecting on God''s goodness (Post #32): Brothers and sisters, please stand in the gap with me as I prepare for my doctoral defense this Friday. I need divine clarity and wisdom.',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  'image',
  0,
  0,
  false,
  NOW() - interval '192 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '4c436aff-b4cd-5ea0-9e2d-6fb82d2433b1',
  'd3e86c7c-5012-5fb9-99d6-40c4a04961d3',
  'Reflecting on God''s goodness (Post #33): We thank God for a successful outreach at the local orphanage. JUM volunteers distributed food and clothing to over 150 children!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '198 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '31bf08df-b675-5be9-8f70-96d7bbf99fb5',
  'eca334aa-bf34-503b-ba8b-aaed8566256d',
  'Reflecting on God''s goodness (Post #34): What a profound word from Pastor Kingsley today: ''Walking in faith means taking steps even when you can only see the next inch.''',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '204 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'baf16828-89b3-51ca-a772-ef475db511ff',
  'f7781772-4b52-5e49-8948-95f14685bb7d',
  'Reflecting on God''s goodness (Post #35): Encouraging scripture of the day: ''Fear not, for I am with you; be not dismayed, for I am your God; I will strengthen you...'' - Isaiah 41:10',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '210 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '2c7ef808-c4e6-58a3-80ba-008a6c4eb447',
  '4b6c0db2-8f0a-5dad-8505-667ad8f00e8d',
  'Reflecting on God''s goodness (Post #36): Happy anniversary to my amazing wife! We thank Pastor Kingsley and the JUM marriage counseling committee for guiding us.',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  'image',
  0,
  0,
  false,
  NOW() - interval '216 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '3584ae31-c777-5d16-a610-1a718c002697',
  '25a41fdc-b039-501f-af00-e6cb77497994',
  'Reflecting on God''s goodness (Post #37): Just completed the ''Foundations of Faith'' course in the Gospel Army School! Highly recommend it to anyone seeking spiritual grounding.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '222 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '024c80ce-89c1-5514-8e47-9e0c42dba5e6',
  '0c01fe67-dc09-582a-9ec2-d9f5119d14fa',
  'Reflecting on God''s goodness (Post #38): My business was struggling for months, but after offering a faith seed and prayers last Sunday, I secured a major contract yesterday!',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '228 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  'f57f644b-ddf5-5dc6-bb26-0cc83fc1bf62',
  '2b34af49-23ce-53a0-ba9e-0ddc7662b96e',
  'Reflecting on God''s goodness (Post #39): Requesting prayers for our sister Hannah. She was admitted to the hospital, but we know Jesus is the Great Physician.',
  NULL,
  NULL,
  0,
  0,
  false,
  NOW() - interval '234 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)
VALUES (
  '4cd90481-6587-5999-9686-e7c4b539256e',
  '99dd01fe-5504-5101-ab8c-311cef05ec2f',
  'Reflecting on God''s goodness (Post #40): Praise report: Sister Hannah is back home and fully recovered! God is still in the business of performing miracles!',
  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',
  'image',
  0,
  0,
  false,
  NOW() - interval '240 hours'
) ON CONFLICT (id) DO NOTHING;

-- ── 11. COMMENTS (POSTS) ────────────────────────────────────
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('826b3491-4934-5405-9231-ed8ab97b5093', '5be06406-245b-53aa-97f3-3aa146488113', '9aea834a-81d0-586a-986e-987fa8a71d2a', 'Amen! God is indeed faithful.', NOW() - interval '5 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '5be06406-245b-53aa-97f3-3aa146488113';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('1ab1b74f-0936-549a-9221-cc4be86444d4', 'c0b8bade-a6fa-585a-a478-989cd1bdadaa', '3ffeaaf1-0cae-5bc2-b729-55f9a447691e', 'Wow, what an inspiring testimony!', NOW() - interval '10 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'c0b8bade-a6fa-585a-a478-989cd1bdadaa';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('be90ad01-bb3e-5027-9757-2d209dbce1ad', '7eb171e7-3faa-5c53-9c55-5c452da82123', '5006102e-5fe9-5473-82f1-f67c327172d0', 'Standing in agreement with you in prayers.', NOW() - interval '15 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '7eb171e7-3faa-5c53-9c55-5c452da82123';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('96fa18f1-d496-57bf-b6a5-c9e61457c351', '2b9cb0cd-f46f-5070-a066-d66e0f0f9812', 'b47acb94-e783-59b0-a1ea-4d1a7ad9a423', 'Congratulations! This is just the beginning.', NOW() - interval '20 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '2b9cb0cd-f46f-5070-a066-d66e0f0f9812';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('b6062384-b0c9-5745-9c13-3c59bd17fcd3', 'a0de84d9-6a71-55e7-bb90-8435656615ef', 'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2', 'Thank you for sharing this encouraging word.', NOW() - interval '25 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'a0de84d9-6a71-55e7-bb90-8435656615ef';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('337b7246-bdb8-5c1f-882a-bf745727bdbe', '90308fc6-37dc-5484-ae33-81bde3c4c474', 'fdef44c0-1ceb-5bc3-966a-4f1054c46fac', 'Healings belong to us in Christ! Glory to His name.', NOW() - interval '30 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '90308fc6-37dc-5484-ae33-81bde3c4c474';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('f3a23910-1d99-5c81-a2c9-cebd6a6519bb', '7fa2c27b-e4e3-5550-99ca-554892ed64f4', '2e67cc75-477f-5e66-a641-fa76985d10e4', 'Congratulations on completing the course! Keep growing.', NOW() - interval '35 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '7fa2c27b-e4e3-5550-99ca-554892ed64f4';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('cf1c237c-e313-5ced-a6fb-5be4a25a56cd', 'f67abaa4-7788-57fb-82cf-ab78b84fe67b', 'd270b6cf-af4b-5c9b-bada-d37b12e7083d', 'Hallelujah! Our God is alive and active.', NOW() - interval '40 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'f67abaa4-7788-57fb-82cf-ab78b84fe67b';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('795be7f0-3afe-59bf-a867-f35c5f82f236', '4dcd065d-84b8-59f2-8b33-72b6b0f91c98', '8a11f317-311d-5241-b8a0-455f712265b5', 'Praying for speedy recovery and divine strength.', NOW() - interval '45 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '4dcd065d-84b8-59f2-8b33-72b6b0f91c98';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('577945fe-6e4d-5a49-9d2d-094cbce63dfd', 'ac67beb9-d30c-5959-8139-d6de560853ae', '51e088ae-312d-5511-8546-14f07c1dd8b2', 'This is so beautiful! God bless the missions team.', NOW() - interval '50 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'ac67beb9-d30c-5959-8139-d6de560853ae';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('9b06d8a1-02b5-54c9-b3b9-e6bc931156e5', '95f76dd4-6cab-5b9b-b913-4d07ab494953', '030eb783-fe4c-5b65-aee2-a921a1977359', 'Amen! God is indeed faithful.', NOW() - interval '55 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '95f76dd4-6cab-5b9b-b913-4d07ab494953';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('d8267a6e-86fe-5e8f-b79f-039272056559', 'c75c106f-1295-5556-a4b0-f00dd1dd3d4b', '981d2863-e1cf-5a73-9863-b0b573c71eb7', 'Wow, what an inspiring testimony!', NOW() - interval '60 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'c75c106f-1295-5556-a4b0-f00dd1dd3d4b';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('e299019d-0a36-5768-81ac-71a97f22bc8c', '89b80b2e-4cca-56cf-80bd-282a008aa582', '1164ec13-a4de-5cc0-8eac-eb8833b16640', 'Standing in agreement with you in prayers.', NOW() - interval '65 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '89b80b2e-4cca-56cf-80bd-282a008aa582';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('636b943e-c8f3-5583-840e-f04e374f9a1a', '86a22ff4-e51f-5fe0-a92c-95f46500b0e4', '1c27aaa9-2781-5750-9b68-25fee3a17b99', 'Congratulations! This is just the beginning.', NOW() - interval '70 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '86a22ff4-e51f-5fe0-a92c-95f46500b0e4';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('4a7ed866-9cad-59e3-b025-8ea2dda153a4', 'f70fc07f-2b4b-5bcf-b0c1-086ef7248c1b', '7126763d-b662-5599-8069-51cbfe88a56a', 'Thank you for sharing this encouraging word.', NOW() - interval '75 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'f70fc07f-2b4b-5bcf-b0c1-086ef7248c1b';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('1f423450-ba8f-5f43-a500-d9043ab02610', 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b', '7a9058c3-61ed-5188-b233-69fca99e66c0', 'Healings belong to us in Christ! Glory to His name.', NOW() - interval '80 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('35bb2a58-0f22-5760-9449-1d587fe28d7f', '3f0ad867-d783-5957-b28c-37c758094413', 'e453775a-166a-54df-a5b2-0081c12608dd', 'Congratulations on completing the course! Keep growing.', NOW() - interval '85 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '3f0ad867-d783-5957-b28c-37c758094413';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('6d39f1d2-1512-5892-962f-89d28f00d8bb', 'f35f9705-0f77-594a-844c-2ac649695ee0', '051c1a02-6308-5a77-a3f1-f6cd8229242e', 'Hallelujah! Our God is alive and active.', NOW() - interval '90 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'f35f9705-0f77-594a-844c-2ac649695ee0';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('6d0ae6cb-581b-52c3-b78b-c349034578bc', 'd166f722-ffd7-5b57-9306-4530329e7713', '14078da6-ea92-59c8-aa32-fa74fec6e2c4', 'Praying for speedy recovery and divine strength.', NOW() - interval '95 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'd166f722-ffd7-5b57-9306-4530329e7713';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('8d367f88-ff92-5c3d-90a1-4515f2c5dc58', 'bffe70b1-b1e1-507c-8b40-b1cef6a5746f', '13dcf743-d13f-5642-816c-e2421e3b775b', 'This is so beautiful! God bless the missions team.', NOW() - interval '100 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'bffe70b1-b1e1-507c-8b40-b1cef6a5746f';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('cec86f9a-396d-591f-ad69-f67ecb88523c', '82f7059d-30c5-5605-9534-7def035025a1', '5cceeb1d-7a95-5f43-8b5b-069ed1de1651', 'Amen! God is indeed faithful.', NOW() - interval '105 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '82f7059d-30c5-5605-9534-7def035025a1';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('b3080ffb-e9db-5731-838a-b03d8a1114e1', '22c9b26c-3ac8-5665-a42a-0612feaf434f', '49326b61-166d-5ae6-b288-dfd08f776172', 'Wow, what an inspiring testimony!', NOW() - interval '110 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '22c9b26c-3ac8-5665-a42a-0612feaf434f';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('2095a3b2-c013-54cd-9a07-0f6d5a324abe', 'b55fe021-b4ae-5b02-a8be-c083dd11e0fc', '241613d3-48a5-5736-a503-fbbe390e8d02', 'Standing in agreement with you in prayers.', NOW() - interval '115 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'b55fe021-b4ae-5b02-a8be-c083dd11e0fc';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('b6bbbe3f-c36a-5366-a143-73fd067a3fc0', '4f28dfd2-bc83-5d32-a0f3-742aecca3c05', '8e08990d-1c10-52d4-95d5-a7a24656ac16', 'Congratulations! This is just the beginning.', NOW() - interval '120 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '4f28dfd2-bc83-5d32-a0f3-742aecca3c05';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('c68c5ea1-6db4-584f-af1f-12d9b86d4b26', 'bf11fb53-96b1-50bc-a799-419d7817980a', '8a279fe1-0ccc-5ad6-a3b4-01f13882be16', 'Thank you for sharing this encouraging word.', NOW() - interval '125 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'bf11fb53-96b1-50bc-a799-419d7817980a';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('8c20830c-74f8-5cbc-8045-641b7c959066', 'efc941c5-ec00-5bce-ac60-e81b70b7a36b', '17037c2d-a6ba-5ff3-a083-64d2b96b6000', 'Healings belong to us in Christ! Glory to His name.', NOW() - interval '130 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'efc941c5-ec00-5bce-ac60-e81b70b7a36b';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('174f0463-321c-5ea9-837d-ce9be04a046a', 'a4360a66-929a-582c-8a54-b55cebee1d9e', 'a23a905b-10d3-5c22-8f08-ba193b5fed24', 'Congratulations on completing the course! Keep growing.', NOW() - interval '135 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'a4360a66-929a-582c-8a54-b55cebee1d9e';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('174fec60-9ad8-5f4f-93a7-f2656eb09ee6', '2e3ad76c-b181-525a-8fab-c4832dfaeaf8', '6b2dee77-c383-5011-aa9b-f2934b57ad3c', 'Hallelujah! Our God is alive and active.', NOW() - interval '140 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '2e3ad76c-b181-525a-8fab-c4832dfaeaf8';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('e0e9f4b3-86b5-5f9c-9588-69e1f9f7ace5', 'b735182a-0c80-5879-8da3-c82c9bc13c08', '0b0fc815-5048-5f88-a8e8-80ee60459e1b', 'Praying for speedy recovery and divine strength.', NOW() - interval '145 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = 'b735182a-0c80-5879-8da3-c82c9bc13c08';
INSERT INTO public.comments (id, post_id, user_id, body, created_at)
VALUES ('3fc2a7f0-8157-5c94-93c4-8be757496f17', '2273c8db-3550-5c70-a3de-92db481b2657', 'd3e86c7c-5012-5fb9-99d6-40c4a04961d3', 'This is so beautiful! God bless the missions team.', NOW() - interval '150 hours') ON CONFLICT (id) DO NOTHING;
UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '2273c8db-3550-5c70-a3de-92db481b2657';

-- ── 12. LIKES ───────────────────────────────────────────────
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('ee782d54-8007-5cfa-9671-18b5db098749', '2a217c04-42ca-58b2-90e9-1be20d2a1932', 'a4360a66-929a-582c-8a54-b55cebee1d9e', NOW() - interval '1 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'a4360a66-929a-582c-8a54-b55cebee1d9e';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('08bd901d-a861-57ed-a4ba-a684bbe6a4a3', 'ce604ae9-9457-559c-b0eb-f2066025c432', '2c7ef808-c4e6-58a3-80ba-008a6c4eb447', NOW() - interval '2 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '2c7ef808-c4e6-58a3-80ba-008a6c4eb447';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('1a47346b-f366-5bbd-8121-368706c5323a', 'fdef44c0-1ceb-5bc3-966a-4f1054c46fac', '455dc9c6-292a-59ad-92db-c8e4a1400479', NOW() - interval '3 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '455dc9c6-292a-59ad-92db-c8e4a1400479';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('e4a001f4-b354-5a01-8727-ec3610e45123', '7126763d-b662-5599-8069-51cbfe88a56a', 'c75c106f-1295-5556-a4b0-f00dd1dd3d4b', NOW() - interval '4 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'c75c106f-1295-5556-a4b0-f00dd1dd3d4b';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('40183ad4-7313-542c-bdcd-b146d821de44', '71f38ffd-beb1-5ecb-90cf-014856476afe', '89b80b2e-4cca-56cf-80bd-282a008aa582', NOW() - interval '5 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '89b80b2e-4cca-56cf-80bd-282a008aa582';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('9ce66018-a6a3-599a-a90c-e15e35c7382c', 'dc484d29-e587-5d05-a5d2-33676131d98d', '024c80ce-89c1-5514-8e47-9e0c42dba5e6', NOW() - interval '6 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '024c80ce-89c1-5514-8e47-9e0c42dba5e6';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('6f6ff79a-653a-5eb9-be06-8fed427383a9', '71f38ffd-beb1-5ecb-90cf-014856476afe', 'baf16828-89b3-51ca-a772-ef475db511ff', NOW() - interval '7 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'baf16828-89b3-51ca-a772-ef475db511ff';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('c29adf7d-5c44-511c-beb3-77166d45e632', '71f38ffd-beb1-5ecb-90cf-014856476afe', 'bffe70b1-b1e1-507c-8b40-b1cef6a5746f', NOW() - interval '8 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'bffe70b1-b1e1-507c-8b40-b1cef6a5746f';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('7f7ef49f-0a66-56c0-856b-bbd4cafeaff3', '25a41fdc-b039-501f-af00-e6cb77497994', '7eb171e7-3faa-5c53-9c55-5c452da82123', NOW() - interval '9 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '7eb171e7-3faa-5c53-9c55-5c452da82123';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('a36321ec-65ce-515c-858e-9aeb22cfa241', '0b0fc815-5048-5f88-a8e8-80ee60459e1b', '2273c8db-3550-5c70-a3de-92db481b2657', NOW() - interval '10 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '2273c8db-3550-5c70-a3de-92db481b2657';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('3b4c857b-511a-53e8-bca8-2abbf8b5b4dd', '2e67cc75-477f-5e66-a641-fa76985d10e4', '31bf08df-b675-5be9-8f70-96d7bbf99fb5', NOW() - interval '11 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '31bf08df-b675-5be9-8f70-96d7bbf99fb5';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('f2e7adfc-1e71-522c-aa18-36c391d432fb', '0b0fc815-5048-5f88-a8e8-80ee60459e1b', '7eb171e7-3faa-5c53-9c55-5c452da82123', NOW() - interval '12 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '7eb171e7-3faa-5c53-9c55-5c452da82123';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('c36685d0-d200-5b1c-9b6f-912207815396', 'd270b6cf-af4b-5c9b-bada-d37b12e7083d', 'a0de84d9-6a71-55e7-bb90-8435656615ef', NOW() - interval '13 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'a0de84d9-6a71-55e7-bb90-8435656615ef';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('e79e6e68-76e7-5f92-87f1-e05e80bd572d', '0c01fe67-dc09-582a-9ec2-d9f5119d14fa', '2b9cb0cd-f46f-5070-a066-d66e0f0f9812', NOW() - interval '14 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '2b9cb0cd-f46f-5070-a066-d66e0f0f9812';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('147c2402-d90c-54dc-90f0-2b4e62f004cb', '84eb7717-eca7-5f31-8de8-6428d9fb3a5b', '2b9cb0cd-f46f-5070-a066-d66e0f0f9812', NOW() - interval '15 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '2b9cb0cd-f46f-5070-a066-d66e0f0f9812';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('3000d52f-4653-5be1-97e1-3e7efc43099a', '49326b61-166d-5ae6-b288-dfd08f776172', 'f70fc07f-2b4b-5bcf-b0c1-086ef7248c1b', NOW() - interval '16 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'f70fc07f-2b4b-5bcf-b0c1-086ef7248c1b';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('346f69e1-af8a-5a08-9bf2-a9dd5c51b999', '4b6c0db2-8f0a-5dad-8505-667ad8f00e8d', '7fa2c27b-e4e3-5550-99ca-554892ed64f4', NOW() - interval '17 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '7fa2c27b-e4e3-5550-99ca-554892ed64f4';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('b896a084-cd94-5c45-87c2-0b8cfb42be55', '25a41fdc-b039-501f-af00-e6cb77497994', 'f70fc07f-2b4b-5bcf-b0c1-086ef7248c1b', NOW() - interval '18 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'f70fc07f-2b4b-5bcf-b0c1-086ef7248c1b';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('f674309a-2446-59aa-83d4-4e23fdb327fa', 'b43f27b8-1c37-5d32-a129-7c2e41e94135', 'f57f644b-ddf5-5dc6-bb26-0cc83fc1bf62', NOW() - interval '19 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'f57f644b-ddf5-5dc6-bb26-0cc83fc1bf62';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('0b7fb83e-c46c-5cd5-9e03-1836639802bb', '3ffeaaf1-0cae-5bc2-b729-55f9a447691e', '4cd90481-6587-5999-9686-e7c4b539256e', NOW() - interval '20 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '4cd90481-6587-5999-9686-e7c4b539256e';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('b80d0201-bfe7-5e52-a32d-b280fba7c564', 'ce604ae9-9457-559c-b0eb-f2066025c432', 'efc941c5-ec00-5bce-ac60-e81b70b7a36b', NOW() - interval '21 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'efc941c5-ec00-5bce-ac60-e81b70b7a36b';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('71cca267-fa82-5aa0-9c17-95a3f87342ef', '4b6c0db2-8f0a-5dad-8505-667ad8f00e8d', '024c80ce-89c1-5514-8e47-9e0c42dba5e6', NOW() - interval '22 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '024c80ce-89c1-5514-8e47-9e0c42dba5e6';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('db624c18-185a-5c4e-83f5-5b0395ffe595', 'e453775a-166a-54df-a5b2-0081c12608dd', '31bf08df-b675-5be9-8f70-96d7bbf99fb5', NOW() - interval '23 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '31bf08df-b675-5be9-8f70-96d7bbf99fb5';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('3f8658aa-eafd-580b-96fd-db81e9ae9202', '51e088ae-312d-5511-8546-14f07c1dd8b2', 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b', NOW() - interval '24 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('410efcf9-c027-55c7-a16b-8c576c101b62', '981d2863-e1cf-5a73-9863-b0b573c71eb7', 'bffe70b1-b1e1-507c-8b40-b1cef6a5746f', NOW() - interval '25 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'bffe70b1-b1e1-507c-8b40-b1cef6a5746f';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('9a6fa0dc-2a10-5fb2-b6ea-ec2112838429', '49326b61-166d-5ae6-b288-dfd08f776172', 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b', NOW() - interval '26 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('d3b64042-5927-5f9a-bcaa-dbfafc4cdc52', 'ce604ae9-9457-559c-b0eb-f2066025c432', 'f67abaa4-7788-57fb-82cf-ab78b84fe67b', NOW() - interval '27 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'f67abaa4-7788-57fb-82cf-ab78b84fe67b';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('f7d51fe3-c87e-53a4-8f96-99baa9f6d89b', '17037c2d-a6ba-5ff3-a083-64d2b96b6000', 'd166f722-ffd7-5b57-9306-4530329e7713', NOW() - interval '28 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'd166f722-ffd7-5b57-9306-4530329e7713';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('cfe72c58-3122-5df4-9792-17ff76393ca7', '7faa6c92-a906-511a-aec9-2d32c5754bcd', 'bffe70b1-b1e1-507c-8b40-b1cef6a5746f', NOW() - interval '29 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'bffe70b1-b1e1-507c-8b40-b1cef6a5746f';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('54b17e99-b0a2-51b6-9265-41c9815eb9e0', '6b0dd36d-93f9-504c-abc6-4bf98e01c770', '2b9cb0cd-f46f-5070-a066-d66e0f0f9812', NOW() - interval '30 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '2b9cb0cd-f46f-5070-a066-d66e0f0f9812';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('d1bbde67-52d2-5345-b704-58d6c4d93e1f', '2b34af49-23ce-53a0-ba9e-0ddc7662b96e', 'b735182a-0c80-5879-8da3-c82c9bc13c08', NOW() - interval '31 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'b735182a-0c80-5879-8da3-c82c9bc13c08';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('b8660623-0b6e-5593-96a8-ffe3f3a97086', '5006102e-5fe9-5473-82f1-f67c327172d0', '3584ae31-c777-5d16-a610-1a718c002697', NOW() - interval '32 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '3584ae31-c777-5d16-a610-1a718c002697';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('bb5d1b5c-72d4-55ed-95bf-bfff202f0024', 'eca334aa-bf34-503b-ba8b-aaed8566256d', '2b9cb0cd-f46f-5070-a066-d66e0f0f9812', NOW() - interval '33 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '2b9cb0cd-f46f-5070-a066-d66e0f0f9812';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('042df896-b771-57f1-8d24-90a836ca270f', '0b0fc815-5048-5f88-a8e8-80ee60459e1b', '89b80b2e-4cca-56cf-80bd-282a008aa582', NOW() - interval '34 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '89b80b2e-4cca-56cf-80bd-282a008aa582';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('c80fd9fd-4d06-52fe-9e83-76f306167398', 'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2', 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b', NOW() - interval '35 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('8c07a71d-3631-5030-92cc-7e40b2d0ca80', '9aea834a-81d0-586a-986e-987fa8a71d2a', '22c9b26c-3ac8-5665-a42a-0612feaf434f', NOW() - interval '36 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '22c9b26c-3ac8-5665-a42a-0612feaf434f';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('3c3e6ba6-94f9-5a15-aa22-bf3c061a8b7a', '13dcf743-d13f-5642-816c-e2421e3b775b', 'f70fc07f-2b4b-5bcf-b0c1-086ef7248c1b', NOW() - interval '37 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'f70fc07f-2b4b-5bcf-b0c1-086ef7248c1b';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('e353156d-e7e6-5b7b-b977-3789ef3bbb7c', '2e67cc75-477f-5e66-a641-fa76985d10e4', 'f35f9705-0f77-594a-844c-2ac649695ee0', NOW() - interval '38 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'f35f9705-0f77-594a-844c-2ac649695ee0';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('bb7dbc8d-1e29-56cb-b6a1-ce3b89d715b3', 'eca334aa-bf34-503b-ba8b-aaed8566256d', '2e3ad76c-b181-525a-8fab-c4832dfaeaf8', NOW() - interval '39 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '2e3ad76c-b181-525a-8fab-c4832dfaeaf8';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('0833594e-00c1-535c-ba27-71751d29f1d0', '2b34af49-23ce-53a0-ba9e-0ddc7662b96e', 'd166f722-ffd7-5b57-9306-4530329e7713', NOW() - interval '40 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'd166f722-ffd7-5b57-9306-4530329e7713';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('61433312-6834-539c-ae3a-44c331017ec0', '6b0dd36d-93f9-504c-abc6-4bf98e01c770', '31bf08df-b675-5be9-8f70-96d7bbf99fb5', NOW() - interval '41 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '31bf08df-b675-5be9-8f70-96d7bbf99fb5';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('ee6a292f-3a01-581f-821b-369871a7f542', '7a9058c3-61ed-5188-b233-69fca99e66c0', '2c7ef808-c4e6-58a3-80ba-008a6c4eb447', NOW() - interval '42 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '2c7ef808-c4e6-58a3-80ba-008a6c4eb447';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('f8708bb7-2fe7-5c5e-b331-fe2e739024b1', 'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2', '90308fc6-37dc-5484-ae33-81bde3c4c474', NOW() - interval '43 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '90308fc6-37dc-5484-ae33-81bde3c4c474';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('8f1ec8ee-a60d-5b99-b423-3cbf969f98c9', 'b47acb94-e783-59b0-a1ea-4d1a7ad9a423', 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b', NOW() - interval '44 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('061be8a0-93bc-5d37-ab78-7cd0f9fd86ae', 'dc484d29-e587-5d05-a5d2-33676131d98d', '90308fc6-37dc-5484-ae33-81bde3c4c474', NOW() - interval '45 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '90308fc6-37dc-5484-ae33-81bde3c4c474';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('b443b9b1-d00c-5c15-8a02-3e2a651acc5e', 'fdef44c0-1ceb-5bc3-966a-4f1054c46fac', '2c7ef808-c4e6-58a3-80ba-008a6c4eb447', NOW() - interval '46 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '2c7ef808-c4e6-58a3-80ba-008a6c4eb447';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('09a26960-0e22-56ba-bc37-79228895a54e', '7126763d-b662-5599-8069-51cbfe88a56a', '3f0ad867-d783-5957-b28c-37c758094413', NOW() - interval '47 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '3f0ad867-d783-5957-b28c-37c758094413';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('15c2875b-8f13-57a1-9153-9900f017b9d6', '51e088ae-312d-5511-8546-14f07c1dd8b2', 'f57f644b-ddf5-5dc6-bb26-0cc83fc1bf62', NOW() - interval '48 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'f57f644b-ddf5-5dc6-bb26-0cc83fc1bf62';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('7b16deb2-5e87-5c07-9778-f52f4da2669b', '51e088ae-312d-5511-8546-14f07c1dd8b2', '82f7059d-30c5-5605-9534-7def035025a1', NOW() - interval '49 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '82f7059d-30c5-5605-9534-7def035025a1';
INSERT INTO public.likes (id, user_id, post_id, created_at)
VALUES ('42343d02-8da4-5dac-84de-f93db3b5b060', '0b0fc815-5048-5f88-a8e8-80ee60459e1b', 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b', NOW() - interval '50 hours') ON CONFLICT (user_id, post_id) DO NOTHING;
UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = 'b80c21f2-8df9-57a7-a978-b1f8f4ae868b';

-- ── 13. CONVERSATIONS ───────────────────────────────────────
INSERT INTO public.conversations (id, name, is_group, created_at)
VALUES ('dc67c46f-2f96-5af5-bff7-47f0cb0b80b0', NULL, false, NOW() - interval '30 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.conversations (id, name, is_group, created_at)
VALUES ('db670330-fe0b-5a95-8ef3-f057cd1109b3', NULL, false, NOW() - interval '30 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.conversations (id, name, is_group, created_at)
VALUES ('b48476a1-5dbd-583b-a23c-39f0f3ff5ea0', NULL, false, NOW() - interval '30 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.conversations (id, name, is_group, created_at)
VALUES ('8da77354-8f5d-5f5a-a9d0-d06d573f716c', NULL, false, NOW() - interval '30 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.conversations (id, name, is_group, created_at)
VALUES ('27fca383-80a1-5153-8b4f-c693d4daa93c', NULL, false, NOW() - interval '30 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.conversations (id, name, is_group, created_at)
VALUES ('71a132e8-58e4-5b09-a16d-8696954e72fd', 'Ushering Leaders', true, NOW() - interval '60 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.conversations (id, name, is_group, created_at)
VALUES ('4ef472d6-dd53-5d6a-b65b-8d4d25817637', 'Levites Choir General', true, NOW() - interval '60 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.conversations (id, name, is_group, created_at)
VALUES ('ad5c3f26-2327-5246-88f0-f70b4a58d37f', 'Media Technical Crew', true, NOW() - interval '60 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.conversations (id, name, is_group, created_at)
VALUES ('520e8466-0b26-5818-9eb7-99b4c5224c39', 'Youth Leaders Board', true, NOW() - interval '60 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.conversations (id, name, is_group, created_at)
VALUES ('4b1ee666-11a2-576d-bc93-610325103069', 'Missions Committee', true, NOW() - interval '60 days') ON CONFLICT (id) DO NOTHING;

-- ── 14. MESSAGES ────────────────────────────────────────────
INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  'af4ac252-6c62-5a49-819d-4b0390d6acc3',
  'dc67c46f-2f96-5af5-bff7-47f0cb0b80b0',
  '6b0dd36d-93f9-504c-abc6-4bf98e01c770',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  'Hello Leader Caleb, will we have a brief meeting after the second service?',
  NOW() - interval '1 hour',
  NOW() - interval '24 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  '366f28d1-8738-5deb-a884-34461234fe81',
  'db670330-fe0b-5a95-8ef3-f057cd1109b3',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  'Yes, Brother, we need to review the ushering roster for the upcoming summit.',
  NOW() - interval '1 hour',
  NOW() - interval '23 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  '7da92ae7-a3aa-5bcc-a94d-499a8dc45e0f',
  'b48476a1-5dbd-583b-a23c-39f0f3ff5ea0',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  'Excellent. I have updated my availability in the planner.',
  NOW() - interval '1 hour',
  NOW() - interval '22 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  'f184ed47-e389-5806-a24a-a50dc1d24faa',
  '8da77354-8f5d-5f5a-a9d0-d06d573f716c',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  'Thank you! God bless your dedication.',
  NOW() - interval '1 hour',
  NOW() - interval '21 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  '2b4cd468-d12d-548e-92b3-c5f299742652',
  '27fca383-80a1-5153-8b4f-c693d4daa93c',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  'Hello Sister Sarah, the chord sheet for Sunday''s worship song has been updated.',
  NOW() - interval '1 hour',
  NOW() - interval '20 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  '64abcfad-d9f2-5275-872f-7682a181dc6b',
  'dc67c46f-2f96-5af5-bff7-47f0cb0b80b0',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  'Got it! Let''s schedule the rehearsal for Saturday 4 PM.',
  NOW() - interval '1 hour',
  NOW() - interval '19 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  '33f51a4b-4aa2-5e4a-bf2a-b1cd8e9bb86f',
  'db670330-fe0b-5a95-8ef3-f057cd1109b3',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  'Yes, looking forward to it. It''s going to be a powerful service.',
  NOW() - interval '1 hour',
  NOW() - interval '18 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  '3aa677b4-2918-51f4-8d39-6fe14fdc8dc9',
  'dc67c46f-2f96-5af5-bff7-47f0cb0b80b0',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  '6b0dd36d-93f9-504c-abc6-4bf98e01c770',
  'Hey! Are you attending the youth conference tomorrow?',
  NULL,
  NOW() - interval '15 minutes'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  'aa73d5c6-ac71-5630-8ff3-483eb92d8ce4',
  'db670330-fe0b-5a95-8ef3-f057cd1109b3',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  'Just sent the updated slides to the media team. Let me know if it looks good.',
  NULL,
  NOW() - interval '15 minutes'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  'f2847450-c83c-53c1-a0a7-26f8d61b9fa2',
  '71a132e8-58e4-5b09-a16d-8696954e72fd',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  NULL,
  'Welcome team! Let''s ensure everything is ready for the Sunday Broadcast.',
  NOW() - interval '2 hours',
  NOW() - interval '12 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  'ef3597fc-a7fd-5398-b208-7bcc24c75709',
  '4ef472d6-dd53-5d6a-b65b-8d4d25817637',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  NULL,
  'Audios checked, cameras set up, Impeller backend configured.',
  NOW() - interval '2 hours',
  NOW() - interval '11 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  '7f2223e2-2f5d-5fa9-8a0f-bb6a0c1037a7',
  'ad5c3f26-2327-5246-88f0-f70b4a58d37f',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  NULL,
  'Ushering assignments are fully uploaded. Let''s welcome attendees with joy!',
  NOW() - interval '2 hours',
  NOW() - interval '10 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  '7c5c3e10-e611-5760-9e53-badac68afc35',
  '520e8466-0b26-5818-9eb7-99b4c5224c39',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  NULL,
  'Levites Choir rehearsals are moving to 3:30 PM this Saturday. Please be early.',
  NOW() - interval '2 hours',
  NOW() - interval '9 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)
VALUES (
  '9c65b6e8-0c3f-541e-8673-10a02dcf2de2',
  '4b1ee666-11a2-576d-bc93-610325103069',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  NULL,
  'Missions team, the food packages are fully sorted. Ready for departure on Tuesday.',
  NOW() - interval '2 hours',
  NOW() - interval '8 hours'
) ON CONFLICT (id) DO NOTHING;

-- ── 15. COURSES (GOSPEL ARMY) ────────────────────────────────
INSERT INTO public.courses (id, title, description, thumbnail_url, level, is_published, created_at)
VALUES ('3493fae1-3429-5b53-a553-2d4e733045c2', 'Foundations of Faith', 'Explore core Christian doctrines, the authority of scripture, and salvation principles.', 'https://images.unsplash.com/photo-1544027993-37dbfe43562a?auto=format&fit=crop&q=80&w=400', 'Beginner', true, NOW() - interval '180 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.courses (id, title, description, thumbnail_url, level, is_published, created_at)
VALUES ('13d3c616-1005-55e0-8690-3e25fa2967ef', 'Discipleship 101', 'A guide to walking with Christ, personal devotion, and practicing radical generosity.', 'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=400', 'Intermediate', true, NOW() - interval '180 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.courses (id, title, description, thumbnail_url, level, is_published, created_at)
VALUES ('bfc02402-260e-5b4f-a6a5-295a98c65036', 'Advanced Christian Theology', 'Deep study of covenants, pneumatology, end-time prophecy, and church history.', 'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=400', 'Advanced', true, NOW() - interval '180 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.courses (id, title, description, thumbnail_url, level, is_published, created_at)
VALUES ('68874415-9312-54b2-bac6-ae3121349053', 'Kingdom Stewardship & Wealth', 'Understanding biblical economics, covenant financial keys, and running ethical business projects.', 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&q=80&w=400', 'Intermediate', true, NOW() - interval '180 days') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.courses (id, title, description, thumbnail_url, level, is_published, created_at)
VALUES ('b8b6b706-a970-5fb3-ba4f-36620ec68708', 'Christian Ethics & Society', 'How to navigate moral issues, digital citizenship, and leadership roles in the modern workplace.', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=400', 'Advanced', true, NOW() - interval '180 days') ON CONFLICT (id) DO NOTHING;

-- ── 16. LESSONS (COURSES) ───────────────────────────────────
INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  '7c8abfc8-ae7d-5009-8bca-55559306b65a',
  '3493fae1-3429-5b53-a553-2d4e733045c2',
  'Lesson 1: Core Principles of Foundations of Faith',
  'This lesson introduces foundational concepts related to Foundations of Faith. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  1,
  1,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  'dbc667b1-81b7-559b-885a-972b7afc7383',
  '3493fae1-3429-5b53-a553-2d4e733045c2',
  'Lesson 2: Core Principles of Foundations of Faith',
  'This lesson introduces foundational concepts related to Foundations of Faith. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  2,
  2,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  '7bf9890d-2140-5145-9adc-2332c81258b7',
  '3493fae1-3429-5b53-a553-2d4e733045c2',
  'Lesson 3: Core Principles of Foundations of Faith',
  'This lesson introduces foundational concepts related to Foundations of Faith. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  3,
  3,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  '72180a50-7736-5559-a31d-85446b89b2d6',
  '13d3c616-1005-55e0-8690-3e25fa2967ef',
  'Lesson 1: Core Principles of Discipleship 101',
  'This lesson introduces foundational concepts related to Discipleship 101. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  1,
  1,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  '6ed7c630-0632-54d2-9f72-4cef81148eb9',
  '13d3c616-1005-55e0-8690-3e25fa2967ef',
  'Lesson 2: Core Principles of Discipleship 101',
  'This lesson introduces foundational concepts related to Discipleship 101. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  2,
  2,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  'd8496d29-ca13-5f04-aef6-505e7316c1d0',
  '13d3c616-1005-55e0-8690-3e25fa2967ef',
  'Lesson 3: Core Principles of Discipleship 101',
  'This lesson introduces foundational concepts related to Discipleship 101. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  3,
  3,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  'fe735cae-c1ed-5f06-a913-59fb3f73f741',
  'bfc02402-260e-5b4f-a6a5-295a98c65036',
  'Lesson 1: Core Principles of Advanced Christian Theology',
  'This lesson introduces foundational concepts related to Advanced Christian Theology. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  1,
  1,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  '8dd1a3fd-ce7f-5f77-9a10-ee98e3fc8271',
  'bfc02402-260e-5b4f-a6a5-295a98c65036',
  'Lesson 2: Core Principles of Advanced Christian Theology',
  'This lesson introduces foundational concepts related to Advanced Christian Theology. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  2,
  2,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  '77abdc6e-1f74-5142-b4df-87fe75094352',
  'bfc02402-260e-5b4f-a6a5-295a98c65036',
  'Lesson 3: Core Principles of Advanced Christian Theology',
  'This lesson introduces foundational concepts related to Advanced Christian Theology. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  3,
  3,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  'a0aa64f9-3a26-5543-8563-9c6a436d2144',
  '68874415-9312-54b2-bac6-ae3121349053',
  'Lesson 1: Core Principles of Kingdom Stewardship & Wealth',
  'This lesson introduces foundational concepts related to Kingdom Stewardship & Wealth. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  1,
  1,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  '8f5b3dc3-0282-5689-83d2-c62b3e0a2440',
  '68874415-9312-54b2-bac6-ae3121349053',
  'Lesson 2: Core Principles of Kingdom Stewardship & Wealth',
  'This lesson introduces foundational concepts related to Kingdom Stewardship & Wealth. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  2,
  2,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  '5709e350-c39c-57f5-938d-c64430a2f60f',
  '68874415-9312-54b2-bac6-ae3121349053',
  'Lesson 3: Core Principles of Kingdom Stewardship & Wealth',
  'This lesson introduces foundational concepts related to Kingdom Stewardship & Wealth. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  3,
  3,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  '760516f7-134e-5c1b-b6ef-5a568162d6a9',
  'b8b6b706-a970-5fb3-ba4f-36620ec68708',
  'Lesson 1: Core Principles of Christian Ethics & Society',
  'This lesson introduces foundational concepts related to Christian Ethics & Society. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  1,
  1,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  'd3b8ba77-39c0-5772-aece-a65af72389c0',
  'b8b6b706-a970-5fb3-ba4f-36620ec68708',
  'Lesson 2: Core Principles of Christian Ethics & Society',
  'This lesson introduces foundational concepts related to Christian Ethics & Society. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  2,
  2,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)
VALUES (
  '9b607be5-227c-5ce1-9985-a66fd07a3aca',
  'b8b6b706-a970-5fb3-ba4f-36620ec68708',
  'Lesson 3: Core Principles of Christian Ethics & Society',
  'This lesson introduces foundational concepts related to Christian Ethics & Society. We will cover scriptural origins, practical challenges, and modern-day case studies.',
  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  3,
  3,
  NOW() - interval '170 days'
) ON CONFLICT (id) DO NOTHING;

-- ── 17. QUIZ QUESTIONS ──────────────────────────────────────
INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  '821ac0d3-3ef2-5598-91da-330875554245',
  '7c8abfc8-ae7d-5009-8bca-55559306b65a',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  '965126b4-5414-55f5-9276-ae36c38bec5a',
  'dbc667b1-81b7-559b-885a-972b7afc7383',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  'c7d4ae2a-5595-5cea-b484-3a29a3ef87fd',
  '7bf9890d-2140-5145-9adc-2332c81258b7',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  'e8c8e622-3705-5b25-bb0f-def5d2f807fd',
  '72180a50-7736-5559-a31d-85446b89b2d6',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  '3faadef7-395c-5564-b4d7-94676b94c884',
  '6ed7c630-0632-54d2-9f72-4cef81148eb9',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  '56af9a76-837d-597e-a752-51e11cf0c44f',
  'd8496d29-ca13-5f04-aef6-505e7316c1d0',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  'c37c678e-269e-5cf6-854a-2ccf6e892e72',
  'fe735cae-c1ed-5f06-a913-59fb3f73f741',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  'efd80a1c-7600-583f-bac3-e6786bf51ee9',
  '8dd1a3fd-ce7f-5f77-9a10-ee98e3fc8271',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  '0518b4f7-5ce2-5d28-88ac-e5b65d9d3ac9',
  '77abdc6e-1f74-5142-b4df-87fe75094352',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  '0e747308-9f59-5074-998b-6b0f03ffa5c2',
  'a0aa64f9-3a26-5543-8563-9c6a436d2144',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  '11f4d5b5-fd64-5565-9133-dab343b5471e',
  '8f5b3dc3-0282-5689-83d2-c62b3e0a2440',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  '2be4d445-e025-5209-b7b4-ab724ef90d45',
  '5709e350-c39c-57f5-938d-c64430a2f60f',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  'ff590b34-e4cc-506e-b417-b8cf5a021da9',
  '760516f7-134e-5c1b-b6ef-5a568162d6a9',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  '447d2618-46b1-5fd7-9605-742e67e1285d',
  'd3b8ba77-39c0-5772-aece-a65af72389c0',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)
VALUES (
  '03c9b225-8b0a-5cda-ab5e-142862ddcce1',
  '9b607be5-227c-5ce1-9985-a66fd07a3aca',
  'What is the primary biblical foundation highlighted in this lesson?',
  ARRAY['Grace & Faith', 'Law & Works', 'Tradition', 'Human Philosophy'],
  0,
  NOW() - interval '160 days'
) ON CONFLICT (id) DO NOTHING;

-- ── 18. ENROLLMENTS ──────────────────────────────────────────
INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  '01ca3225-eb8e-54a0-9d67-61fa389e6639',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  '13d3c616-1005-55e0-8690-3e25fa2967ef',
  100,
  NOW() - interval '10 days',
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  '1279785c-c713-5ac9-b163-eb144eb7acde',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  'bfc02402-260e-5b4f-a6a5-295a98c65036',
  100,
  NOW() - interval '10 days',
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  'fca5cd72-215b-5a04-8284-b74846eeca24',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  '68874415-9312-54b2-bac6-ae3121349053',
  100,
  NOW() - interval '10 days',
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  '180698d3-f767-5410-bc63-42e57f98369a',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  'b8b6b706-a970-5fb3-ba4f-36620ec68708',
  100,
  NOW() - interval '10 days',
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  'f878af1a-539d-5668-8c86-3764dbaf060a',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  '3493fae1-3429-5b53-a553-2d4e733045c2',
  100,
  NOW() - interval '10 days',
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  '1396c265-cfa5-5f75-9440-9fafd2e6f1bb',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  '13d3c616-1005-55e0-8690-3e25fa2967ef',
  50,
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  'fe55124b-9b82-56ff-931d-c601db132420',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  'bfc02402-260e-5b4f-a6a5-295a98c65036',
  50,
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  'f395b78d-5527-53d0-b8f7-350dcd3a62db',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  '68874415-9312-54b2-bac6-ae3121349053',
  50,
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  '725c2c85-9570-505c-85dd-44c289308a75',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  'b8b6b706-a970-5fb3-ba4f-36620ec68708',
  50,
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  'c5474bd7-b77d-576b-9323-a9459ec12ad1',
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  '3493fae1-3429-5b53-a553-2d4e733045c2',
  50,
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  '6644973a-1843-5cee-8c57-4021df5b394f',
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  '13d3c616-1005-55e0-8690-3e25fa2967ef',
  0,
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  '1175b937-0dfc-5a36-8ab2-f481404e55a8',
  '8a11f317-311d-5241-b8a0-455f712265b5',
  'bfc02402-260e-5b4f-a6a5-295a98c65036',
  0,
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  '51276562-6ae3-520e-a58a-26e456c17e81',
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  '68874415-9312-54b2-bac6-ae3121349053',
  0,
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  '5790f96c-cb4b-5422-b366-ec77778dcc18',
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  'b8b6b706-a970-5fb3-ba4f-36620ec68708',
  0,
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)
VALUES (
  '8f4996d9-1abd-5f2d-85b0-d75ec1a1a53d',
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  '3493fae1-3429-5b53-a553-2d4e733045c2',
  0,
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (user_id, course_id) DO NOTHING;

-- ── 19. QUIZ ATTEMPTS ────────────────────────────────────────
INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)
VALUES (
  '29cd29b0-8093-5b5f-8f4a-f4046fee4d6a',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  'dbc667b1-81b7-559b-885a-972b7afc7383',
  1,
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)
VALUES (
  'c144ad61-bcee-506f-80fb-30c119b7fbc0',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  '7bf9890d-2140-5145-9adc-2332c81258b7',
  1,
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)
VALUES (
  'da0b8f25-c4b5-5bc2-a662-beed40d9c48f',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  '72180a50-7736-5559-a31d-85446b89b2d6',
  1,
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)
VALUES (
  '87c69d33-98a3-5dec-9ecf-565825e32d96',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  '6ed7c630-0632-54d2-9f72-4cef81148eb9',
  1,
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)
VALUES (
  'af90e20a-9e8a-54fd-879e-b679c4cc868c',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  'd8496d29-ca13-5f04-aef6-505e7316c1d0',
  1,
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)
VALUES (
  '50c4ee81-b4c8-5fff-b1fc-257975a70767',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  'fe735cae-c1ed-5f06-a913-59fb3f73f741',
  1,
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)
VALUES (
  '8351ab7d-57d0-523e-9125-c828bdef301b',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  '8dd1a3fd-ce7f-5f77-9a10-ee98e3fc8271',
  1,
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)
VALUES (
  '17def8bb-0b9e-5f36-85a7-16921b342a75',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  '77abdc6e-1f74-5142-b4df-87fe75094352',
  1,
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)
VALUES (
  '5e8812d4-b7dc-564a-a780-acd7106f0808',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  'a0aa64f9-3a26-5543-8563-9c6a436d2144',
  1,
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)
VALUES (
  'be8f3687-ef21-530c-80d5-4d8b5fcfac46',
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  '8f5b3dc3-0282-5689-83d2-c62b3e0a2440',
  1,
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

-- ── 20. PRODUCTS (MARKETPLACE) ──────────────────────────────
INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  'e0d91fda-03a3-5dd4-953c-c4028c48533c',
  'Unhindered Grace Devotional 2026',
  'A daily guide packed with scriptural revelations, confessions, and declarations for an victorious year.',
  4500.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '8e18feea-f19e-5b77-b186-68fb3660d70a',
  'Walking in Covenant Purpose (Hardcover)',
  'Senior Pastor Kingsley Aniche''s best-selling book detailing how to find, align, and accomplish your divine task on earth.',
  6000.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '458c351f-8722-5305-8bdc-3181fc9d4aac',
  'JUM Branded Premium Hoodie',
  'Premium warm cotton hoodie embroidered with the Jesus Unhindered Ministry emblem. Inspire and shine.',
  15000.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '1f120559-7cef-52b1-8de6-48b1a5eb3e05',
  'Unhindered Praise CD & Digital Album',
  'Studio album from the Levites Choir featuring deep worship tracks, instrumental declarations, and miracle chants.',
  3000.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1511192336575-5a79af67a629?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '74d42c1f-e658-5fbc-8e81-d78759321d10',
  'Youth Power Conference 2026 Ticket',
  'Admit-one standard registration pass for the three-day National Youth Conference including materials and lunch.',
  5000.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '1b434822-1088-5117-9145-165ef341ddd0',
  'Kingdom Resource Merch Series 6',
  'An excellent ministry study resource and branded merch highlighting grace and leadership principles.',
  5000.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '979dc36e-e541-578f-99ac-258072fdd4d2',
  'Kingdom Resource Merch Series 7',
  'An excellent ministry study resource and branded merch highlighting grace and leadership principles.',
  5500.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  'efb6984a-2785-5501-84b8-4ee367fade9a',
  'Kingdom Resource Merch Series 8',
  'An excellent ministry study resource and branded merch highlighting grace and leadership principles.',
  6000.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '5dcfbac0-1951-59d6-9762-19f285609573',
  'Kingdom Resource Merch Series 9',
  'An excellent ministry study resource and branded merch highlighting grace and leadership principles.',
  6500.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '585220d5-1a1e-519b-8024-b248d01c0250',
  'Kingdom Resource Merch Series 10',
  'An excellent ministry study resource and branded merch highlighting grace and leadership principles.',
  7000.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '1a9e3e83-71c7-5696-9745-e07fd65c5a39',
  'Kingdom Resource Merch Series 11',
  'An excellent ministry study resource and branded merch highlighting grace and leadership principles.',
  7500.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '60d4c3d8-e7fe-5cd9-8b9a-628f90a5b0f5',
  'Kingdom Resource Merch Series 12',
  'An excellent ministry study resource and branded merch highlighting grace and leadership principles.',
  8000.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '4d4fdd07-e45f-5951-ae9f-3bba39cdeeb6',
  'Kingdom Resource Merch Series 13',
  'An excellent ministry study resource and branded merch highlighting grace and leadership principles.',
  8500.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '195ccb02-1657-5099-85ea-90909454f4f1',
  'Kingdom Resource Merch Series 14',
  'An excellent ministry study resource and branded merch highlighting grace and leadership principles.',
  9000.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)
VALUES (
  '7f4a33dc-8308-5db0-b968-edee586dbaea',
  'Kingdom Resource Merch Series 15',
  'An excellent ministry study resource and branded merch highlighting grace and leadership principles.',
  9500.0,
  'NGN',
  ARRAY['https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400'],
  true,
  NOW() - interval '60 days'
) ON CONFLICT (id) DO NOTHING;

-- ── 21. ORDERS (MARKETPLACE) ────────────────────────────────
INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '0fa8d615-c1ea-5945-8ebf-fb1dea81e0d8',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  6000.0,
  'paid',
  '{"product_id": "8e18feea-f19e-5b77-b186-68fb3660d70a", "quantity": 1, "name": "Walking in Covenant Purpose (Hardcover)"}'::jsonb,
  'Lagos, Nigeria',
  NOW() - interval '3 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '3a2cb14a-9caa-507f-b7fb-7324ac21ad8a',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  15000.0,
  'paid',
  '{"product_id": "458c351f-8722-5305-8bdc-3181fc9d4aac", "quantity": 1, "name": "JUM Branded Premium Hoodie"}'::jsonb,
  'London, United Kingdom',
  NOW() - interval '6 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '679d153b-add4-57be-95b6-dbe9248c71a3',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  3000.0,
  'paid',
  '{"product_id": "1f120559-7cef-52b1-8de6-48b1a5eb3e05", "quantity": 1, "name": "Unhindered Praise CD & Digital Album"}'::jsonb,
  'Houston, United States',
  NOW() - interval '9 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '8e6d17fc-3697-5f26-8d17-e7d169f65a1f',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  5000.0,
  'paid',
  '{"product_id": "74d42c1f-e658-5fbc-8e81-d78759321d10", "quantity": 1, "name": "Youth Power Conference 2026 Ticket"}'::jsonb,
  'London, United Kingdom',
  NOW() - interval '12 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  'a5eed03d-5a9b-5dda-85e7-ff379da76918',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  5000.0,
  'paid',
  '{"product_id": "1b434822-1088-5117-9145-165ef341ddd0", "quantity": 1, "name": "Kingdom Resource Merch Series 6"}'::jsonb,
  'Lagos, Nigeria',
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '72851bd2-74d3-5d78-bb58-934952fc7ab9',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  5500.0,
  'paid',
  '{"product_id": "979dc36e-e541-578f-99ac-258072fdd4d2", "quantity": 1, "name": "Kingdom Resource Merch Series 7"}'::jsonb,
  'Abuja, Nigeria',
  NOW() - interval '18 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '0edf2769-9649-5c5d-942b-0a9fe91680c6',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  6000.0,
  'paid',
  '{"product_id": "efb6984a-2785-5501-84b8-4ee367fade9a", "quantity": 1, "name": "Kingdom Resource Merch Series 8"}'::jsonb,
  'Lagos, Nigeria',
  NOW() - interval '21 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '4d5343e4-955e-50fe-b006-e7e45118644c',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  6500.0,
  'paid',
  '{"product_id": "5dcfbac0-1951-59d6-9762-19f285609573", "quantity": 1, "name": "Kingdom Resource Merch Series 9"}'::jsonb,
  'Accra, Ghana',
  NOW() - interval '24 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  'b4abf72e-8558-5366-8a3c-720adf5448c7',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  7000.0,
  'paid',
  '{"product_id": "585220d5-1a1e-519b-8024-b248d01c0250", "quantity": 1, "name": "Kingdom Resource Merch Series 10"}'::jsonb,
  'Lagos, Nigeria',
  NOW() - interval '27 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  'fcf70e3e-3d4e-5edc-8ec9-27f6eca1c416',
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  7500.0,
  'paid',
  '{"product_id": "1a9e3e83-71c7-5696-9745-e07fd65c5a39", "quantity": 1, "name": "Kingdom Resource Merch Series 11"}'::jsonb,
  'Abuja, Nigeria',
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  'e4b27416-b0df-5a7c-ac62-72d87f4219c7',
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  8000.0,
  'pending',
  '{"product_id": "60d4c3d8-e7fe-5cd9-8b9a-628f90a5b0f5", "quantity": 1, "name": "Kingdom Resource Merch Series 12"}'::jsonb,
  'Houston, United States',
  NOW() - interval '33 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '57f7d2b0-8fe4-536a-8106-38c5bafe8faf',
  '8a11f317-311d-5241-b8a0-455f712265b5',
  8500.0,
  'pending',
  '{"product_id": "4d4fdd07-e45f-5951-ae9f-3bba39cdeeb6", "quantity": 1, "name": "Kingdom Resource Merch Series 13"}'::jsonb,
  'Abuja, Nigeria',
  NOW() - interval '36 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '117abb57-3c9f-5935-959a-8323a47734e4',
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  9000.0,
  'pending',
  '{"product_id": "195ccb02-1657-5099-85ea-90909454f4f1", "quantity": 1, "name": "Kingdom Resource Merch Series 14"}'::jsonb,
  'Manchester, United Kingdom',
  NOW() - interval '39 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '6be9bc78-dcf2-5a41-8962-4a1d645a1c12',
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  9500.0,
  'pending',
  '{"product_id": "7f4a33dc-8308-5db0-b968-edee586dbaea", "quantity": 1, "name": "Kingdom Resource Merch Series 15"}'::jsonb,
  'Lagos, Nigeria',
  NOW() - interval '42 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)
VALUES (
  '0008c84b-72c6-55df-b946-59267afbf28e',
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  4500.0,
  'pending',
  '{"product_id": "e0d91fda-03a3-5dd4-953c-c4028c48533c", "quantity": 1, "name": "Unhindered Grace Devotional 2026"}'::jsonb,
  'Houston, United States',
  NOW() - interval '45 days'
) ON CONFLICT (id) DO NOTHING;

-- ── 22. DONATIONS (GIVING) ──────────────────────────────────
INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'd4b1199e-0647-5be2-9b8a-223037796b68',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  30.0,
  'USD',
  'offering',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-1001',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/9cd5f6ad-5dbc-573c-b912-ea02b5aa937b/9e81f10b-ba4e-5f04-87f4-2c971d4a3c6c.pdf',
  NOW() - interval '12 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'de06096a-9171-5408-a55f-ec02e7612f10',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  10000.0,
  'NGN',
  'missions',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-2002',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/b43f27b8-1c37-5d32-a129-7c2e41e94135/0210315f-b419-5915-86e3-5e8a2249f55e.pdf',
  NOW() - interval '24 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '0f653ae8-4e3f-50a2-9fce-5a0a25bb4494',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  50.0,
  'USD',
  'media',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-3003',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/71f38ffd-beb1-5ecb-90cf-014856476afe/3e7fe777-5cbf-56d8-9874-fa40170e059b.pdf',
  NOW() - interval '36 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '8f99c994-ce88-517a-8a3b-a74db6855eca',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  15000.0,
  'NGN',
  'building',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-4004',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/9aea834a-81d0-586a-986e-987fa8a71d2a/1c086086-fae5-5359-b514-6d6bce02b481.pdf',
  NOW() - interval '48 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '16d03e58-e870-5934-b1f9-39c3de2a4f4b',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  70.0,
  'USD',
  'partnership',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-5005',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/3ffeaaf1-0cae-5bc2-b729-55f9a447691e/ec7813a5-8081-5469-ad30-70286fcc7e58.pdf',
  NOW() - interval '60 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '8188fcc5-6c37-5b0d-adb1-f7822ea9e967',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  20000.0,
  'NGN',
  'tithe',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-6006',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/5006102e-5fe9-5473-82f1-f67c327172d0/776dc46e-9813-553b-b4a2-9633a97a4080.pdf',
  NOW() - interval '72 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '750011c5-660b-569c-ae44-2aaf97a49bdf',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  90.0,
  'USD',
  'offering',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-7007',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/b47acb94-e783-59b0-a1ea-4d1a7ad9a423/df43d5fa-2155-5af5-b0bc-8a5d72ab4b78.pdf',
  NOW() - interval '84 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'dbe318a2-1989-5947-83bd-f1c692d00601',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  25000.0,
  'NGN',
  'missions',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-8008',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/cdf0b106-b532-5c5e-8c6f-0f1b80c130c2/9c0ff1a3-4121-548a-9626-44218cf14e1d.pdf',
  NOW() - interval '96 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '9ddb5fa7-f1f9-5c87-a4f9-93cc84e7e66a',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  110.0,
  'USD',
  'media',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-9009',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/fdef44c0-1ceb-5bc3-966a-4f1054c46fac/b5bca057-ddd9-5108-bc12-c7a7d1cb7430.pdf',
  NOW() - interval '108 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '7b818637-a3f7-51f6-8dd1-1fa8fd1d9357',
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  30000.0,
  'NGN',
  'building',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-10010',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/2e67cc75-477f-5e66-a641-fa76985d10e4/76eb299b-e774-5f2d-ad7b-f725f57e49a1.pdf',
  NOW() - interval '120 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'a60c0350-e314-5f20-9e66-18b46f880b3b',
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  130.0,
  'USD',
  'partnership',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-11011',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/d270b6cf-af4b-5c9b-bada-d37b12e7083d/2058d0c7-de72-5bc0-b845-b1d7972adf3d.pdf',
  NOW() - interval '132 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '239701fb-c304-513b-a2f8-f9bba43895a0',
  '8a11f317-311d-5241-b8a0-455f712265b5',
  35000.0,
  'NGN',
  'tithe',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-12012',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/8a11f317-311d-5241-b8a0-455f712265b5/f72e1904-8f47-5efa-8154-038865604a76.pdf',
  NOW() - interval '144 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '4dcc8d01-9cfd-5f23-b036-ffe81178aa4e',
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  150.0,
  'USD',
  'offering',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-13013',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/51e088ae-312d-5511-8546-14f07c1dd8b2/4b6e135c-07e2-5ba6-adf3-d04e3b00b59d.pdf',
  NOW() - interval '156 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '8778b015-b6bb-50b8-a03c-c10a98b6bb85',
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  40000.0,
  'NGN',
  'missions',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-14014',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/030eb783-fe4c-5b65-aee2-a921a1977359/10ce4c79-1621-55b0-9733-1b40a85ea4d0.pdf',
  NOW() - interval '168 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '45b6239c-876d-5da6-9af4-8fe7021a995c',
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  170.0,
  'USD',
  'media',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-15015',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/981d2863-e1cf-5a73-9863-b0b573c71eb7/1bdc4f93-7233-5e43-b99a-aeef5f4b0523.pdf',
  NOW() - interval '180 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '078f3550-d256-5c11-86df-318ff3c3b6b8',
  '1164ec13-a4de-5cc0-8eac-eb8833b16640',
  45000.0,
  'NGN',
  'building',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-16016',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/1164ec13-a4de-5cc0-8eac-eb8833b16640/d15860d4-ea6b-5efa-9f8d-338105b36008.pdf',
  NOW() - interval '192 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'd65d49e3-5c03-50ce-8127-2125c6a8b905',
  '1c27aaa9-2781-5750-9b68-25fee3a17b99',
  190.0,
  'USD',
  'partnership',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-17017',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/1c27aaa9-2781-5750-9b68-25fee3a17b99/cb4d4a17-f306-5b03-b8a1-b6fac29ff869.pdf',
  NOW() - interval '204 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '6d4389c3-0e2a-53ff-883a-c875337bbf82',
  '7126763d-b662-5599-8069-51cbfe88a56a',
  50000.0,
  'NGN',
  'tithe',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-18018',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/7126763d-b662-5599-8069-51cbfe88a56a/d01eb210-8d92-5db9-86ea-b8d81dac7d7c.pdf',
  NOW() - interval '216 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '1ca1eaff-439f-5afe-ba31-b3a7331e15b2',
  '7a9058c3-61ed-5188-b233-69fca99e66c0',
  210.0,
  'USD',
  'offering',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-19019',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/7a9058c3-61ed-5188-b233-69fca99e66c0/ed2eac88-4661-5a23-bfa8-49b706c4752a.pdf',
  NOW() - interval '228 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '91943ae7-4b69-5ff9-9c16-e1c3c3ff9dfb',
  'e453775a-166a-54df-a5b2-0081c12608dd',
  55000.0,
  'NGN',
  'missions',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-20020',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/e453775a-166a-54df-a5b2-0081c12608dd/d536ac75-9ffa-5a3b-a06d-6b03b1667f88.pdf',
  NOW() - interval '240 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'd5389fee-0a39-5f2b-8453-b7f27037c1a5',
  '051c1a02-6308-5a77-a3f1-f6cd8229242e',
  230.0,
  'USD',
  'media',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-21021',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/051c1a02-6308-5a77-a3f1-f6cd8229242e/7145362c-10ea-5182-b4d9-62026b648fe9.pdf',
  NOW() - interval '252 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '98649384-2c85-52c2-b987-7b3430cc1227',
  '14078da6-ea92-59c8-aa32-fa74fec6e2c4',
  60000.0,
  'NGN',
  'building',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-22022',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/14078da6-ea92-59c8-aa32-fa74fec6e2c4/bc328761-1afb-5fe5-a2d6-e27c19942c53.pdf',
  NOW() - interval '264 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'e9ca8903-5ee1-5c46-9c25-3fab0176e6d5',
  '13dcf743-d13f-5642-816c-e2421e3b775b',
  250.0,
  'USD',
  'partnership',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-23023',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/13dcf743-d13f-5642-816c-e2421e3b775b/2e4f5f07-6d81-5cb4-bb44-63ed5adb50ed.pdf',
  NOW() - interval '276 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '5ef03b37-5b27-5efa-9e68-4e276e009f17',
  '5cceeb1d-7a95-5f43-8b5b-069ed1de1651',
  65000.0,
  'NGN',
  'tithe',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-24024',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/5cceeb1d-7a95-5f43-8b5b-069ed1de1651/592dc1c6-4331-50d2-b9e1-aa18d5d147f9.pdf',
  NOW() - interval '288 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'fe8dea69-15ea-5f22-aa2b-4985abd19748',
  '49326b61-166d-5ae6-b288-dfd08f776172',
  270.0,
  'USD',
  'offering',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-25025',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/49326b61-166d-5ae6-b288-dfd08f776172/c8a2218d-be27-569e-873e-ecacf96b6a03.pdf',
  NOW() - interval '300 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '3e0f9a6c-98f1-5ef6-a93c-6c8e02328dd2',
  '241613d3-48a5-5736-a503-fbbe390e8d02',
  70000.0,
  'NGN',
  'missions',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-26026',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/241613d3-48a5-5736-a503-fbbe390e8d02/8c700816-f4eb-5ff6-881f-5b7aef764941.pdf',
  NOW() - interval '312 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'eebf4cb0-29b6-5d59-963f-4bcde713c5e0',
  '8e08990d-1c10-52d4-95d5-a7a24656ac16',
  290.0,
  'USD',
  'media',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-27027',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/8e08990d-1c10-52d4-95d5-a7a24656ac16/e617e644-de96-5b87-960a-d6dba6dd66e6.pdf',
  NOW() - interval '324 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '735b7a44-246b-5301-8c4b-337ce0ca79da',
  '8a279fe1-0ccc-5ad6-a3b4-01f13882be16',
  75000.0,
  'NGN',
  'building',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-28028',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/8a279fe1-0ccc-5ad6-a3b4-01f13882be16/74deff2e-a026-5e0a-a7e9-a4333170f962.pdf',
  NOW() - interval '336 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'abb3745c-8259-58a5-a5a9-57cd36e1f82c',
  '17037c2d-a6ba-5ff3-a083-64d2b96b6000',
  310.0,
  'USD',
  'partnership',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-29029',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/17037c2d-a6ba-5ff3-a083-64d2b96b6000/4c565d1d-b466-5cd9-9c67-e77f3002fc1b.pdf',
  NOW() - interval '348 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  'ac71c6d4-1686-504d-971e-663f9c192ee8',
  'a23a905b-10d3-5c22-8f08-ba193b5fed24',
  80000.0,
  'NGN',
  'tithe',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-30030',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/a23a905b-10d3-5c22-8f08-ba193b5fed24/b8f2e646-016b-5928-96f8-322ba425a35b.pdf',
  NOW() - interval '360 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '271ba3f9-ca8c-5b80-bb85-42a0c776ea42',
  '6b2dee77-c383-5011-aa9b-f2934b57ad3c',
  330.0,
  'USD',
  'offering',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-31031',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/6b2dee77-c383-5011-aa9b-f2934b57ad3c/1116397e-0581-5abd-b125-133362b468c5.pdf',
  NOW() - interval '372 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '0a6c558b-beb0-5f6c-9c5c-918303fe7cf6',
  '0b0fc815-5048-5f88-a8e8-80ee60459e1b',
  85000.0,
  'NGN',
  'missions',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-32032',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/0b0fc815-5048-5f88-a8e8-80ee60459e1b/64955b36-4259-5295-8dd4-280476e40c7b.pdf',
  NOW() - interval '384 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '66feda49-d64d-5b58-af91-02f2c8e663a4',
  'd3e86c7c-5012-5fb9-99d6-40c4a04961d3',
  350.0,
  'USD',
  'media',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-33033',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/d3e86c7c-5012-5fb9-99d6-40c4a04961d3/ad4f3258-c26c-5422-91d8-6ed10819164a.pdf',
  NOW() - interval '396 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '25dd7dd2-2b68-504b-a7f6-a2e760a76120',
  'eca334aa-bf34-503b-ba8b-aaed8566256d',
  90000.0,
  'NGN',
  'building',
  'paid',
  'stripe',
  'stripe',
  'REF-ST-34034',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/eca334aa-bf34-503b-ba8b-aaed8566256d/5813912a-27b6-5b37-8ac8-44c47dc79297.pdf',
  NOW() - interval '408 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '7a24d9c4-569c-5cac-bf62-19f3ee6c778b',
  'f7781772-4b52-5e49-8948-95f14685bb7d',
  370.0,
  'USD',
  'partnership',
  'paid',
  'paystack',
  'paystack',
  'REF-PA-35035',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/f7781772-4b52-5e49-8948-95f14685bb7d/6c9f0dc2-5e5d-5ddd-bfb7-dedae69cf846.pdf',
  NOW() - interval '420 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '66e99032-8b29-5627-9a4b-bc2cf4710a43',
  '4b6c0db2-8f0a-5dad-8505-667ad8f00e8d',
  95000.0,
  'NGN',
  'tithe',
  'pending',
  'stripe',
  'stripe',
  'REF-ST-36036',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/4b6c0db2-8f0a-5dad-8505-667ad8f00e8d/763d6a54-2556-5bb7-91f6-b85583cddddb.pdf',
  NOW() - interval '432 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '1b1351e0-8542-5ec8-a20b-31a117e5ce8a',
  '25a41fdc-b039-501f-af00-e6cb77497994',
  390.0,
  'USD',
  'offering',
  'pending',
  'paystack',
  'paystack',
  'REF-PA-37037',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/25a41fdc-b039-501f-af00-e6cb77497994/7c07084a-0eb4-5b52-93e4-9400ca0a9fe2.pdf',
  NOW() - interval '444 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '21892e76-d98b-54cc-82b9-6c739b13ca6a',
  '0c01fe67-dc09-582a-9ec2-d9f5119d14fa',
  100000.0,
  'NGN',
  'missions',
  'pending',
  'stripe',
  'stripe',
  'REF-ST-38038',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/0c01fe67-dc09-582a-9ec2-d9f5119d14fa/7be23f82-5f5f-5049-acdb-666f1938b29c.pdf',
  NOW() - interval '456 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '54cc669d-ad48-5eb0-bfc3-36854013881b',
  '2b34af49-23ce-53a0-ba9e-0ddc7662b96e',
  410.0,
  'USD',
  'media',
  'pending',
  'paystack',
  'paystack',
  'REF-PA-39039',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/2b34af49-23ce-53a0-ba9e-0ddc7662b96e/94d40e24-94e5-5cd7-9fb7-512e8c0a8a1a.pdf',
  NOW() - interval '468 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)
VALUES (
  '4044b595-6262-5e70-b56a-0ec38c9998aa',
  '99dd01fe-5504-5101-ab8c-311cef05ec2f',
  105000.0,
  'NGN',
  'building',
  'pending',
  'stripe',
  'stripe',
  'REF-ST-40040',
  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/99dd01fe-5504-5101-ab8c-311cef05ec2f/b000f798-2503-5837-86ef-e4e8cf2ded74.pdf',
  NOW() - interval '480 hours'
) ON CONFLICT (id) DO NOTHING;

-- ── 23. PRAYER REQUESTS ─────────────────────────────────────
INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  '7bad6517-3e12-5d15-a901-2fd07969b97b',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  'Need God''s direction for a job offer I received that requires relocation.',
  false,
  'resolved',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  NOW() - interval '2 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  'c495dcb0-5e8d-5b1d-a2ea-42348e4501cf',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  'I am praying for spiritual restoration and consistency in my quiet time.',
  false,
  'resolved',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  NOW() - interval '4 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  'b4a0aedc-954b-5f52-a411-b110367e9433',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  'Please pray for the salvation of my siblings who are currently far from grace.',
  false,
  'resolved',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  NOW() - interval '6 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  'ba790265-1cbc-5f94-a761-988331d7133d',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  'Thanking God for safe delivery! Please pray for the baby''s health.',
  false,
  'resolved',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  NOW() - interval '8 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  'fa69daf0-0feb-5ff1-8e40-7dc92c27d3d4',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  'Please pray for healing for my mother who is dealing with high blood pressure.',
  true,
  'resolved',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  NOW() - interval '10 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  '16ef5364-ec10-50e5-92e0-1cc626390255',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  'Need God''s direction for a job offer I received that requires relocation.',
  false,
  'resolved',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  NOW() - interval '12 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  '4356cbb7-0030-5814-a34f-e44b70b29377',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  'I am praying for spiritual restoration and consistency in my quiet time.',
  false,
  'resolved',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  NOW() - interval '14 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  '13e7025a-e4ef-5ab5-9cdb-d178024b85b0',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  'Please pray for the salvation of my siblings who are currently far from grace.',
  false,
  'resolved',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  NOW() - interval '16 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  'f4bf266c-ce84-5947-800f-bce1b0df4b60',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  'Thanking God for safe delivery! Please pray for the baby''s health.',
  false,
  'pending',
  NULL,
  NOW() - interval '18 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  '5a2349c9-c7e7-5e68-b6cb-e1e0836c6b7d',
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  'Please pray for healing for my mother who is dealing with high blood pressure.',
  true,
  'pending',
  NULL,
  NOW() - interval '20 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  'b3bbdc1b-9a21-534d-81d1-5a2c070205e4',
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  'Need God''s direction for a job offer I received that requires relocation.',
  false,
  'pending',
  NULL,
  NOW() - interval '22 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  '12e8a6c1-2585-5b99-bee3-ec9e95ffd2e5',
  '8a11f317-311d-5241-b8a0-455f712265b5',
  'I am praying for spiritual restoration and consistency in my quiet time.',
  false,
  'pending',
  NULL,
  NOW() - interval '24 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  '8cf67c8e-0476-5bae-b9c2-9544849012f5',
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  'Please pray for the salvation of my siblings who are currently far from grace.',
  false,
  'pending',
  NULL,
  NOW() - interval '26 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  'ca463dda-24b0-5467-8121-452843077d35',
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  'Thanking God for safe delivery! Please pray for the baby''s health.',
  false,
  'pending',
  NULL,
  NOW() - interval '28 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)
VALUES (
  '0a1e8716-7f89-5e6b-aaf3-789d409b61fd',
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  'Please pray for healing for my mother who is dealing with high blood pressure.',
  true,
  'pending',
  NULL,
  NOW() - interval '30 days'
) ON CONFLICT (id) DO NOTHING;

-- ── 24. PLANNER ENTRIES ─────────────────────────────────────
INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '09225dcc-5346-5363-97b5-a845ff55157f',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  CURRENT_DATE + 1,
  'Reflections on Sermon Part 1',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '1 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '9f995aec-1cab-5045-8702-caa9f4300264',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  CURRENT_DATE + 2,
  'Reflections on Sermon Part 2',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '2 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  'd24b785e-d422-54fa-b9fa-9d81b883104e',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  CURRENT_DATE + 3,
  'Reflections on Sermon Part 3',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '3 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '518419c8-6e1d-540c-9b2f-d54ed731f96c',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  CURRENT_DATE + 4,
  'Reflections on Sermon Part 4',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '4 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '16f0afe9-b6fe-5fab-94ba-53bc6a621cf7',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  CURRENT_DATE + 5,
  'Reflections on Sermon Part 5',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '5 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '8dbdb725-d931-5065-ac1b-ef24dff1a129',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  CURRENT_DATE + 6,
  'Reflections on Sermon Part 6',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '6 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  'd4da730e-daaa-50e9-b3db-1ba4ffebfcb3',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  CURRENT_DATE + 7,
  'Reflections on Sermon Part 7',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '7 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '128111c6-8991-5704-a9a8-4267031d6c86',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  CURRENT_DATE + 8,
  'Reflections on Sermon Part 8',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '8 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '35bb15de-64bd-541a-8010-2a5c2595a43c',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  CURRENT_DATE + 9,
  'Reflections on Sermon Part 9',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '9 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  'c1985b9c-1113-5ac6-a53c-84ba62aa1037',
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  CURRENT_DATE + 10,
  'Reflections on Sermon Part 10',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '10 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '0f3ceb7f-f911-586c-8bab-43251c98b489',
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  CURRENT_DATE + 11,
  'Reflections on Sermon Part 11',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '11 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '8c24893c-d228-5ee9-aa1a-eeb9ad3c673a',
  '8a11f317-311d-5241-b8a0-455f712265b5',
  CURRENT_DATE + 12,
  'Reflections on Sermon Part 12',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '12 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '74d7cb59-5a75-5e12-91df-b8e2355d2c18',
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  CURRENT_DATE + 13,
  'Reflections on Sermon Part 13',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '13 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  '5d65e12d-1482-50fe-ae31-bb8273fb8605',
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  CURRENT_DATE + 14,
  'Reflections on Sermon Part 14',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '14 days'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)
VALUES (
  'a4cb91b7-dfcf-595a-bb69-6362a930028c',
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  CURRENT_DATE + 15,
  'Reflections on Sermon Part 15',
  'Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.',
  NOW() - interval '15 days'
) ON CONFLICT (id) DO NOTHING;

-- ── 25. NOTIFICATIONS ───────────────────────────────────────
INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'f3280ccc-470b-555d-9367-334828e5e805',
  '9cd5f6ad-5dbc-573c-b912-ea02b5aa937b',
  'Upcoming Event Reminder',
  'Don''t miss the National Youth Power Conference starting this Saturday.',
  true,
  '/home',
  NOW() - interval '4 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'bbc58d54-788d-5057-857c-b7847c821cb2',
  'b43f27b8-1c37-5d32-a129-7c2e41e94135',
  'Donation Receipt Generated',
  'Your Tithe receipt of NGN 15000 is now available in documents.',
  true,
  '/home',
  NOW() - interval '8 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '1101a222-403e-5264-aa65-e24f6e1bb144',
  '71f38ffd-beb1-5ecb-90cf-014856476afe',
  'Prayer Request Assigned',
  'Your prayer request for family healing has been assigned to Pastor Grace.',
  true,
  '/home',
  NOW() - interval '12 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '85a15900-38a4-5c3c-9c7b-b94e13901dc0',
  '9aea834a-81d0-586a-986e-987fa8a71d2a',
  'New Group Message',
  'New message in Levites Choir General. Rehearsal schedule updated.',
  true,
  '/home',
  NOW() - interval '16 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'b5a5ef9b-46a2-5c37-a8dd-55cc3eac262f',
  '3ffeaaf1-0cae-5bc2-b729-55f9a447691e',
  'New Sermon Published',
  'Listen to ''Reclaiming Your Spiritual Authority'' by Pastor Kingsley.',
  true,
  '/home',
  NOW() - interval '20 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'ffe6511e-c6cc-512b-8d48-40cf509669e8',
  '5006102e-5fe9-5473-82f1-f67c327172d0',
  'Upcoming Event Reminder',
  'Don''t miss the National Youth Power Conference starting this Saturday.',
  true,
  '/home',
  NOW() - interval '24 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '4a169213-e6a9-5bbe-9184-39404f382b83',
  'b47acb94-e783-59b0-a1ea-4d1a7ad9a423',
  'Donation Receipt Generated',
  'Your Tithe receipt of NGN 15000 is now available in documents.',
  true,
  '/home',
  NOW() - interval '28 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '1fcdabc4-9cb0-5961-b6a4-a6f9b6b09887',
  'cdf0b106-b532-5c5e-8c6f-0f1b80c130c2',
  'Prayer Request Assigned',
  'Your prayer request for family healing has been assigned to Pastor Grace.',
  true,
  '/home',
  NOW() - interval '32 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'd8c18200-1b9b-5052-b4dd-8147146dd45f',
  'fdef44c0-1ceb-5bc3-966a-4f1054c46fac',
  'New Group Message',
  'New message in Levites Choir General. Rehearsal schedule updated.',
  true,
  '/home',
  NOW() - interval '36 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'e5330c2c-545b-5328-aa63-cce2068466c2',
  '2e67cc75-477f-5e66-a641-fa76985d10e4',
  'New Sermon Published',
  'Listen to ''Reclaiming Your Spiritual Authority'' by Pastor Kingsley.',
  true,
  '/home',
  NOW() - interval '40 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '9165f25e-9f70-526e-bfc5-a82f66a10490',
  'd270b6cf-af4b-5c9b-bada-d37b12e7083d',
  'Upcoming Event Reminder',
  'Don''t miss the National Youth Power Conference starting this Saturday.',
  true,
  '/home',
  NOW() - interval '44 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '11ed8bf8-b4c6-5fd6-b2ec-555ff9fd300c',
  '8a11f317-311d-5241-b8a0-455f712265b5',
  'Donation Receipt Generated',
  'Your Tithe receipt of NGN 15000 is now available in documents.',
  true,
  '/home',
  NOW() - interval '48 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'e3df71d7-a34e-5f4e-973f-8a2ba9dbfb4e',
  '51e088ae-312d-5511-8546-14f07c1dd8b2',
  'Prayer Request Assigned',
  'Your prayer request for family healing has been assigned to Pastor Grace.',
  true,
  '/home',
  NOW() - interval '52 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'bf04b123-132b-5491-b1ea-07b814ccbbf7',
  '030eb783-fe4c-5b65-aee2-a921a1977359',
  'New Group Message',
  'New message in Levites Choir General. Rehearsal schedule updated.',
  true,
  '/home',
  NOW() - interval '56 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '5fe8e9f9-83ef-532b-a153-5d573f2c97d8',
  '981d2863-e1cf-5a73-9863-b0b573c71eb7',
  'New Sermon Published',
  'Listen to ''Reclaiming Your Spiritual Authority'' by Pastor Kingsley.',
  true,
  '/home',
  NOW() - interval '60 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'db089d15-ba6e-5b42-ad02-1ee3eb534884',
  '1164ec13-a4de-5cc0-8eac-eb8833b16640',
  'Upcoming Event Reminder',
  'Don''t miss the National Youth Power Conference starting this Saturday.',
  false,
  '/home',
  NOW() - interval '64 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '7b224bb9-2a4d-5e23-91f6-1948119b7159',
  '1c27aaa9-2781-5750-9b68-25fee3a17b99',
  'Donation Receipt Generated',
  'Your Tithe receipt of NGN 15000 is now available in documents.',
  false,
  '/home',
  NOW() - interval '68 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'c5177d6a-6b61-5ac7-bf79-5283f9bcc8a4',
  '7126763d-b662-5599-8069-51cbfe88a56a',
  'Prayer Request Assigned',
  'Your prayer request for family healing has been assigned to Pastor Grace.',
  false,
  '/home',
  NOW() - interval '72 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '90bd304a-df82-5549-a316-254a8bc39415',
  '7a9058c3-61ed-5188-b233-69fca99e66c0',
  'New Group Message',
  'New message in Levites Choir General. Rehearsal schedule updated.',
  false,
  '/home',
  NOW() - interval '76 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '9fa513e7-c707-525e-952a-18211e954cff',
  'e453775a-166a-54df-a5b2-0081c12608dd',
  'New Sermon Published',
  'Listen to ''Reclaiming Your Spiritual Authority'' by Pastor Kingsley.',
  false,
  '/home',
  NOW() - interval '80 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '1490f2c6-8081-51a3-9548-2665afb3bcc4',
  '051c1a02-6308-5a77-a3f1-f6cd8229242e',
  'Upcoming Event Reminder',
  'Don''t miss the National Youth Power Conference starting this Saturday.',
  false,
  '/home',
  NOW() - interval '84 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '17358e0b-0979-5411-b0e4-829fa637f561',
  '14078da6-ea92-59c8-aa32-fa74fec6e2c4',
  'Donation Receipt Generated',
  'Your Tithe receipt of NGN 15000 is now available in documents.',
  false,
  '/home',
  NOW() - interval '88 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '5163f041-ab75-539e-aac4-37453f71ec1b',
  '13dcf743-d13f-5642-816c-e2421e3b775b',
  'Prayer Request Assigned',
  'Your prayer request for family healing has been assigned to Pastor Grace.',
  false,
  '/home',
  NOW() - interval '92 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  'f27c131e-c789-5fca-bb1e-41a81ab19d8a',
  '5cceeb1d-7a95-5f43-8b5b-069ed1de1651',
  'New Group Message',
  'New message in Levites Choir General. Rehearsal schedule updated.',
  false,
  '/home',
  NOW() - interval '96 hours'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)
VALUES (
  '4733a604-65e6-5fae-a79a-7484d80740e2',
  '49326b61-166d-5ae6-b288-dfd08f776172',
  'New Sermon Published',
  'Listen to ''Reclaiming Your Spiritual Authority'' by Pastor Kingsley.',
  false,
  '/home',
  NOW() - interval '100 hours'
) ON CONFLICT (id) DO NOTHING;

SET session_replication_role = 'origin';

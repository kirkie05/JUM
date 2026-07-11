-- Update events schema
ALTER TABLE public.events
ADD COLUMN IF NOT EXISTS is_published BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS start_time TEXT,
ADD COLUMN IF NOT EXISTS end_time TEXT;

-- Clear old events if any to avoid duplicates
DELETE FROM public.events;

-- Seed realistic events
INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time)
VALUES
(gen_random_uuid(), 'Sunday Worship Service', 'Join us for our weekly Sunday service filled with powerful praise, worship, and an impactful word.', CURRENT_DATE + INTERVAL '1 day', 'Main Sanctuary, JUM Center', 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=800', true, true, '09:00 AM', '12:00 PM'),
(gen_random_uuid(), 'Midweek Bible Study', 'Deep dive into the scriptures. Bring your questions and let us study together.', CURRENT_DATE + INTERVAL '3 days', 'Grace Hall & Online Zoom', 'https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&q=80&w=800', false, true, '06:30 PM', '08:00 PM'),
(gen_random_uuid(), 'Youth Night Encounter', 'An exciting evening for youth and young adults featuring dynamic worship and discussions.', CURRENT_DATE + INTERVAL '5 days', 'Youth Auditorium', 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=800', false, true, '07:00 PM', '09:30 PM'),
(gen_random_uuid(), 'Kingdom Leadership Summit', 'Empowering leaders across all domains with solid biblical truths, networking, and strategy.', CURRENT_DATE + INTERVAL '12 days', 'Main Auditorium & Live broadcast', 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&q=80&w=800', true, true, '09:00 AM', '01:00 PM'),
(gen_random_uuid(), 'Night of Breakthrough Prayer', 'Stand in the gap for nations. A powerful 24-hour prayer chain connecting believers.', CURRENT_DATE + INTERVAL '19 days', 'Virtual Assembly & campuses', 'https://images.unsplash.com/photo-1544027993-37dbfe43562a?auto=format&fit=crop&q=80&w=800', true, true, '06:00 PM', '06:00 AM'),
(gen_random_uuid(), 'Past Event: Women in Ministry', 'A wonderful gathering of women in ministry.', CURRENT_DATE - INTERVAL '10 days', 'Fellowship Hall', 'https://images.unsplash.com/photo-1491438590914-bc09fcaaf77a?auto=format&fit=crop&q=80&w=800', false, true, '10:00 AM', '01:00 PM'),
(gen_random_uuid(), 'Unpublished Event: Staff Retreat', 'Private staff retreat.', CURRENT_DATE + INTERVAL '20 days', 'Camp Shiloh', 'https://images.unsplash.com/photo-1473163928189-364b2c4e1135?auto=format&fit=crop&q=80&w=800', false, false, '08:00 AM', '05:00 PM');

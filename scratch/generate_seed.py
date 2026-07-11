import uuid
import random
import datetime

# Helper to generate UUIDs
def get_uuid(seed_name):
    return str(uuid.uuid5(uuid.NAMESPACE_DNS, f"jum.ministry.{seed_name}"))

# Helper to escape single quotes in SQL strings
def esc(val):
    if val is None:
        return ""
    return str(val).replace("'", "''")

# 50 Users data
user_profiles = [
    {"id": get_uuid("user_1"), "first_name": "Kingsley", "last_name": "Aniche", "email": "kingsley.aniche@jum.org", "role": "super_admin", "occupation": "Senior Pastor", "bio": "Senior Pastor and Founder of Jesus Unhindered Ministry. Dedicated to raising disciples and spreading unhindered grace.", "city": "Lagos", "country": "Nigeria", "phone": "+2348031234567"},
    {"id": get_uuid("user_2"), "first_name": "Grace", "last_name": "Adebayo", "email": "grace.adebayo@jum.org", "role": "admin", "occupation": "Associate Pastor", "bio": "Associate Pastor at JUM. Passionate about family life, counseling, and youth outreach.", "city": "Lagos", "country": "Nigeria", "phone": "+2348021112222"},
    {"id": get_uuid("user_3"), "first_name": "Emmanuel", "last_name": "Nwachukwu", "email": "emmanuel.n@jum.org", "role": "admin", "occupation": "Church Administrator", "bio": "Managing operational structures and logistics across JUM global campuses.", "city": "London", "country": "United Kingdom", "phone": "+447712345678"},
    {"id": get_uuid("user_4"), "first_name": "David", "last_name": "Vance", "email": "david.vance@jum.org", "role": "admin", "occupation": "Director of Media", "bio": "Overseeing global broadcasting, streaming platforms, and digital outreach for JUM.", "city": "Houston", "country": "United States", "phone": "+17135550199"},
    {"id": get_uuid("user_5"), "first_name": "Sarah", "last_name": "Jenkins", "email": "sarah.j@jum.org", "role": "leader", "occupation": "Worship Leader", "bio": "Worship director leading the Levites Choir to create an atmosphere of praise.", "city": "London", "country": "United Kingdom", "phone": "+447787654321"},
    {"id": get_uuid("user_6"), "first_name": "Joshua", "last_name": "Okonkwo", "email": "joshua.o@jum.org", "role": "leader", "occupation": "Youth Leader", "bio": "Empowering young minds through discipleship, seminars, and community service.", "city": "Lagos", "country": "Nigeria", "phone": "+2348033334444"},
    {"id": get_uuid("user_7"), "first_name": "Ruth", "last_name": "Bello", "email": "ruth.b@jum.org", "role": "leader", "occupation": "Prayer Coordinator", "bio": "Coordinating intercession teams and prayer chains for the local and global assembly.", "city": "Abuja", "country": "Nigeria", "phone": "+2348099998888"},
    {"id": get_uuid("user_8"), "first_name": "Michael", "last_name": "Thomas", "email": "michael.t@jum.org", "role": "leader", "occupation": "Missions Coordinator", "bio": "Leading JUM outreach efforts in disadvantaged communities across West Africa.", "city": "Lagos", "country": "Nigeria", "phone": "+2348055556666"},
    {"id": get_uuid("user_9"), "first_name": "Esther", "last_name": "Mensah", "email": "esther.m@jum.org", "role": "leader", "occupation": "Children Ministry Coordinator", "bio": "Guiding JUM Kids to grow in the admonition and knowledge of the Lord.", "city": "Accra", "country": "Ghana", "phone": "+233241234567"},
    {"id": get_uuid("user_10"), "first_name": "Caleb", "last_name": "Okereke", "email": "caleb.o@jum.org", "role": "leader", "occupation": "Ushering Unit Head", "bio": "Ensuring orderliness and a welcoming environment during church services.", "city": "Lagos", "country": "Nigeria", "phone": "+2348123456789"},
]

first_names = ["Daniel", "Rebecca", "Samuel", "Elizabeth", "Joseph", "Hannah", "John", "Deborah", "Paul", "Mary", "James", "Victoria", "Stephen", "Eunice", "Peter", "Kezia", "Timothy", "Lois", "Andrew", "Dorcas", "Philip", "Priscilla", "Thomas", "Martha", "Matthew", "Abigail", "Simon", "Lydia", "Jude", "Phoebe", "Mark", "Chloe", "Luke", "Joanna", "Jonathan", "Salome", "Barnabas", "Bernice", "Titus", "Rhoda"]
last_names = ["Ogunleye", "Smith", "Eze", "Johnson", "Adesina", "Williams", "Okafor", "Brown", "Ajayi", "Davis", "Igwe", "Jones", "Balogun", "Miller", "Nwosu", "Wilson", "Okeke", "Moore", "Alabi", "Taylor", "Olayemi", "Anderson", "Nduka", "Thomas", "Adeyemi", "Jackson", "Chukwu", "White", "Fatoda", "Harris", "Ibrahim", "Martin", "Oyetola", "Thompson", "Obi", "Garcia", "Babalola", "Martinez", "Umeh", "Robinson"]
occupations = ["Software Engineer", "Teacher", "Nurse", "Accountant", "Graphic Designer", "Entrepreneur", "Student", "Doctor", "Project Manager", "Architect", "Consultant", "Lawyer"]
cities = ["Lagos", "Abuja", "London", "Houston", "Atlanta", "Nairobi", "Accra", "Cape Town", "New York", "Manchester"]
countries = ["Nigeria", "Nigeria", "United Kingdom", "United States", "United States", "Kenya", "Ghana", "South Africa", "United States", "United Kingdom"]

random.seed(42)

for i in range(11, 51):
    role = "volunteer" if i <= 25 else "member"
    fn = first_names[i - 11]
    ln = last_names[i - 11]
    city = random.choice(cities)
    country = countries[cities.index(city)]
    user_profiles.append({
        "id": get_uuid(f"user_{i}"),
        "first_name": fn,
        "last_name": ln,
        "email": f"{fn.lower()}.{ln.lower()}{i}@jum.org",
        "role": role,
        "occupation": random.choice(occupations),
        "bio": f"Faithful {role} at JUM {city} assembly. Active in fellowship and serving the community.",
        "city": city,
        "country": country,
        "phone": f"+23480{random.randint(1000000, 9999999)}" if country == "Nigeria" else f"+4477{random.randint(1000000, 9999999)}"
    })

avatars = [
    "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200",
    "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=200",
    "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200",
    "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200",
    "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200",
]

for idx, u_prof in enumerate(user_profiles):
    u_prof["avatar"] = avatars[idx % len(avatars)]

# Build seed.sql
with open("supabase/seed.sql", "w") as f:
    f.write("-- ============================================================\n")
    f.write("-- JUM Seed Data File\n")
    f.write("-- Generated programmatically for JUM Ministry App\n")
    f.write("-- ============================================================\n\n")
    
    # 1. Disable triggers to prevent recursion or conflict issues during seeding
    f.write("SET session_replication_role = 'replica';\n\n")

    # 2. Delete existing data to make seeding clean and idempotent
    f.write("TRUNCATE auth.users CASCADE;\n")
    f.write("TRUNCATE public.profiles CASCADE;\n")
    f.write("TRUNCATE public.sermon_series CASCADE;\n")
    f.write("TRUNCATE public.sermons CASCADE;\n")
    f.write("TRUNCATE public.podcasts CASCADE;\n")
    f.write("TRUNCATE public.podcast_episodes CASCADE;\n")
    f.write("TRUNCATE public.groups CASCADE;\n")
    f.write("TRUNCATE public.group_members CASCADE;\n")
    f.write("TRUNCATE public.events CASCADE;\n")
    f.write("TRUNCATE public.event_registrations CASCADE;\n")
    f.write("TRUNCATE public.courses CASCADE;\n")
    f.write("TRUNCATE public.lessons CASCADE;\n")
    f.write("TRUNCATE public.quiz_questions CASCADE;\n")
    f.write("TRUNCATE public.quiz_attempts CASCADE;\n")
    f.write("TRUNCATE public.enrollments CASCADE;\n")
    f.write("TRUNCATE public.products CASCADE;\n")
    f.write("TRUNCATE public.orders CASCADE;\n")
    f.write("TRUNCATE public.donations CASCADE;\n")
    f.write("TRUNCATE public.posts CASCADE;\n")
    f.write("TRUNCATE public.comments CASCADE;\n")
    f.write("TRUNCATE public.likes CASCADE;\n")
    f.write("TRUNCATE public.conversations CASCADE;\n")
    f.write("TRUNCATE public.messages CASCADE;\n")
    f.write("TRUNCATE public.prayer_requests CASCADE;\n")
    f.write("TRUNCATE public.planner_entries CASCADE;\n")
    f.write("TRUNCATE public.notifications CASCADE;\n\n")

    # 3. Insert users into auth.users (triggers would run, but session_replication_role=replica disables them, so we must insert into profiles manually)
    f.write("-- ── 1. INSERTING USERS ──────────────────────────────────────\n")
    for u in user_profiles:
        f_name_esc = esc(u['first_name'])
        l_name_esc = esc(u['last_name'])
        full_name_esc = esc(f"{u['first_name']} {u['last_name']}")
        bio_esc = esc(u['bio'])
        city_esc = esc(u['city'])
        country_esc = esc(u['country'])
        meta_data = esc(f'{{"full_name":"{u["first_name"]} {u["last_name"]}","name":"{u["first_name"]} {u["last_name"]}"}}')

        # Auth User Insert
        f.write(f"INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, role, aud, is_super_admin)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{u['id']}',\n")
        f.write(f"  '{u['email']}',\n")
        # Encrypted password for 'Password123'
        f.write(f"  '$2a$10$tQO8s.lA8L035v1F3xpxV.03L9Y334lW1z6n68c07e05n02x7803e',\n")
        f.write(f"  NOW(),\n")
        f.write(f"  '{{\"provider\":\"email\",\"providers\":[\"email\"]}}',\n")
        f.write(f"  '{meta_data}',\n")
        f.write(f"  NOW() - interval '{random.randint(10, 100)} days',\n")
        f.write(f"  NOW(),\n")
        f.write(f"  'authenticated',\n")
        f.write(f"  'authenticated',\n")
        f.write(f"  {'true' if u['role'] == 'super_admin' else 'false'}\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

        # Profiles Insert (since triggers are bypassed under 'replica' mode)
        f.write(f"INSERT INTO public.profiles (id, name, full_name, first_name, email, phone, role, avatar_url, bio, created_at, updated_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{u['id']}',\n")
        f.write(f"  '{full_name_esc}',\n")
        f.write(f"  '{full_name_esc}',\n")
        f.write(f"  '{f_name_esc}',\n")
        f.write(f"  '{u['email']}',\n")
        f.write(f"  '{u['phone']}',\n")
        f.write(f"  '{u['role']}',\n")
        f.write(f"  '{u['avatar']}',\n")
        f.write(f"  '{bio_esc}',\n")
        f.write(f"  NOW() - interval '{random.randint(10, 100)} days',\n")
        f.write(f"  NOW()\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 4. Sermon Series
    f.write("-- ── 2. SERMON SERIES ────────────────────────────────────────\n")
    series_data = [
        {"id": get_uuid("series_1"), "title": "Unshakable Faith", "description": "Building a solid foundation of trust in God's promises amidst life's challenges.", "banner": "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800"},
        {"id": get_uuid("series_2"), "title": "Walking in Victory", "description": "Keys to overcoming spiritual, financial, and personal limitations through the word.", "banner": "https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=800"},
        {"id": get_uuid("series_3"), "title": "The Power of Praise", "description": "Exploring how thanksgiving and worship unlock breakthroughs and spiritual authority.", "banner": "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&q=80&w=800"},
        {"id": get_uuid("series_4"), "title": "Grace That Restores", "description": "Understanding the depth of God's unmerited favor to heal brokenness and renew hope.", "banner": "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80&w=800"},
        {"id": get_uuid("series_5"), "title": "Kingdom Leadership", "description": "Principles for leading families, workplaces, and assemblies according to Biblical standards.", "banner": "https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=800"}
    ]
    for s in series_data:
        title_esc = esc(s['title'])
        desc_esc = esc(s['description'])
        f.write(f"INSERT INTO public.sermon_series (id, title, description, banner_url, created_at)\n")
        f.write(f"VALUES ('{s['id']}', '{title_esc}', '{desc_esc}', '{s['banner']}', NOW() - interval '90 days') ON CONFLICT (id) DO NOTHING;\n")
    f.write("\n")

    # 5. Sermons (30 sermons)
    f.write("-- ── 3. SERMONS ──────────────────────────────────────────────\n")
    # Generate 1 sermon published TODAY
    latest_sermon_id = get_uuid("sermon_latest")
    latest_title = esc('Reclaiming Your Spiritual Authority')
    latest_desc = esc('In this sermon, Pastor Kingsley preaches on the believer authority in Christ, teaching practical steps to overcome doubt and walk in absolute victory in every sphere of life.')
    latest_preacher = esc('Pastor Kingsley Aniche')
    f.write(f"INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)\n")
    f.write(f"VALUES (\n")
    f.write(f"  '{latest_sermon_id}',\n")
    f.write(f"  '{series_data[1]['id']}',\n")
    f.write(f"  '{latest_title}',\n")
    f.write(f"  '{latest_desc}',\n")
    f.write(f"  '{latest_preacher}',\n")
    f.write(f"  NOW(),\n")
    f.write(f"  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',\n")
    f.write(f"  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',\n")
    f.write(f"  'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800',\n")
    f.write(f"  2450,\n")
    f.write(f"  'dQw4w9WgXcQ',\n")
    f.write(f"  NOW(),\n") # published today
    f.write(f"  NOW()\n")
    f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    preachers = ["Pastor Kingsley Aniche", "Pastor Grace Adebayo", "Dr. David Vance", "Evangelist Joshua Okonkwo"]
    youtube_ids = ["9bZkp7q19f0", "2Vv-BfVoq4g", "3JZ_D3ELwOQ", "VbfpW0yocdQ", "L_LUpnjgPso", "hT_nvWreIhg"]

    for i in range(1, 30):
        s_id = get_uuid(f"sermon_{i}")
        ser = random.choice(series_data)
        preacher = random.choice(preachers)
        yt_id = youtube_ids[i % len(youtube_ids)]
        date_ago = f"NOW() - interval '{i} days'"
        title_esc = esc(f"Sermon Part {i}: {ser['title']} Deep Dive")
        desc_esc = esc(f"An in-depth study expanding on {ser['title']}. Highlighting biblical principles, historical contexts, and daily applications for personal spiritual growth.")
        preacher_esc = esc(preacher)
        f.write(f"INSERT INTO public.sermons (id, series_id, title, description, preacher, date_preached, video_url, audio_url, thumbnail_url, duration_secs, youtube_video_id, published_at, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{s_id}',\n")
        f.write(f"  '{ser['id']}',\n")
        f.write(f"  '{title_esc}',\n")
        f.write(f"  '{desc_esc}',\n")
        f.write(f"  '{preacher_esc}',\n")
        f.write(f"  {date_ago},\n")
        f.write(f"  'https://www.youtube.com/watch?v={yt_id}',\n")
        f.write(f"  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-{ (i % 8) + 1 }.mp3',\n")
        f.write(f"  'https://images.unsplash.com/photo-{'1518156677180-95a2893f3e9f' if i%2==0 else '1465847899084'}?auto=format&fit=crop&q=80&w=800',\n")
        f.write(f"  {1800 + i * 50},\n")
        f.write(f"  '{yt_id}',\n")
        f.write(f"  {date_ago},\n")
        f.write(f"  {date_ago}\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 6. Podcasts & Podcast Episodes (15 episodes)
    f.write("-- ── 4. PODCASTS ─────────────────────────────────────────────\n")
    pod_data = [
        {"id": get_uuid("podcast_1"), "title": "Unhindered Grace Podcast", "description": "Conversations on radical grace, faith, and practical christian living with Senior Pastor Kingsley Aniche and guests.", "cover": "https://images.unsplash.com/photo-1590602847861-f357a9332bbc?auto=format&fit=crop&q=80&w=400"},
        {"id": get_uuid("podcast_2"), "title": "Kingdom Wisdom Daily", "description": "Daily mini-episodes packing powerful kingdom principles for leading, working, and growing in grace.", "cover": "https://images.unsplash.com/photo-1478737270239-2f02b77fc618?auto=format&fit=crop&q=80&w=400"},
        {"id": get_uuid("podcast_3"), "title": "The Faith Builder Show", "description": "Testimonies, deep studies, and discussions targeted at expanding personal faith and understanding of scriptural truths.", "cover": "https://images.unsplash.com/photo-1589903308904-1010c2294adc?auto=format&fit=crop&q=80&w=400"}
    ]
    for p in pod_data:
        title_esc = esc(p['title'])
        desc_esc = esc(p['description'])
        f.write(f"INSERT INTO public.podcasts (id, title, description, cover_url, created_at)\n")
        f.write(f"VALUES ('{p['id']}', '{title_esc}', '{desc_esc}', '{p['cover']}', NOW() - interval '60 days') ON CONFLICT (id) DO NOTHING;\n")
    f.write("\n")

    f.write("-- ── 5. PODCAST EPISODES ─────────────────────────────────────\n")
    for i in range(1, 16):
        ep_id = get_uuid(f"podcast_ep_{i}")
        pod = pod_data[i % len(pod_data)]
        title_esc = esc(f"Episode {i}: Radical Generosity & Stewardship")
        desc_esc = esc("In this episode, we discuss the spiritual discipline of stewardship, handling resources, and backing missions globally with radical obedience.")
        f.write(f"INSERT INTO public.podcast_episodes (id, podcast_id, title, description, audio_url, duration_secs, published_at, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{ep_id}',\n")
        f.write(f"  '{pod['id']}',\n")
        f.write(f"  '{title_esc}',\n")
        f.write(f"  '{desc_esc}',\n")
        f.write(f"  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-{(i % 6) + 1}.mp3',\n")
        f.write(f"  {1200 + i * 40},\n")
        f.write(f"  NOW() - interval '{i * 2} days',\n")
        f.write(f"  NOW() - interval '{i * 2} days'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 7. Events (15 events: past, present, upcoming. Ensure future events have is_published = true)
    f.write("-- ── 6. EVENTS ───────────────────────────────────────────────\n")
    events_list = [
        # Past events
        {"id": get_uuid("event_past_1"), "title": "JUM Annual Thanksgiving Retreat 2025", "desc": "A three-day spiritual renewal retreat for families to fellowship and start the new year in prayers.", "offset": -180, "is_pub": True, "location": "JUM Campgrounds, Lagos", "banner": "https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=800"},
        {"id": get_uuid("event_past_2"), "title": "Christmas Praise & Carol Night", "desc": "Worship, music recital, and fellowship night honoring the birth of Christ Jesus.", "offset": -190, "is_pub": True, "location": "Main Auditorium, JUM Lagos campus", "banner": "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&q=80&w=800"},
        {"id": get_uuid("event_past_3"), "title": "Workers and Leaders Consecration", "desc": "Consecration and charge service for all JUM workforce leaders and volunteers.", "offset": -15, "is_pub": True, "location": "Seminar Hall, Lagos", "banner": "https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=800"},
        
        # Present / Today / Immediate future
        {"id": get_uuid("event_current_1"), "title": "Leadership Summit 2026", "desc": "Empowering leaders across all domains with solid biblical truths, networking, and strategy.", "offset": 0, "is_pub": True, "location": "Main Auditorium & Live broadcast", "banner": "https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&q=80&w=800"},
        
        # Upcoming events (Future - will appear on home screen)
        {"id": get_uuid("event_up_1"), "title": "National Youth Power Conference 2026", "desc": "An explosive conference for youths featuring powerful preaching, career workshops, and worship.", "offset": 15, "is_pub": True, "location": "Lagos Exhibition Center", "banner": "https://images.unsplash.com/photo-1517263904808-5dc91e3e7044?auto=format&fit=crop&q=80&w=800"},
        {"id": get_uuid("event_up_2"), "title": "Global Prayer and Intercession Assembly", "desc": "Standing in the gap for nations. A 24-hour prayer chain connecting believers from all continents.", "offset": 30, "is_pub": True, "location": "Virtual Assembly & JUM campuses", "banner": "https://images.unsplash.com/photo-1544027993-37dbfe43562a?auto=format&fit=crop&q=80&w=800"},
        {"id": get_uuid("event_up_3"), "title": "Grace and Healing Miracle Night", "desc": "A night dedicated to prayers for the sick, deliverance, and experience of God's restoration power.", "offset": 45, "is_pub": True, "location": "Lagos State Stadium Grounds", "banner": "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800"},
        {"id": get_uuid("event_up_4"), "title": "Kingdom Finances and Wealth Seminar", "desc": "Biblical financial management, investments, and understanding covenant keys to business success.", "offset": 60, "is_pub": True, "location": "JUM Lagos Multi-purpose Hall", "banner": "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&q=80&w=800"},
        {"id": get_uuid("event_up_5"), "title": "JUM Global Praise Festival 2026", "desc": "Praise concert hosting multiple gospel ministers and choirs, celebrating unhindered miracles.", "offset": 75, "is_pub": True, "location": "Main Auditorium, Lagos Campus", "banner": "https://images.unsplash.com/photo-1506157786151-b8491531f063?auto=format&fit=crop&q=80&w=800"}
    ]

    # Generate 6 more upcoming events to reach 15 total events
    for idx in range(6):
        events_list.append({
            "id": get_uuid(f"event_more_{idx}"),
            "title": f"Ministry Outreach Seminar Part {idx+1}",
            "desc": f"Equipping volunteers for local missions and community engagements.",
            "offset": 90 + idx * 10,
            "is_pub": True if idx % 2 == 0 else False, # some draft
            "location": "Online / Zoom Conference",
            "banner": "https://images.unsplash.com/photo-1515187029135-18ee286d815b?auto=format&fit=crop&q=80&w=800"
        })

    for e in events_list:
        title_esc = esc(e['title'])
        desc_esc = esc(e['desc'])
        loc_esc = esc(e['location'])
        f.write(f"INSERT INTO public.events (id, title, description, event_date, location, banner_url, is_featured, is_published, start_time, end_time, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{e['id']}',\n")
        f.write(f"  '{title_esc}',\n")
        f.write(f"  '{desc_esc}',\n")
        f.write(f"  NOW() + interval '{e['offset']} days',\n")
        f.write(f"  '{loc_esc}',\n")
        f.write(f"  '{e['banner']}',\n")
        f.write(f"  {'true' if e['offset'] in [0, 15, 30] else 'false'},\n")
        f.write(f"  {'true' if e['is_pub'] else 'false'},\n")
        f.write(f"  '09:00 AM',\n")
        f.write(f"  '01:00 PM',\n")
        f.write(f"  NOW() - interval '30 days'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 8. Event Registrations (20 registrations across events)
    f.write("-- ── 7. EVENT REGISTRATIONS ──────────────────────────────────\n")
    for i in range(1, 21):
        user = user_profiles[i % len(user_profiles)]
        event = events_list[i % 5] # register for first 5 events (includes past, current, upcoming)
        f.write(f"INSERT INTO public.event_registrations (id, event_id, user_id, status, qr_code, registered_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'rsvp_{i}')}',\n")
        f.write(f"  '{event['id']}',\n")
        f.write(f"  '{user['id']}',\n")
        f.write(f"  'registered',\n")
        f.write(f"  'JUM-{event['id'][:8]}-{user['id'][:8]}-{i}',\n")
        f.write(f"  NOW() - interval '{i} days'\n")
        f.write(f") ON CONFLICT (event_id, user_id) DO NOTHING;\n\n")

    # 9. Groups (6 tribes/units)
    f.write("-- ── 8. GROUPS ───────────────────────────────────────────────\n")
    group_data = [
        {"id": get_uuid("group_1"), "name": "Ushering Unit", "desc": "Service unit ensuring orderliness, ushering guests, and maintaining sanctuary decorum.", "banner": "https://images.unsplash.com/photo-1528605248644-14dd04022da1?auto=format&fit=crop&q=80&w=600", "leader_id": user_profiles[9]['id']}, # Caleb
        {"id": get_uuid("group_2"), "name": "Levites Choir", "desc": "Sanctuary choir leading praise, worship, and vocal ministrations during services.", "banner": "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?auto=format&fit=crop&q=80&w=600", "leader_id": user_profiles[4]['id']}, # Sarah
        {"id": get_uuid("group_3"), "name": "Media & Streaming", "desc": "Technical service unit managing sound, video recording, live feeds, and screens.", "banner": "https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&q=80&w=600", "leader_id": user_profiles[3]['id']}, # David
        {"id": get_uuid("group_4"), "name": "Youth Fellowship", "desc": "Vibrant fellowship for youths, students, and young professionals. Ignite & Shine.", "banner": "https://images.unsplash.com/photo-1517263904808-5dc91e3e7044?auto=format&fit=crop&q=80&w=600", "leader_id": user_profiles[5]['id']}, # Joshua
        {"id": get_uuid("group_5"), "name": "Prayer Warriors", "desc": "Intercessory prayer squad meeting weekly for spiritual warfare and church protection.", "banner": "https://images.unsplash.com/photo-1544027993-37dbfe43562a?auto=format&fit=crop&q=80&w=600", "leader_id": user_profiles[6]['id']}, # Ruth
        {"id": get_uuid("group_6"), "name": "Missions Outpost", "desc": "Evangelism and community welfare outreach organizing local campaigns and food drives.", "banner": "https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=600", "leader_id": user_profiles[7]['id']} # Michael
    ]
    for g in group_data:
        name_esc = esc(g['name'])
        desc_esc = esc(g['desc'])
        f.write(f"INSERT INTO public.groups (id, name, description, banner_url, leader_id, created_at)\n")
        f.write(f"VALUES ('{g['id']}', '{name_esc}', '{desc_esc}', '{g['banner']}', '{g['leader_id']}', NOW() - interval '120 days') ON CONFLICT (id) DO NOTHING;\n")
    f.write("\n")

    f.write("-- ── 9. GROUP MEMBERS ────────────────────────────────────────\n")
    # Populate members (around 10 members in each group)
    member_idx = 0
    for g in group_data:
        # Leader is a member
        f.write(f"INSERT INTO public.group_members (id, group_id, user_id, joined_at)\n")
        f.write(f"VALUES ('{get_uuid(f'gm_leader_{g['id']}')}', '{g['id']}', '{g['leader_id']}', NOW() - interval '110 days') ON CONFLICT (group_id, user_id) DO NOTHING;\n")
        
        # Add 9 more members
        for m in range(9):
            user = user_profiles[(member_idx + m) % len(user_profiles)]
            f.write(f"INSERT INTO public.group_members (id, group_id, user_id, joined_at)\n")
            f.write(f"VALUES ('{get_uuid(f'gm_{g['id']}_{m}')}', '{g['id']}', '{user['id']}', NOW() - interval '90 days') ON CONFLICT (group_id, user_id) DO NOTHING;\n")
        member_idx += 9
    f.write("\n")

    # 10. Community Feed Posts, Comments, Likes (40 posts, 30 comments, 50 likes)
    f.write("-- ── 10. POSTS (COMMUNITY FEED) ──────────────────────────────\n")
    posts_list = [
        "Glory to God! The Miracle Service yesterday was mind-blowing. I was healed of severe chronic back pain that lasted for 3 years!",
        "Brothers and sisters, please stand in the gap with me as I prepare for my doctoral defense this Friday. I need divine clarity and wisdom.",
        "We thank God for a successful outreach at the local orphanage. JUM volunteers distributed food and clothing to over 150 children!",
        "What a profound word from Pastor Kingsley today: 'Walking in faith means taking steps even when you can only see the next inch.'",
        "Encouraging scripture of the day: 'Fear not, for I am with you; be not dismayed, for I am your God; I will strengthen you...' - Isaiah 41:10",
        "Happy anniversary to my amazing wife! We thank Pastor Kingsley and the JUM marriage counseling committee for guiding us.",
        "Just completed the 'Foundations of Faith' course in the Gospel Army School! Highly recommend it to anyone seeking spiritual grounding.",
        "My business was struggling for months, but after offering a faith seed and prayers last Sunday, I secured a major contract yesterday!",
        "Requesting prayers for our sister Hannah. She was admitted to the hospital, but we know Jesus is the Great Physician.",
        "Praise report: Sister Hannah is back home and fully recovered! God is still in the business of performing miracles!"
    ]
    
    # Generate 40 posts by duplicating/variating
    all_posts = []
    for i in range(1, 41):
        u_idx = i % len(user_profiles)
        user = user_profiles[u_idx]
        body = posts_list[(i - 1) % len(posts_list)]
        if i > 10:
            body = f"Reflecting on God's goodness (Post #{i}): " + body
        body_esc = esc(body)
        
        p_id = get_uuid(f"post_{i}")
        all_posts.append(p_id)
        media_url = "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=800" if i % 4 == 0 else "NULL"
        media_type = "'image'" if media_url != "NULL" else "NULL"
        media_url_val = f"'{media_url}'" if media_url != "NULL" else "NULL"
        
        f.write(f"INSERT INTO public.posts (id, user_id, body, media_url, media_type, likes_count, comments_count, is_announcement, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{p_id}',\n")
        f.write(f"  '{user['id']}',\n")
        f.write(f"  '{body_esc}',\n")
        f.write(f"  {media_url_val},\n")
        f.write(f"  {media_type},\n")
        f.write(f"  0,\n") # trigger or update will handle, but we initialize to 0
        f.write(f"  0,\n")
        f.write(f"  {'true' if i in [1, 7] else 'false'},\n")
        f.write(f"  NOW() - interval '{i * 6} hours'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    f.write("-- ── 11. COMMENTS (POSTS) ────────────────────────────────────\n")
    comments_list = [
        "Amen! God is indeed faithful.",
        "Wow, what an inspiring testimony!",
        "Standing in agreement with you in prayers.",
        "Congratulations! This is just the beginning.",
        "Thank you for sharing this encouraging word.",
        "Healings belong to us in Christ! Glory to His name.",
        "Congratulations on completing the course! Keep growing.",
        "Hallelujah! Our God is alive and active.",
        "Praying for speedy recovery and divine strength.",
        "This is so beautiful! God bless the missions team."
    ]
    for i in range(1, 31):
        post_id = all_posts[i % len(all_posts)]
        user = user_profiles[(i + 3) % len(user_profiles)]
        body = comments_list[(i - 1) % len(comments_list)]
        body_esc = esc(body)
        f.write(f"INSERT INTO public.comments (id, post_id, user_id, body, created_at)\n")
        f.write(f"VALUES ('{get_uuid(f'comment_{i}')}', '{post_id}', '{user['id']}', '{body_esc}', NOW() - interval '{i * 5} hours') ON CONFLICT (id) DO NOTHING;\n")
        # Manually increment count since triggers are bypassed under replica mode
        f.write(f"UPDATE public.posts SET comments_count = comments_count + 1 WHERE id = '{post_id}';\n")
    f.write("\n")

    f.write("-- ── 12. LIKES ───────────────────────────────────────────────\n")
    # Generate 50 likes
    like_pairs = set()
    like_count = 0
    while like_count < 50:
        p_id = random.choice(all_posts)
        u = random.choice(user_profiles)
        pair = (p_id, u['id'])
        if pair not in like_pairs:
            like_pairs.add(pair)
            like_count += 1
            f.write(f"INSERT INTO public.likes (id, user_id, post_id, created_at)\n")
            f.write(f"VALUES ('{get_uuid(f'like_{like_count}')}', '{u['id']}', '{p_id}', NOW() - interval '{like_count} hours') ON CONFLICT (user_id, post_id) DO NOTHING;\n")
            # Manually increment count
            f.write(f"UPDATE public.posts SET likes_count = likes_count + 1 WHERE id = '{p_id}';\n")
    f.write("\n")

    # 11. Messaging / Chats
    f.write("-- ── 13. CONVERSATIONS ───────────────────────────────────────\n")
    conv_data = []
    # 5 private 1:1 conversations
    for idx in range(1, 6):
        c_id = get_uuid(f"conv_private_{idx}")
        conv_data.append({"id": c_id, "is_group": False, "name": f"NULL"})
        f.write(f"INSERT INTO public.conversations (id, name, is_group, created_at)\n")
        f.write(f"VALUES ('{c_id}', NULL, false, NOW() - interval '30 days') ON CONFLICT (id) DO NOTHING;\n")
    
    # 5 group conversations (tribes/units chat)
    group_chat_names = ["Ushering Leaders", "Levites Choir General", "Media Technical Crew", "Youth Leaders Board", "Missions Committee"]
    for idx, name in enumerate(group_chat_names):
        c_id = get_uuid(f"conv_group_{idx}")
        conv_data.append({"id": c_id, "is_group": True, "name": f"'{name}'"})
        f.write(f"INSERT INTO public.conversations (id, name, is_group, created_at)\n")
        f.write(f"VALUES ('{c_id}', '{name}', true, NOW() - interval '60 days') ON CONFLICT (id) DO NOTHING;\n")
    f.write("\n")

    f.write("-- ── 14. MESSAGES ────────────────────────────────────────────\n")
    # Generate messages in conversations
    # For private chats
    private_msgs = [
        "Hello Leader Caleb, will we have a brief meeting after the second service?",
        "Yes, Brother, we need to review the ushering roster for the upcoming summit.",
        "Excellent. I have updated my availability in the planner.",
        "Thank you! God bless your dedication.",
        "Hello Sister Sarah, the chord sheet for Sunday's worship song has been updated.",
        "Got it! Let's schedule the rehearsal for Saturday 4 PM.",
        "Yes, looking forward to it. It's going to be a powerful service.",
    ]
    for idx, body in enumerate(private_msgs):
        c_id = conv_data[idx % 5]["id"]
        sender = user_profiles[idx % len(user_profiles)]
        receiver = user_profiles[(idx + 1) % len(user_profiles)]
        body_esc = esc(body)
        f.write(f"INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'msg_priv_{idx}')}',\n")
        f.write(f"  '{c_id}',\n")
        f.write(f"  '{sender['id']}',\n")
        f.write(f"  '{receiver['id']}',\n")
        f.write(f"  '{body_esc}',\n")
        f.write(f"  NOW() - interval '1 hour',\n") # read
        f.write(f"  NOW() - interval '{24 - idx} hours'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # Add 2 unread private messages
    unread_p_msgs = [
        "Hey! Are you attending the youth conference tomorrow?",
        "Just sent the updated slides to the media team. Let me know if it looks good."
    ]
    for idx, body in enumerate(unread_p_msgs):
        c_id = conv_data[idx % 5]["id"]
        sender = user_profiles[(idx + 3) % len(user_profiles)]
        receiver = user_profiles[idx % len(user_profiles)]
        body_esc = esc(body)
        f.write(f"INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'msg_unread_priv_{idx}')}',\n")
        f.write(f"  '{c_id}',\n")
        f.write(f"  '{sender['id']}',\n")
        f.write(f"  '{receiver['id']}',\n")
        f.write(f"  '{body_esc}',\n")
        f.write(f"  NULL,\n") # unread
        f.write(f"  NOW() - interval '15 minutes'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # Group messages
    group_msgs = [
        "Welcome team! Let's ensure everything is ready for the Sunday Broadcast.",
        "Audios checked, cameras set up, Impeller backend configured.",
        "Ushering assignments are fully uploaded. Let's welcome attendees with joy!",
        "Levites Choir rehearsals are moving to 3:30 PM this Saturday. Please be early.",
        "Missions team, the food packages are fully sorted. Ready for departure on Tuesday.",
    ]
    for idx, body in enumerate(group_msgs):
        c_id = conv_data[5 + (idx % 5)]["id"] # group chats start at index 5
        sender = user_profiles[(idx + 2) % len(user_profiles)]
        body_esc = esc(body)
        f.write(f"INSERT INTO public.messages (id, conversation_id, sender_id, receiver_id, body, read_at, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'msg_grp_{idx}')}',\n")
        f.write(f"  '{c_id}',\n")
        f.write(f"  '{sender['id']}',\n")
        f.write(f"  NULL,\n")
        f.write(f"  '{body_esc}',\n")
        f.write(f"  NOW() - interval '2 hours',\n")
        f.write(f"  NOW() - interval '{12 - idx} hours'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 12. Gospel Army (LMS) - Courses, Lessons, Quizzes, Quiz attempts, Enrollments
    f.write("-- ── 15. COURSES (GOSPEL ARMY) ────────────────────────────────\n")
    courses_data = [
        {"id": get_uuid("course_1"), "title": "Foundations of Faith", "desc": "Explore core Christian doctrines, the authority of scripture, and salvation principles.", "level": "Beginner", "thumb": "https://images.unsplash.com/photo-1544027993-37dbfe43562a?auto=format&fit=crop&q=80&w=400"},
        {"id": get_uuid("course_2"), "title": "Discipleship 101", "desc": "A guide to walking with Christ, personal devotion, and practicing radical generosity.", "level": "Intermediate", "thumb": "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&q=80&w=400"},
        {"id": get_uuid("course_3"), "title": "Advanced Christian Theology", "desc": "Deep study of covenants, pneumatology, end-time prophecy, and church history.", "level": "Advanced", "thumb": "https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?auto=format&fit=crop&q=80&w=400"},
        {"id": get_uuid("course_4"), "title": "Kingdom Stewardship & Wealth", "desc": "Understanding biblical economics, covenant financial keys, and running ethical business projects.", "level": "Intermediate", "thumb": "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&q=80&w=400"},
        {"id": get_uuid("course_5"), "title": "Christian Ethics & Society", "desc": "How to navigate moral issues, digital citizenship, and leadership roles in the modern workplace.", "level": "Advanced", "thumb": "https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=400"}
    ]
    for c in courses_data:
        title_esc = esc(c['title'])
        desc_esc = esc(c['desc'])
        f.write(f"INSERT INTO public.courses (id, title, description, thumbnail_url, level, is_published, created_at)\n")
        f.write(f"VALUES ('{c['id']}', '{title_esc}', '{desc_esc}', '{c['thumb']}', '{c['level']}', true, NOW() - interval '180 days') ON CONFLICT (id) DO NOTHING;\n")
    f.write("\n")

    f.write("-- ── 16. LESSONS (COURSES) ───────────────────────────────────\n")
    lessons_data = []
    # Create 3 lessons per course (15 lessons total)
    for c_idx, c in enumerate(courses_data):
        for l_idx in range(1, 4):
            l_id = get_uuid(f"lesson_{c['id']}_{l_idx}")
            lessons_data.append({"id": l_id, "course_id": c['id']})
            title_esc = esc(f"Lesson {l_idx}: Core Principles of {c['title']}")
            content_esc = esc(f"This lesson introduces foundational concepts related to {c['title']}. We will cover scriptural origins, practical challenges, and modern-day case studies.")
            f.write(f"INSERT INTO public.lessons (id, course_id, title, content, video_url, order_index, sort_order, created_at)\n")
            f.write(f"VALUES (\n")
            f.write(f"  '{l_id}',\n")
            f.write(f"  '{c['id']}',\n")
            f.write(f"  '{title_esc}',\n")
            f.write(f"  '{content_esc}',\n")
            f.write(f"  'https://www.youtube.com/watch?v=dQw4w9WgXcQ',\n")
            f.write(f"  {l_idx},\n") # order_index
            f.write(f"  {l_idx},\n") # sort_order
            f.write(f"  NOW() - interval '170 days'\n")
            f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    f.write("-- ── 17. QUIZ QUESTIONS ──────────────────────────────────────\n")
    # Quizzes for lessons (1 question per lesson to make it easy)
    for l in lessons_data:
        q_id = get_uuid(f"quiz_q_{l['id']}")
        q_esc = esc('What is the primary biblical foundation highlighted in this lesson?')
        opt0 = esc('Grace & Faith')
        opt1 = esc('Law & Works')
        opt2 = esc('Tradition')
        opt3 = esc('Human Philosophy')
        f.write(f"INSERT INTO public.quiz_questions (id, lesson_id, question, options, correct_index, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{q_id}',\n")
        f.write(f"  '{l['id']}',\n")
        f.write(f"  '{q_esc}',\n")
        # Array literal syntax for text[]
        f.write(f"  ARRAY['{opt0}', '{opt1}', '{opt2}', '{opt3}'],\n")
        f.write(f"  0,\n") # correct_index (0 = Grace & Faith)
        f.write(f"  NOW() - interval '160 days'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    f.write("-- ── 18. ENROLLMENTS ──────────────────────────────────────────\n")
    # Enrollments for users (15 enrollments total across users)
    # Some completed (100%), some in-progress (50%), some newly enrolled (0%)
    enroll_list = []
    for i in range(1, 16):
        user = user_profiles[i % len(user_profiles)]
        course = courses_data[i % len(courses_data)]
        progress = 100 if i <= 5 else (50 if i <= 10 else 0)
        completed_at = "NOW() - interval '10 days'" if progress == 100 else "NULL"
        
        f.write(f"INSERT INTO public.enrollments (id, user_id, course_id, progress_percent, completed_at, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'enroll_{i}')}',\n")
        f.write(f"  '{user['id']}',\n")
        f.write(f"  '{course['id']}',\n")
        f.write(f"  {progress},\n")
        f.write(f"  {completed_at},\n")
        f.write(f"  NOW() - interval '30 days'\n")
        f.write(f") ON CONFLICT (user_id, course_id) DO NOTHING;\n\n")

    f.write("-- ── 19. QUIZ ATTEMPTS ────────────────────────────────────────\n")
    # Attempts matching enrollments
    for i in range(1, 11): # first 10 enrollments (progress >= 50% implies they took some quizzes)
        user = user_profiles[i % len(user_profiles)]
        lesson = lessons_data[i % len(lessons_data)]
        f.write(f"INSERT INTO public.quiz_attempts (id, user_id, lesson_id, score, submitted_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'attempt_{i}')}',\n")
        f.write(f"  '{user['id']}',\n")
        f.write(f"  '{lesson['id']}',\n")
        f.write(f"  1,\n") # scored 1/1
        f.write(f"  NOW() - interval '15 days'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 13. Marketplace
    f.write("-- ── 20. PRODUCTS (MARKETPLACE) ──────────────────────────────\n")
    products_data = [
        {"id": get_uuid("prod_1"), "name": "Unhindered Grace Devotional 2026", "desc": "A daily guide packed with scriptural revelations, confessions, and declarations for an victorious year.", "price": 4500.00, "img": "https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400"},
        {"id": get_uuid("prod_2"), "name": "Walking in Covenant Purpose (Hardcover)", "desc": "Senior Pastor Kingsley Aniche's best-selling book detailing how to find, align, and accomplish your divine task on earth.", "price": 6000.00, "img": "https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&q=80&w=400"},
        {"id": get_uuid("prod_3"), "name": "JUM Branded Premium Hoodie", "desc": "Premium warm cotton hoodie embroidered with the Jesus Unhindered Ministry emblem. Inspire and shine.", "price": 15000.00, "img": "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&q=80&w=400"},
        {"id": get_uuid("prod_4"), "name": "Unhindered Praise CD & Digital Album", "desc": "Studio album from the Levites Choir featuring deep worship tracks, instrumental declarations, and miracle chants.", "price": 3000.00, "img": "https://images.unsplash.com/photo-1511192336575-5a79af67a629?auto=format&fit=crop&q=80&w=400"},
        {"id": get_uuid("prod_5"), "name": "Youth Power Conference 2026 Ticket", "desc": "Admit-one standard registration pass for the three-day National Youth Conference including materials and lunch.", "price": 5000.00, "img": "https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=400"}
    ]
    # Generate 10 more variations to reach 15 total items
    for idx in range(6, 16):
        products_data.append({
            "id": get_uuid(f"prod_{idx}"),
            "name": f"Kingdom Resource Merch Series {idx}",
            "desc": f"An excellent ministry study resource and branded merch highlighting grace and leadership principles.",
            "price": 2000.00 + idx * 500,
            "img": "https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400"
        })

    for p in products_data:
        name_esc = esc(p['name'])
        desc_esc = esc(p['desc'])
        f.write(f"INSERT INTO public.products (id, name, description, price, currency, image_urls, in_stock, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{p['id']}',\n")
        f.write(f"  '{name_esc}',\n")
        f.write(f"  '{desc_esc}',\n")
        f.write(f"  {p['price']},\n")
        f.write(f"  'NGN',\n")
        f.write(f"  ARRAY['{p['img']}'],\n")
        f.write(f"  true,\n")
        f.write(f"  NOW() - interval '60 days'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    f.write("-- ── 21. ORDERS (MARKETPLACE) ────────────────────────────────\n")
    # Generate 15 orders
    for i in range(1, 16):
        user = user_profiles[i % len(user_profiles)]
        prod = products_data[i % len(products_data)]
        total = prod['price']
        status = 'paid' if i <= 10 else 'pending'
        address = f"{user['city']}, {user['country']}"
        address_esc = esc(address)
        items_json = esc(f'{{"product_id": "{prod["id"]}", "quantity": 1, "name": "{prod["name"]}"}}')
        f.write(f"INSERT INTO public.orders (id, user_id, total_amount, status, items_json, shipping_address, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'order_{i}')}',\n")
        f.write(f"  '{user['id']}',\n")
        f.write(f"  {total},\n")
        f.write(f"  '{status}',\n")
        f.write(f"  '{items_json}'::jsonb,\n")
        f.write(f"  '{address_esc}',\n")
        f.write(f"  NOW() - interval '{i * 3} days'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 14. Donations / Giving History
    f.write("-- ── 22. DONATIONS (GIVING) ──────────────────────────────────\n")
    donations_categories = ["tithe", "offering", "missions", "media", "building", "partnership"]
    gateways = ["stripe", "paystack"]
    
    # Generate 40 donations
    for i in range(1, 41):
        user = user_profiles[i % len(user_profiles)]
        amount = 5000.00 + (i * 2500) if i % 2 == 0 else 20.00 + (i * 10) # mix NGN and USD
        currency = "NGN" if amount > 500 else "USD"
        category = donations_categories[i % len(donations_categories)]
        gateway = gateways[i % len(gateways)]
        status = "paid" if i <= 35 else "pending"
        ref_id = f"REF-{gateway[:2].upper()}-{i * 1000 + i}"
        
        f.write(f"INSERT INTO public.donations (id, user_id, amount, currency, category, status, provider, gateway, reference, receipt_url, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'donation_{i}')}',\n")
        f.write(f"  '{user['id']}',\n")
        f.write(f"  {amount},\n")
        f.write(f"  '{currency}',\n")
        f.write(f"  '{category}',\n")
        f.write(f"  '{status}',\n")
        f.write(f"  '{gateway}',\n") # provider
        f.write(f"  '{gateway}',\n") # gateway (fixes mismatch)
        f.write(f"  '{ref_id}',\n")
        f.write(f"  'https://vxuiokugixdrmgpmppbh.supabase.co/storage/v1/object/public/documents/{user['id']}/{get_uuid(f'receipt_{i}')}.pdf',\n")
        f.write(f"  NOW() - interval '{i * 12} hours'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 15. Prayer Requests
    f.write("-- ── 23. PRAYER REQUESTS ─────────────────────────────────────\n")
    prayer_bodies = [
        "Please pray for healing for my mother who is dealing with high blood pressure.",
        "Need God's direction for a job offer I received that requires relocation.",
        "I am praying for spiritual restoration and consistency in my quiet time.",
        "Please pray for the salvation of my siblings who are currently far from grace.",
        "Thanking God for safe delivery! Please pray for the baby's health."
    ]
    for i in range(1, 16):
        user = user_profiles[i % len(user_profiles)]
        body = prayer_bodies[i % len(prayer_bodies)]
        body_esc = esc(body)
        status = "resolved" if i <= 8 else "pending"
        assigned = user_profiles[2]['id'] if status == "resolved" else "NULL" # assigned to Grace Adebayo
        assigned_val = f"'{assigned}'" if assigned != "NULL" else "NULL"
        
        f.write(f"INSERT INTO public.prayer_requests (id, user_id, request_body, is_anonymous, status, assigned_to, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'prayer_{i}')}',\n")
        f.write(f"  '{user['id']}',\n")
        f.write(f"  '{body_esc}',\n")
        f.write(f"  {'true' if i % 5 == 0 else 'false'},\n")
        f.write(f"  '{status}',\n")
        f.write(f"  {assigned_val},\n")
        f.write(f"  NOW() - interval '{i * 2} days'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 16. Planner Entries
    f.write("-- ── 24. PLANNER ENTRIES ─────────────────────────────────────\n")
    for i in range(1, 16):
        user = user_profiles[i % len(user_profiles)]
        title_esc = esc(f"Reflections on Sermon Part {i}")
        body_esc = esc('Taking time to journal and reflect on JUM worship principles. Applying key lessons about generosity and faith to my work today.')
        f.write(f"INSERT INTO public.planner_entries (id, user_id, entry_date, title, body, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'plan_{i}')}',\n")
        f.write(f"  '{user['id']}',\n")
        f.write(f"  CURRENT_DATE + {i},\n") # entry_date
        f.write(f"  '{title_esc}',\n")
        f.write(f"  '{body_esc}',\n")
        f.write(f"  NOW() - interval '{i} days'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 17. Notifications (linked to various records)
    f.write("-- ── 25. NOTIFICATIONS ───────────────────────────────────────\n")
    notif_titles = [
        "New Sermon Published",
        "Upcoming Event Reminder",
        "Donation Receipt Generated",
        "Prayer Request Assigned",
        "New Group Message"
    ]
    notif_bodies = [
        "Listen to 'Reclaiming Your Spiritual Authority' by Pastor Kingsley.",
        "Don't miss the National Youth Power Conference starting this Saturday.",
        "Your Tithe receipt of NGN 15000 is now available in documents.",
        "Your prayer request for family healing has been assigned to Pastor Grace.",
        "New message in Levites Choir General. Rehearsal schedule updated."
    ]
    for i in range(1, 26):
        user = user_profiles[i % len(user_profiles)]
        title = notif_titles[i % len(notif_titles)]
        body = notif_bodies[i % len(notif_bodies)]
        title_esc = esc(title)
        body_esc = esc(body)
        f.write(f"INSERT INTO public.notifications (id, user_id, title, body, is_read, action_url, created_at)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'notif_{i}')}',\n")
        f.write(f"  '{user['id']}',\n")
        f.write(f"  '{title_esc}',\n")
        f.write(f"  '{body_esc}',\n")
        f.write(f"  {'true' if i <= 15 else 'false'},\n")
        f.write(f"  '/home',\n")
        f.write(f"  NOW() - interval '{i * 4} hours'\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # 18. Re-enable triggers and restore replica mode
    f.write("SET session_replication_role = 'origin';\n")

print("Created supabase/seed.sql successfully!")

# Build storage_seed.sql
with open("supabase/storage_seed.sql", "w") as f:
    f.write("-- ============================================================\n")
    f.write("-- JUM Storage Seed Data File\n")
    f.write("-- Inserts metadata into storage.objects for referenced assets\n")
    f.write("-- ============================================================\n\n")
    
    f.write("TRUNCATE storage.objects CASCADE;\n\n")
    
    # Avatars bucket entries
    f.write("-- ── 1. AVATARS BUCKET OBJECTS ────────────────────────────────\n")
    for idx, u in enumerate(user_profiles):
        f.write(f"INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'avatar_obj_{idx}')}',\n")
        f.write(f"  'avatars',\n")
        f.write(f"  '{u['id']}/avatar.jpg',\n")
        f.write(f"  '{u['id']}',\n")
        f.write(f"  NOW(), NOW(), NOW(),\n")
        f.write(f"  '{{\"size\": 24500, \"mimetype\": \"image/jpeg\"}}'::jsonb\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

    # Banners and thumbnails buckets entries
    f.write("-- ── 2. MEDIA BUCKET OBJECTS ──────────────────────────────────\n")
    for idx, s in enumerate(series_data):
        f.write(f"INSERT INTO storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata)\n")
        f.write(f"VALUES (\n")
        f.write(f"  '{get_uuid(f'series_obj_{idx}')}',\n")
        f.write(f"  'sermons',\n")
        f.write(f"  'series/{s['id']}/banner.jpg',\n")
        f.write(f"  NULL,\n")
        f.write(f"  NOW(), NOW(), NOW(),\n")
        f.write(f"  '{{\"size\": 105400, \"mimetype\": \"image/jpeg\"}}'::jsonb\n")
        f.write(f") ON CONFLICT (id) DO NOTHING;\n\n")

print("Created supabase/storage_seed.sql successfully!")

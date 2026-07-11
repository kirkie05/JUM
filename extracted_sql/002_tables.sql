-- ============================================================
-- JUM Backend Schema v2 — Single Church Edition
-- Migration 002: All Tables
--
-- NO churches table. NO church_id on every row.
-- This is the app for Jesus Unhindered Ministry only.
-- All RLS is based on user role, not church membership.
-- ============================================================

-- ── 1. USERS ─────────────────────────────────────────────────
-- All members of Jesus Unhindered Ministry.
-- clerk_id is the link to the Clerk auth identity.
-- role controls what each user can see and do.
CREATE TABLE users (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  clerk_id    TEXT        NOT NULL UNIQUE,
  name        TEXT        NOT NULL DEFAULT '',
  email       TEXT        NOT NULL,
  phone       TEXT,
  role        TEXT        NOT NULL DEFAULT 'member'
              CHECK (role IN ('admin','leader','member')),
  avatar_url  TEXT,
  bio         TEXT        CHECK (char_length(bio) <= 160),
  department  TEXT,       -- e.g. "Worship", "Ushers", "Youth"
  joined_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- Roles:
--   admin   → full access (pastor / church admin)
--   leader  → cell leaders, unit heads — sees member list, forms inbox
--   member  → standard congregation member

-- ── 2. SERMONS ───────────────────────────────────────────────
-- JUM sermon archive — audio and video.
CREATE TABLE sermons (
  id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  title            TEXT        NOT NULL,
  description      TEXT,
  speaker          TEXT        NOT NULL DEFAULT 'Pastor',
  series           TEXT,       -- sermon series grouping
  media_url        TEXT        NOT NULL,
  thumbnail_url    TEXT,
  type             TEXT        NOT NULL CHECK (type IN ('audio','video')),
  duration_seconds INT,
  published_at     TIMESTAMPTZ DEFAULT NOW(),  -- NULL = draft, not visible to members
  created_by       UUID        REFERENCES users(id) ON DELETE SET NULL
);

-- ── 3. SERMON NOTES ──────────────────────────────────────────
-- Personal notes a member takes during a sermon.
CREATE TABLE sermon_notes (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  sermon_id   UUID        NOT NULL REFERENCES sermons(id) ON DELETE CASCADE,
  content     TEXT        NOT NULL DEFAULT '',
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, sermon_id)
);

-- ── 4. COMMUNITY: Posts, Likes, Comments ─────────────────────
-- The social/community feed for JUM members.
CREATE TABLE posts (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  body        TEXT        NOT NULL
              CHECK (char_length(body) > 0 AND char_length(body) <= 2000),
  media_url   TEXT,
  media_type  TEXT        CHECK (media_type IN ('image','video')),
  likes_count INT         NOT NULL DEFAULT 0,  -- maintained by trigger
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE post_likes (
  post_id  UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  PRIMARY KEY (post_id, user_id)
);

CREATE TABLE comments (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id     UUID        NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  body        TEXT        NOT NULL
              CHECK (char_length(body) > 0 AND char_length(body) <= 500),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 5. GROUPS ────────────────────────────────────────────────
-- JUM internal groups: cells, departments, prayer groups, etc.
CREATE TABLE groups (
  id           UUID    PRIMARY KEY DEFAULT uuid_generate_v4(),
  name         TEXT    NOT NULL,
  description  TEXT,
  is_private   BOOL    NOT NULL DEFAULT false,  -- private = invite only
  cover_url    TEXT,
  created_by   UUID    REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE group_members (
  group_id  UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  user_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role      TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('admin','member')),
  joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (group_id, user_id)
);

-- ── 6. MESSAGING ─────────────────────────────────────────────
-- 1:1 and group chat between members.
CREATE TABLE messages (
  id           UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id    UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  receiver_id  UUID        REFERENCES users(id) ON DELETE SET NULL,  -- 1:1 only
  group_id     UUID        REFERENCES groups(id) ON DELETE CASCADE,   -- group only
  body         TEXT        NOT NULL CHECK (char_length(body) > 0),
  read_at      TIMESTAMPTZ,   -- NULL = unread
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- Exactly one destination: either receiver_id or group_id, never both
  CONSTRAINT chk_message_recipient CHECK (
    (receiver_id IS NOT NULL AND group_id IS NULL) OR
    (receiver_id IS NULL     AND group_id IS NOT NULL)
  )
);

-- ── 7. LIVE STREAMS ──────────────────────────────────────────
-- JUM Sunday services and special broadcasts via Mux.
CREATE TABLE live_streams (
  id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  mux_stream_id    TEXT,       -- Mux RTMP stream key (set by admin)
  mux_playback_id  TEXT,       -- Mux HLS playback ID
  title            TEXT        NOT NULL,
  description      TEXT,
  status           TEXT        NOT NULL DEFAULT 'idle'
                   CHECK (status IN ('idle','active','ended')),
  scheduled_at     TIMESTAMPTZ,
  ended_at         TIMESTAMPTZ,
  created_by       UUID        REFERENCES users(id) ON DELETE SET NULL
);

-- Live chat messages during a stream
CREATE TABLE stream_messages (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  stream_id   UUID        NOT NULL REFERENCES live_streams(id) ON DELETE CASCADE,
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  body        TEXT        NOT NULL
              CHECK (char_length(body) > 0 AND char_length(body) <= 300),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 8. EVENTS ────────────────────────────────────────────────
-- JUM events: conferences, socials, prayer nights, etc.
CREATE TABLE events (
  id            UUID           PRIMARY KEY DEFAULT uuid_generate_v4(),
  title         TEXT           NOT NULL,
  description   TEXT,
  date          TIMESTAMPTZ    NOT NULL,
  end_date      TIMESTAMPTZ,
  location      TEXT,
  cover_url     TEXT,
  is_paid       BOOL           NOT NULL DEFAULT false,
  ticket_price  NUMERIC(12,2),
  created_by    UUID           REFERENCES users(id) ON DELETE SET NULL
);

-- Member RSVPs with QR ticket codes
CREATE TABLE rsvps (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  event_id    UUID        NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  qr_code     TEXT        NOT NULL UNIQUE,   -- "JUM-{eventId}-{userId}-{uuid}"
  checked_in  BOOL        NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, event_id)
);

-- ── 9. PASTORAL FORMS ────────────────────────────────────────
-- Salvation decisions, visitor cards, prayer requests, testimonies.
-- All routed to a leader for follow-up.
CREATE TABLE forms (
  id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  type          TEXT        NOT NULL
                CHECK (type IN ('salvation','visitor','prayer','testimony')),
  data_json     JSONB       NOT NULL DEFAULT '{}',  -- flexible per form type
  submitted_by  UUID        REFERENCES users(id) ON DELETE SET NULL,  -- nullable = anonymous
  assigned_to   UUID        REFERENCES users(id) ON DELETE SET NULL,  -- auto-assigned leader
  status        TEXT        NOT NULL DEFAULT 'new'
                CHECK (status IN ('new','in_progress','done')),
  notes         TEXT,       -- pastoral follow-up notes
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 10. GIVING ───────────────────────────────────────────────
-- Tithes, offerings, donations, and seeds via Paystack (Nigeria) + Stripe (global).
CREATE TABLE giving_transactions (
  id          UUID           PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID           NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount      NUMERIC(12,2)  NOT NULL CHECK (amount > 0),
  currency    TEXT           NOT NULL DEFAULT 'NGN',
  category    TEXT           NOT NULL
              CHECK (category IN ('tithe','offering','donation','seed')),
  gateway     TEXT           NOT NULL CHECK (gateway IN ('paystack','stripe')),
  reference   TEXT           NOT NULL UNIQUE,  -- gateway transaction ID (idempotency key)
  status      TEXT           NOT NULL DEFAULT 'pending'
              CHECK (status IN ('pending','paid','failed','refunded')),
  receipt_url TEXT,          -- Supabase Storage URL to generated PDF receipt
  created_at  TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

-- ── 11. GOSPEL ARMY SCHOOL (LMS) ─────────────────────────────
-- JUM's internal discipleship school.
CREATE TABLE courses (
  id            UUID  PRIMARY KEY DEFAULT uuid_generate_v4(),
  title         TEXT  NOT NULL,
  description   TEXT,
  cover_url     TEXT,
  is_published  BOOL  NOT NULL DEFAULT false,  -- false = draft, hidden from members
  created_by    UUID  REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE lessons (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id        UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title            TEXT NOT NULL,
  video_url        TEXT,
  pdf_url          TEXT,
  duration_seconds INT,
  sort_order       INT  NOT NULL DEFAULT 0  -- ORDER BY sort_order ASC always
);

CREATE TABLE enrollments (
  id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id          UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id        UUID        NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  progress_percent INT         NOT NULL DEFAULT 0
                   CHECK (progress_percent BETWEEN 0 AND 100),
  completed_at     TIMESTAMPTZ,  -- set automatically when progress_percent = 100
  UNIQUE (user_id, course_id)
);

CREATE TABLE quiz_questions (
  id             UUID  PRIMARY KEY DEFAULT uuid_generate_v4(),
  lesson_id      UUID  NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  question       TEXT  NOT NULL,
  options_json   JSONB NOT NULL,   -- ["Option A", "Option B", "Option C", "Option D"]
  correct_index  INT   NOT NULL    -- 0-based index into options_json array
);

CREATE TABLE quiz_attempts (
  id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id       UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  lesson_id     UUID        NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  score         INT         NOT NULL,  -- number of correct answers
  total         INT         NOT NULL,  -- total questions (for % calculation)
  submitted_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 12. PODCAST ──────────────────────────────────────────────
-- JUM podcast episodes (audio only).
CREATE TABLE podcast_episodes (
  id               UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  title            TEXT        NOT NULL,
  description      TEXT,
  audio_url        TEXT        NOT NULL,
  duration_seconds INT,
  published_at     TIMESTAMPTZ DEFAULT NOW(),  -- NULL = draft
  created_by       UUID        REFERENCES users(id) ON DELETE SET NULL
);

-- ── 13. MARKETPLACE ──────────────────────────────────────────
-- JUM bookstore / resource store: books, CDs, courses, merch.
CREATE TABLE products (
  id           UUID           PRIMARY KEY DEFAULT uuid_generate_v4(),
  title        TEXT           NOT NULL,
  description  TEXT,
  type         TEXT           NOT NULL CHECK (type IN ('digital','physical')),
  price        NUMERIC(12,2)  NOT NULL CHECK (price >= 0),
  currency     TEXT           NOT NULL DEFAULT 'NGN',
  media_url    TEXT,          -- download URL for digital products
  cover_url    TEXT,
  stock        INT,           -- NULL = unlimited (digital products)
  is_active    BOOL           NOT NULL DEFAULT true
);

CREATE TABLE orders (
  id            UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id       UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id    UUID        NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  stripe_pi_id  TEXT,       -- Stripe PaymentIntent ID (for global purchases)
  paystack_ref  TEXT,       -- Paystack reference (for Nigeria purchases)
  status        TEXT        NOT NULL DEFAULT 'pending'
                CHECK (status IN ('pending','paid','shipped','cancelled')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 14. NOTIFICATIONS ────────────────────────────────────────
-- In-app notification inbox, triggered by Edge Functions.
CREATE TABLE notifications (
  id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type        TEXT        NOT NULL,  -- 'new_sermon' | 'live_starting' | 'new_event' | 'form_assigned' | 'message'
  title       TEXT        NOT NULL,
  body        TEXT,
  data_json   JSONB       DEFAULT '{}',   -- deep-link params e.g. {"sermon_id":"..."}
  read_at     TIMESTAMPTZ,               -- NULL = unread
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 15. SERVICE SCHEDULE ─────────────────────────────────────
-- JUM's recurring service times shown on the home screen.
CREATE TABLE service_schedules (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title        TEXT NOT NULL,    -- e.g. "Sunday Morning Service"
  day_of_week  INT  NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),  -- 0=Sunday
  time         TEXT NOT NULL,    -- "HH:MM" format
  location     TEXT,
  recurrence   TEXT NOT NULL DEFAULT 'weekly'
               CHECK (recurrence IN ('weekly','biweekly','monthly','once')),
  is_active    BOOL NOT NULL DEFAULT true
);

-- ── 16. ATTENDANCE ───────────────────────────────────────────
-- Track service attendance — scanned at the door or self-checked-in.
CREATE TABLE attendance (
  id           UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id      UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  schedule_id  UUID        REFERENCES service_schedules(id) ON DELETE SET NULL,
  event_id     UUID        REFERENCES events(id) ON DELETE SET NULL,
  attended_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  method       TEXT        NOT NULL DEFAULT 'qr'
               CHECK (method IN ('qr','manual','self'))
);

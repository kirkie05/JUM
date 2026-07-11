-- ============================================================
-- JUM Backend Schema v3
-- Migration 002: All Tables
-- ============================================================

-- ── 1. USERS / PROFILES ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS profiles (
  id          UUID        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name        TEXT        NOT NULL,
  email       TEXT        NOT NULL UNIQUE,
  phone       TEXT,
  role        TEXT        NOT NULL DEFAULT 'member', -- member, leader, admin, super_admin
  avatar_url  TEXT,
  bio         TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 2. COMMUNITY FEED ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS posts (
  id               UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  body             TEXT        NOT NULL,
  media_url        TEXT,
  media_type       TEXT,
  likes_count      INT         NOT NULL DEFAULT 0,
  comments_count   INT         NOT NULL DEFAULT 0,
  is_announcement  BOOLEAN     NOT NULL DEFAULT false,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS comments (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id     UUID        NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  user_id     UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  body        TEXT        NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS likes (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  post_id     UUID        NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

-- ── 3. GROUPS (Tribes/Service Units) ─────────────────────────
CREATE TABLE IF NOT EXISTS groups (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT        NOT NULL,
  description TEXT,
  banner_url  TEXT,
  leader_id   UUID        REFERENCES profiles(id) ON DELETE SET NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS group_members (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id    UUID        NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  user_id     UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  joined_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(group_id, user_id)
);

-- ── 4. MESSAGING (Conversations) ─────────────────────────────
CREATE TABLE IF NOT EXISTS conversations (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT,
  is_group    BOOLEAN     NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS messages (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID        REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id       UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  receiver_id     UUID        REFERENCES profiles(id) ON DELETE CASCADE,
  body            TEXT        NOT NULL,
  read_at         TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 5. EVENTS ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS events (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  title        TEXT        NOT NULL,
  description  TEXT,
  event_date   TIMESTAMPTZ NOT NULL,
  location     TEXT,
  banner_url   TEXT,
  is_featured  BOOLEAN     NOT NULL DEFAULT false,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS event_registrations (
  id               UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id         UUID        NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  user_id          UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  status           TEXT        NOT NULL DEFAULT 'registered',
  qr_code          TEXT,
  registered_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(event_id, user_id)
);

-- ── 6. MEDIA (Sermons & Podcasts) ────────────────────────────
CREATE TABLE IF NOT EXISTS sermon_series (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  title       TEXT        NOT NULL,
  description TEXT,
  banner_url  TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS sermons (
  id            UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  series_id     UUID           REFERENCES sermon_series(id) ON DELETE SET NULL,
  title         TEXT           NOT NULL,
  description   TEXT,
  preacher      TEXT           NOT NULL,
  date_preached TIMESTAMPTZ    NOT NULL,
  video_url     TEXT,
  audio_url     TEXT,
  thumbnail_url TEXT,
  duration_secs INT,
  created_at    TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS podcasts (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  title       TEXT        NOT NULL,
  description TEXT,
  cover_url   TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS podcast_episodes (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  podcast_id    UUID        NOT NULL REFERENCES podcasts(id) ON DELETE CASCADE,
  title         TEXT        NOT NULL,
  description   TEXT,
  audio_url     TEXT        NOT NULL,
  duration_secs INT,
  published_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 7. GOSPEL ARMY (Digital Discipleship) ────────────────────
CREATE TABLE IF NOT EXISTS courses (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  title       TEXT        NOT NULL,
  description TEXT,
  thumbnail_url TEXT,
  level       TEXT        NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS lessons (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id     UUID        NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title         TEXT        NOT NULL,
  content       TEXT,
  video_url     TEXT,
  order_index   INT         NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS quizzes (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id   UUID        NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  questions   JSONB       NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS enrollments (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  course_id        UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  progress_percent INT  NOT NULL DEFAULT 0,
  completed_at     TIMESTAMPTZ,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, course_id)
);

-- ── 8. MARKETPLACE ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS products (
  id               UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name             TEXT        NOT NULL,
  description      TEXT,
  price            DECIMAL(10,2) NOT NULL,
  currency         TEXT        NOT NULL DEFAULT 'NGN',
  image_urls       TEXT[],
  in_stock         BOOLEAN     NOT NULL DEFAULT true,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
  id             UUID  PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID  NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  total_amount   DECIMAL(10,2) NOT NULL,
  status         TEXT  NOT NULL DEFAULT 'pending',
  items_json     JSONB NOT NULL,
  shipping_address TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 9. GIVING / DONATIONS ────────────────────────────────────
CREATE TABLE IF NOT EXISTS donations (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  amount        DECIMAL(10,2) NOT NULL,
  currency      TEXT        NOT NULL DEFAULT 'NGN',
  category      TEXT        NOT NULL,
  status        TEXT        NOT NULL DEFAULT 'pending',
  provider      TEXT,
  reference     TEXT,
  receipt_url   TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── 10. FORMS & UTILS ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS prayer_requests (
  id               UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID        REFERENCES profiles(id) ON DELETE SET NULL,
  request_body     TEXT        NOT NULL,
  is_anonymous     BOOLEAN     NOT NULL DEFAULT false,
  status           TEXT        NOT NULL DEFAULT 'pending',
  assigned_to      UUID        REFERENCES profiles(id) ON DELETE SET NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS planner_entries (
  id           UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID           NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  entry_date   DATE           NOT NULL,
  title        TEXT           NOT NULL,
  body         TEXT,
  created_at   TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS notifications (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title         TEXT        NOT NULL,
  body          TEXT        NOT NULL,
  is_read       BOOLEAN     NOT NULL DEFAULT false,
  action_url    TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

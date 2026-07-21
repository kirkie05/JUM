-- ============================================================
-- Add new fields to groups and group_members
-- Create group_join_requests and group_announcements
-- ============================================================

-- Add new columns to existing groups table
ALTER TABLE groups 
  ADD COLUMN IF NOT EXISTS visibility TEXT DEFAULT 'open' CHECK (visibility IN ('open', 'private')),
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS max_members INT,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Add role to group_members
ALTER TABLE group_members
  ADD COLUMN IF NOT EXISTS role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('member', 'leader', 'admin'));

-- Create group_join_requests table
CREATE TABLE IF NOT EXISTS group_join_requests (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id    UUID        NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  user_id     UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  status      TEXT        NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ,
  UNIQUE(group_id, user_id)
);

-- Create group_announcements table
CREATE TABLE IF NOT EXISTS group_announcements (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id    UUID        NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  author_id   UUID        NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title       TEXT        NOT NULL,
  content     TEXT        NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS on new tables
ALTER TABLE group_join_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_announcements ENABLE ROW LEVEL SECURITY;

-- ── RLS for new columns/tables ────────────────────────────────

-- NOTE: existing groups RLS:
-- CREATE POLICY "Groups are viewable by everyone" ON groups FOR SELECT USING (true);
-- CREATE POLICY "Admins can manage groups" ON groups FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- Allow Group Leaders to update their own group
CREATE POLICY "Leaders can update own group" ON groups 
  FOR UPDATE USING (leader_id = auth.uid());

-- Allow Admins and Group Leaders to manage members (existing RLS: select for all, insert for self, delete for self)
CREATE POLICY "Admins and Leaders can manage members" ON group_members
  FOR ALL USING (
    is_admin() OR 
    EXISTS (SELECT 1 FROM groups WHERE id = group_members.group_id AND leader_id = auth.uid())
  );

-- RLS: Group Join Requests
CREATE POLICY "Users can view own requests" ON group_join_requests
  FOR SELECT USING (user_id = auth.uid() OR is_admin() OR EXISTS (SELECT 1 FROM groups WHERE id = group_join_requests.group_id AND leader_id = auth.uid()));

CREATE POLICY "Users can create requests" ON group_join_requests
  FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Leaders and Admins can update requests" ON group_join_requests
  FOR UPDATE USING (is_admin() OR EXISTS (SELECT 1 FROM groups WHERE id = group_join_requests.group_id AND leader_id = auth.uid()));

-- RLS: Group Announcements
CREATE POLICY "Members can view announcements" ON group_announcements
  FOR SELECT USING (
    is_admin() OR 
    EXISTS (SELECT 1 FROM group_members WHERE group_id = group_announcements.group_id AND user_id = auth.uid()) OR
    EXISTS (SELECT 1 FROM groups WHERE id = group_announcements.group_id AND leader_id = auth.uid())
  );

CREATE POLICY "Leaders and Admins can manage announcements" ON group_announcements
  FOR ALL USING (
    is_admin() OR 
    EXISTS (SELECT 1 FROM groups WHERE id = group_announcements.group_id AND leader_id = auth.uid())
  );

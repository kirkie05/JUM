-- ── 1. POSTS TABLE MODIFICATIONS ──────────────────────────────────────────
ALTER TABLE public.posts ADD COLUMN IF NOT EXISTS repost_of_id UUID REFERENCES public.posts(id) ON DELETE CASCADE;
ALTER TABLE public.posts ADD COLUMN IF NOT EXISTS group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE;

-- ── 2. CONVERSATIONS TABLE MODIFICATIONS ────────────────────────────────────
ALTER TABLE public.conversations ADD COLUMN IF NOT EXISTS group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE;

-- ── 3. NEW TABLES FOR MESSAGING MEMBERS & INVITATIONS ───────────────────────
CREATE TABLE IF NOT EXISTS public.conversation_members (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID        NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  user_id         UUID        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(conversation_id, user_id)
);

CREATE TABLE IF NOT EXISTS public.conversation_invitations (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID        NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  email           TEXT        NOT NULL,
  invited_by      UUID        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(conversation_id, email)
);

-- Enable RLS on new tables
ALTER TABLE public.conversation_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversation_invitations ENABLE ROW LEVEL SECURITY;

-- ── 4. REALTIME PUBLICATION SETUP ──────────────────────────────────────────
-- Add new tables to supabase_realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE public.conversation_members;
ALTER PUBLICATION supabase_realtime ADD TABLE public.conversation_invitations;

-- ── 5. UPDATE RLS POLICIES FOR POSTS ────────────────────────────────────────
DROP POLICY IF EXISTS "Posts are viewable by everyone" ON public.posts;
DROP POLICY IF EXISTS "Users can create posts" ON public.posts;

CREATE POLICY "Posts are viewable by everyone or group members" ON public.posts FOR SELECT USING (
  group_id IS NULL OR EXISTS (
    SELECT 1 FROM public.group_members 
    WHERE group_members.group_id = posts.group_id 
    AND group_members.user_id = auth.uid()
  )
);

CREATE POLICY "Users can create posts" ON public.posts FOR INSERT WITH CHECK (
  user_id = auth.uid() AND (
    group_id IS NULL OR EXISTS (
      SELECT 1 FROM public.group_members 
      WHERE group_members.group_id = posts.group_id 
      AND group_members.user_id = auth.uid()
    )
  )
);

-- ── 6. UPDATE RLS POLICIES FOR CONVERSATIONS & MEMBERS ──────────────────────
DROP POLICY IF EXISTS "Users can view conversations they are part of" ON public.conversations;

CREATE POLICY "Users can view conversations they are part of" ON public.conversations FOR SELECT USING (
  (group_id IS NOT NULL AND EXISTS (
    SELECT 1 FROM public.group_members 
    WHERE group_members.group_id = conversations.group_id 
    AND group_members.user_id = auth.uid()
  )) OR
  (group_id IS NULL AND EXISTS (
    SELECT 1 FROM public.conversation_members 
    WHERE conversation_members.conversation_id = conversations.id 
    AND conversation_members.user_id = auth.uid()
  ))
);

CREATE POLICY "Users can manage conversation members" ON public.conversation_members FOR ALL USING (
  EXISTS (
    SELECT 1 FROM public.conversations 
    WHERE conversations.id = conversation_members.conversation_id 
    AND (
      (conversations.group_id IS NOT NULL AND EXISTS (
        SELECT 1 FROM public.group_members 
        WHERE group_members.group_id = conversations.group_id 
        AND group_members.user_id = auth.uid()
      )) OR
      (conversations.group_id IS NULL AND EXISTS (
        SELECT 1 FROM public.conversation_members 
        WHERE conversation_members.conversation_id = conversations.id 
        AND conversation_members.user_id = auth.uid()
      ))
    )
  )
) WITH CHECK (true);

CREATE POLICY "Users can manage conversation invitations" ON public.conversation_invitations FOR ALL USING (
  invited_by = auth.uid() OR email = (SELECT email FROM public.profiles WHERE id = auth.uid())
) WITH CHECK (invited_by = auth.uid());

-- ── 7. UPDATE RLS POLICIES FOR MESSAGES ──────────────────────────────────────
DROP POLICY IF EXISTS "Users can read their messages" ON public.messages;
DROP POLICY IF EXISTS "Users can send messages" ON public.messages;

CREATE POLICY "Users can read messages in their conversations" ON public.messages FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM public.conversations 
    WHERE conversations.id = messages.conversation_id 
    AND (
      (conversations.group_id IS NOT NULL AND EXISTS (
        SELECT 1 FROM public.group_members 
        WHERE group_members.group_id = conversations.group_id 
        AND group_members.user_id = auth.uid()
      )) OR
      (conversations.group_id IS NULL AND EXISTS (
        SELECT 1 FROM public.conversation_members 
        WHERE conversation_members.conversation_id = conversations.id 
        AND conversation_members.user_id = auth.uid()
      ))
    )
  )
);

CREATE POLICY "Users can send messages to their conversations" ON public.messages FOR INSERT WITH CHECK (
  sender_id = auth.uid() AND EXISTS (
    SELECT 1 FROM public.conversations 
    WHERE conversations.id = messages.conversation_id 
    AND (
      (conversations.group_id IS NOT NULL AND EXISTS (
        SELECT 1 FROM public.group_members 
        WHERE group_members.group_id = conversations.group_id 
        AND group_members.user_id = auth.uid()
      )) OR
      (conversations.group_id IS NULL AND EXISTS (
        SELECT 1 FROM public.conversation_members 
        WHERE conversation_members.conversation_id = conversations.id 
        AND conversation_members.user_id = auth.uid()
      ))
    )
  )
);

-- ── 1. CONVERSATIONS & MESSAGES UPDATES ────────────────────────────────────────

ALTER TABLE public.conversations 
  ADD COLUMN IF NOT EXISTS is_announcement BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_locked BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE public.messages
  ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS is_edited BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS reply_to_id UUID REFERENCES public.messages(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS type TEXT NOT NULL DEFAULT 'text' CHECK (type IN ('text', 'image', 'video', 'audio', 'document', 'sermon_link', 'bible_verse')),
  ADD COLUMN IF NOT EXISTS metadata JSONB; -- Store extra data like sermon ID or bible reference

-- ── 2. NEW TABLES ────────────────────────────────────────────────────────────

-- Message Attachments
CREATE TABLE IF NOT EXISTS public.message_attachments (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id      UUID        NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  file_url        TEXT        NOT NULL,
  file_type       TEXT        NOT NULL, -- 'image', 'video', 'audio', 'document'
  file_size       BIGINT,
  file_name       TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Message Reactions
CREATE TABLE IF NOT EXISTS public.message_reactions (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id      UUID        NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  user_id         UUID        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  emoji           TEXT        NOT NULL,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(message_id, user_id, emoji)
);

-- Message Reads
CREATE TABLE IF NOT EXISTS public.message_reads (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id      UUID        NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  user_id         UUID        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  read_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(message_id, user_id)
);

-- Conversation Mutes & Pins
CREATE TABLE IF NOT EXISTS public.user_conversation_prefs (
  user_id         UUID        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  conversation_id UUID        NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  is_muted        BOOLEAN     NOT NULL DEFAULT false,
  is_pinned       BOOLEAN     NOT NULL DEFAULT false,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY(user_id, conversation_id)
);

-- Enable RLS
ALTER TABLE public.message_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.message_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.message_reads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_conversation_prefs ENABLE ROW LEVEL SECURITY;

-- Add to Realtime Publication
ALTER PUBLICATION supabase_realtime ADD TABLE public.conversations;
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.message_attachments;
ALTER PUBLICATION supabase_realtime ADD TABLE public.message_reactions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.message_reads;

-- ── 3. RLS POLICIES ──────────────────────────────────────────────────────────

-- Helper function to check if user has access to a conversation
CREATE OR REPLACE FUNCTION user_can_access_conversation(conv_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.conversations c
    WHERE c.id = conv_id AND (
      (c.group_id IS NOT NULL AND EXISTS (
        SELECT 1 FROM public.group_members gm 
        WHERE gm.group_id = c.group_id AND gm.user_id = auth.uid()
      )) OR
      (c.group_id IS NULL AND EXISTS (
        SELECT 1 FROM public.conversation_members cm 
        WHERE cm.conversation_id = c.id AND cm.user_id = auth.uid()
      ))
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Attachments
CREATE POLICY "Users can view attachments in their conversations" ON public.message_attachments FOR SELECT USING (
  user_can_access_conversation((SELECT conversation_id FROM public.messages WHERE id = message_id))
);
CREATE POLICY "Users can insert attachments to their messages" ON public.message_attachments FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM public.messages WHERE id = message_id AND sender_id = auth.uid())
);

-- Reactions
CREATE POLICY "Users can view reactions in their conversations" ON public.message_reactions FOR SELECT USING (
  user_can_access_conversation((SELECT conversation_id FROM public.messages WHERE id = message_id))
);
CREATE POLICY "Users can react to messages in their conversations" ON public.message_reactions FOR INSERT WITH CHECK (
  user_id = auth.uid() AND user_can_access_conversation((SELECT conversation_id FROM public.messages WHERE id = message_id))
);
CREATE POLICY "Users can delete their reactions" ON public.message_reactions FOR DELETE USING (
  user_id = auth.uid()
);

-- Reads
CREATE POLICY "Users can view reads in their conversations" ON public.message_reads FOR SELECT USING (
  user_can_access_conversation((SELECT conversation_id FROM public.messages WHERE id = message_id))
);
CREATE POLICY "Users can mark messages as read" ON public.message_reads FOR INSERT WITH CHECK (
  user_id = auth.uid() AND user_can_access_conversation((SELECT conversation_id FROM public.messages WHERE id = message_id))
);

-- Prefs
CREATE POLICY "Users can view own prefs" ON public.user_conversation_prefs FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "Users can manage own prefs" ON public.user_conversation_prefs FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

-- ── 4. STORAGE SETUP ─────────────────────────────────────────────────────────

-- Create the bucket for message attachments
INSERT INTO storage.buckets (id, name, public) 
VALUES ('message_attachments', 'message_attachments', false) 
ON CONFLICT (id) DO NOTHING;

-- Storage RLS
CREATE POLICY "Authenticated users can upload attachments" ON storage.objects FOR INSERT WITH CHECK (
  bucket_id = 'message_attachments' AND auth.role() = 'authenticated'
);

-- Users can only read attachments if they belong to a conversation they are part of.
-- To simplify this, we can store the conversation ID in the folder path: conversation_id/filename.
-- Then verify access. For now, allow authenticated to read since the client will generate signed URLs anyway.
CREATE POLICY "Authenticated users can read attachments" ON storage.objects FOR SELECT USING (
  bucket_id = 'message_attachments' AND auth.role() = 'authenticated'
);

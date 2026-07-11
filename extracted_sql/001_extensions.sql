-- ============================================================
-- JUM Backend Schema v2 — Single Church Edition
-- Migration 001: Extensions
-- ============================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- webhook HMAC verification
CREATE EXTENSION IF NOT EXISTS "pg_trgm";    -- trigram search on sermons/posts

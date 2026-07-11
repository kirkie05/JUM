-- ============================================================
-- JUM Backend Schema v3
-- Migration 001: Extensions
-- ============================================================

-- Removed uuid-ossp as Postgres 13+ has gen_random_uuid() natively.
CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- webhook HMAC verification
CREATE EXTENSION IF NOT EXISTS "pg_trgm";    -- trigram search on sermons/posts

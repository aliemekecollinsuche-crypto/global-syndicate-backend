-- Table: Syndicate Hierarchy and Player Ranks
CREATE TABLE IF NOT EXISTS syndicate_ranks (
  rank_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID NOT NULL,
  syndicate_id UUID NOT NULL,
  rank_tier INT2 DEFAULT 1, -- Tier 1 (Associate) to Tier 5 (Sovereign)
  rank_title VARCHAR(50) DEFAULT 'Associate',
  daily_allowance BIGINT DEFAULT 5000,
  can_withdraw_vault BOOLEAN DEFAULT FALSE,
  can_manage_members BOOLEAN DEFAULT FALSE,
  promoted_at TIMESTAMPTZ DEFAULT NOW()
);

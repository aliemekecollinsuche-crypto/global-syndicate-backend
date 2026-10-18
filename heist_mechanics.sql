-- Table: Heist Logs & Vault Raids
CREATE TABLE IF NOT EXISTS heist_logs (
  heist_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  initiator_id UUID NOT NULL,
  target_country VARCHAR(3) NOT NULL,
  target_vault_type VARCHAR(50) DEFAULT 'Regional_Outpost',
  stolen_amount BIGINT DEFAULT 0,
  raid_status VARCHAR(20) DEFAULT 'IN_PROGRESS', -- IN_PROGRESS, SUCCESS, FAILED, LOCKED_DOWN
  defcon_level INT2 DEFAULT 2,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

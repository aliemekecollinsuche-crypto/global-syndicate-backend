-- Table: Player Armory & Custom Loadouts
CREATE TABLE IF NOT EXISTS player_armory (
  weapon_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id UUID NOT NULL,
  weapon_code VARCHAR(50) NOT NULL,
  weapon_name VARCHAR(100) NOT NULL,
  category VARCHAR(50) DEFAULT 'Rifle',
  damage_rating INT2 DEFAULT 50,
  fire_rate INT2 DEFAULT 600,
  is_mounted_turret BOOLEAN DEFAULT FALSE,
  purchase_cost BIGINT DEFAULT 15000,
  acquired_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed Base Weapon Inventory
INSERT INTO player_armory (player_id, weapon_code, weapon_name, category, damage_rating, fire_rate, is_mounted_turret, purchase_cost)
VALUES 
  ('00000000-0000-0000-0000-000000000000', 'GS_TAC_9MM', 'Sovereign Suppressed Pistol', 'Sidearm', 35, 450, FALSE, 5000),
  ('00000000-0000-0000-0000-000000000000', 'GS_RIFLE_V1', 'Apex Tactical Carbine', 'Rifle', 65, 750, FALSE, 25000),
  ('00000000-0000-0000-0000-000000000000', 'GS_TURRET_EMP', 'UTN Heavy Vehicle EMP Mount', 'Vehicle Mount', 90, 150, TRUE, 120000);

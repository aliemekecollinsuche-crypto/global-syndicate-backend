-- Table: Vehicle Marketplace Catalog & Purchase Records
CREATE TABLE IF NOT EXISTS vehicle_marketplace (
  catalog_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_code VARCHAR(50) UNIQUE NOT NULL,
  model_name VARCHAR(100) NOT NULL,
  vehicle_class VARCHAR(50) DEFAULT 'Street Beast',
  base_price BIGINT NOT NULL,
  utn_boost_ready BOOLEAN DEFAULT FALSE,
  is_sovereign_exclusive BOOLEAN DEFAULT FALSE
);

-- Seed Initial Marketplace Catalog
INSERT INTO vehicle_marketplace (model_code, model_name, vehicle_class, base_price, utn_boost_ready, is_sovereign_exclusive)
VALUES 
  ('GS_BEAST_V1', 'Sovereign Ram Charger', 'Street Beast', 85000, FALSE, FALSE),
  ('GS_EXEC_V2', 'Maybach Sovereign Guard', 'Executive Escort', 250000, TRUE, FALSE),
  ('GS_HYPER_V3', 'Apex Syndicate Hypercar', 'Hyper-Propulsion', 1200000, TRUE, FALSE),
  ('GS_ARMOR_V4', 'Presidential Fortress', 'Armored Presidential', 5000000, TRUE, TRUE)
ON CONFLICT (model_code) DO NOTHING;

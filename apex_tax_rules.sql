-- Function: Distribute Sovereign Tax & UTN Cut
CREATE OR REPLACE FUNCTION deposit_apex_tax(p_route_id UUID, p_tax_amount BIGINT)
RETURNS VOID AS $$
DECLARE
    target_country VARCHAR(3);
BEGIN
    -- Get destination country from UTN route
    SELECT destination_country INTO target_country 
    FROM utn_routes 
    WHERE route_id = p_route_id;

    -- Add tax revenue to the nation's Apex Tower vault
    UPDATE apex_towers
    SET vault_revenue = vault_revenue + p_tax_amount
    WHERE country_code = target_country AND is_active = TRUE;
END;
$$ LANGUAGE plpgsql;

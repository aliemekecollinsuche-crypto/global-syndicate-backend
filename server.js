const express = require('express');
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const app = express();
app.use(express.json());

// Supabase Client Connection
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

// 1. GET: Fetch Player Vault Data
app.get('/api/vault/:playerId', async (req, res) => {
  const { playerId } = req.params;
  const { data, error } = await supabase
    .from('player_vaults')
    .select('*')
    .eq('player_id', playerId)
    .single();

  if (error) return res.status(400).json({ error: error.message });
  return res.status(200).json({ vault: data });
});

// 2. POST: Process UTN Toll Fee & Apex Tax
app.post('/api/utn/pay-toll', async (req, res) => {
  const { playerId, routeId, tollFee } = req.body;

  // Verify vault balance
  const { data: vault, error: vaultError } = await supabase
    .from('player_vaults')
    .select('cash_balance')
    .eq('player_id', playerId)
    .single();

  if (vaultError || !vault || vault.cash_balance < tollFee) {
    return res.status(403).json({ success: false, message: 'UTN Gate Locked: Insufficient Vault Funds' });
  }

  // Execute tax deposit RPC
  const { error: rpcError } = await supabase.rpc('deposit_apex_tax', {
    p_route_id: routeId,
    p_tax_amount: Math.floor(tollFee * 0.2) // 20% Sovereign Apex Cut
  });

  if (rpcError) return res.status(500).json({ error: rpcError.message });

  // Deduct toll fee from vault
  const newBalance = vault.cash_balance - tollFee;
  await supabase
    .from('player_vaults')
    .update({ cash_balance: newBalance })
    .eq('player_id', playerId);

  return res.status(200).json({ success: true, message: 'UTN Gate Unlocked', newBalance });
});

// Server Initialization
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Global Syndicate API running on port ${PORT}`);
});

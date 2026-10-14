const express = require('express');
const { createClient } = require('@supabase/supabase-js');

const app = express();
app.use(express.json());

const supabaseUrl = 'https://kplvmsqrvboghwzcsxqi.supabase.co';
const supabaseKey = 'sb_secret_-syYkJ0YIOnTpkndkj1g6Q_3ClyDooJ';

const supabase = createClient(supabaseUrl, supabaseKey);

app.get('/', (req, res) => {
  res.status(200).send('Global Syndicate Backend is Online.');
});

app.post('/api/transfer', async (req, res) => {
  const { sender_id, receiver_id, amount } = req.body;
  if (!sender_id || !receiver_id || !amount || amount <= 0) {
    return res.status(400).json({ error: 'Invalid fields' });
  }

  const tariff = amount * 0.05;
  const netAmount = amount - tariff;
  
  res.status(200).json({ success: true, netAmount });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});

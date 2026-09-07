require('dotenv').config();

const express = require('express');
const path = require('path');
const { Pool } = require('pg');

const connectionString = process.env.DATABASE_URL || 'postgresql://localhost:5432/1fi';

const pool = new Pool({
  connectionString,
  ssl: connectionString.includes('neon.tech') ? { rejectUnauthorized: true } : false
});

const app = express();
const PORT = process.env.PORT || 4000;

// Allows the Flutter app (running on its own dev-server port, or as a
// native app with no origin at all) to call this API from a different origin.
app.use('/api', (req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  next();
});

app.get('/api/products', async (req, res) => {
  console.log(`[${new Date().toISOString()}] GET /api/products`);
  try {
    const { rows } = await pool.query(
      'SELECT id, brand, name, category, icon, image, gradient_from, gradient_to, ' +
      'price, mrp, max_tenure, rating, reviews, variants, highlights ' +
      'FROM products ORDER BY sort_order'
    );
    const products = rows.map((r) => ({
      id: r.id,
      brand: r.brand,
      name: r.name,
      category: r.category,
      icon: r.icon,
      image: r.image,
      grad: [r.gradient_from, r.gradient_to],
      price: r.price,
      mrp: r.mrp,
      maxTenure: r.max_tenure,
      rating: Number(r.rating),
      reviews: r.reviews,
      variants: r.variants,
      highlights: r.highlights
    }));
    res.json(products);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to load products from the database.' });
  }
});

app.use(express.static(__dirname));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'shop-page.html'));
});

app.listen(PORT, () => {
  console.log(`1Fi Marketplace running at http://localhost:${PORT}`);
});

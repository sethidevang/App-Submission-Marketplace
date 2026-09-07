const { neon } = require('@neondatabase/serverless');

// Neon's HTTP driver, not a connection pool — each Vercel invocation is a
// short-lived, stateless function, so a traditional `pg.Pool` (built for a
// long-running process) would open a new connection per cold start and
// exhaust Neon's connection limit under any real load.
const sql = neon(process.env.DATABASE_URL);

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');

  try {
    const rows = await sql`
      SELECT id, brand, name, category, icon, image, gradient_from, gradient_to,
             price, mrp, max_tenure, rating, reviews, variants, highlights
      FROM products
      ORDER BY sort_order
    `;
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
      highlights: r.highlights,
    }));
    res.status(200).json(products);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to load products from the database.' });
  }
};

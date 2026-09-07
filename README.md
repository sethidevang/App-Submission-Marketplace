# 1Fi Marketplace

Submission for the 1Fi SDE Intern Assignment: a **1Fi Marketplace** section built into the Shop page of a Flutter app styled after the real 1Fi app, backed by a Postgres database.

**The app works out of the box** — it talks to a public API (`https://app-submission-marketplace.vercel.app/api/products`) by default, so `flutter run` on any device or platform needs no local backend setup at all.

## What's here

- **`1fi_flutter/`** — the Flutter app. Shop page with three tabs (`Top Brands`, `Nearby Stores` — intentionally blank per the assignment brief, and `1Fi Marketplace` — fully built).
- **`api/products.js`** — the Vercel serverless function (Node) that actually serves the app, using Neon's HTTP driver.
- **`server.js`** — the original Express version of the same route, for local backend development (see [Running it locally](#running-it-locally)).
- **`db/`** — `schema.sql` and `seed.sql` for the `products` table.
- **`shop-page.html`** — an earlier static-HTML prototype of the Marketplace UI, kept for reference; the Flutter app is the actual deliverable.

The database is hosted on [Neon](https://neon.tech) (serverless Postgres) and the API on [Vercel](https://vercel.com), so nothing needs to run on anyone's machine for the app to work.

## Marketplace feature checklist

- Product listing (grid, searchable, filterable by category)
- Product photos — bundled assets for the base catalog, or a network URL per variant option (e.g. iPhone color, TV size) when set on that option
- Product name, brand, rating, pricing (with MRP/discount)
- Product variants (Storage, Color, Size — chip-based selection, live price recalculation)
- EMI plans (tenure options, live monthly amount, selectable on the pay screen)
- Highlights / relevant product details
- CTA to proceed with a selected EMI plan → confirmation sheet
- Loading and error states (with retry) for the product fetch
- Share a product (photo + price + link) via the OS share sheet
- Tap a product photo to view it fullscreen (pinch to zoom)

## Architecture

```
Flutter app  --HTTPS-->  Vercel (api/products.js)  --HTTP-->  Neon Postgres
```

- **State management**: a single `AppState` (Provider/`ChangeNotifier`) holds the catalog, per-product variant/tenure selections, and search/category filters.
- **Data flow**: `ApiService.fetchProducts()` hits `/api/products`, caches the raw response to disk (`shared_preferences`), and `AppState.loadProducts()` paints instantly from that cache on launch before quietly refreshing from the network — a transient network blip doesn't blank the screen if there's cached data to fall back on. Every product/variant image is precached right after a successful fetch.
- **Images**: `ProductImage` resolves, in order — the network photo for the currently selected variant (if that option has one), then the product's base `image` (which may itself be a bundled asset filename or a URL), then a category icon as a last-resort placeholder.
- **Why two backends**: `api/products.js` (Vercel) is what the app actually talks to. It uses `@neondatabase/serverless`'s HTTP driver rather than a connection pool, because a serverless function is a new short-lived process per invocation — a `pg.Pool` built for a long-running server would open a fresh connection on every cold start and exhaust Neon's connection limit. `server.js` (Express + `pg.Pool`) is the original, kept for local iteration on backend changes before they're deployed.

## Running the app

```bash
cd 1fi_flutter
flutter pub get
flutter run
```

That's it — no environment variables, no local server, no `.env` file needed. `ApiService.baseUrl` defaults to the deployed Vercel API.

## Running it locally

Only needed if you're changing backend/database code and want to test before deploying.

### Backend (Express + Neon)

```bash
npm install
cp .env.example .env   # fill in DATABASE_URL with your Neon connection string
npm start              # http://localhost:4000
```

The `db/schema.sql` and `db/seed.sql` scripts create and populate the `products` table — run them once against your own Neon database if you're starting fresh:

```bash
psql "$DATABASE_URL" -f db/schema.sql
psql "$DATABASE_URL" -f db/seed.sql
```

### Point the Flutter app at it instead of Vercel

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000        # Android emulator
flutter run --dart-define=API_BASE_URL=http://localhost:4000       # iOS simulator / macOS / web
```

**Physical device** (real phone, not a simulator): neither `localhost` nor `10.0.2.2` reach your computer, since the phone is on its own network stack. Two options:

- **USB (Android)**: `adb reverse tcp:4000 tcp:4000`, then use `--dart-define=API_BASE_URL=http://localhost:4000`.
- **Wi-Fi (either platform)**: find your computer's LAN IP (`ipconfig getifaddr en0` on macOS) and use `--dart-define=API_BASE_URL=http://<that-ip>:4000`, making sure the phone and computer are on the same network.

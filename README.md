# 1Fi Marketplace

Submission for the 1Fi SDE Intern Assignment: a **1Fi Marketplace** section built into the Shop page of a Flutter app styled after the real 1Fi app, backed by a Postgres database.

## What's here

- **`1fi_flutter/`** — the Flutter app. Shop page with three tabs (`Top Brands`, `Nearby Stores` — intentionally blank per the assignment brief, and `1Fi Marketplace` — fully built).
- **`server.js`** — a small Express API (`GET /api/products`) that reads the catalog from Postgres.
- **`db/`** — `schema.sql` and `seed.sql` for the `products` table.
- **`shop-page.html`** — an earlier static-HTML prototype of the Marketplace UI, kept for reference; the Flutter app is the actual deliverable.

The database is hosted on [Neon](https://neon.tech) (serverless Postgres), so the API doesn't depend on a locally-running Postgres install — only the Express server itself needs to run somewhere reachable by the app (see [Running it](#running-it) below).

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
Flutter app  --HTTP-->  Express (server.js)  --SQL-->  Postgres (Neon)
```

- **State management**: a single `AppState` (Provider/`ChangeNotifier`) holds the catalog, per-product variant/tenure selections, and search/category filters.
- **Data flow**: `ApiService.fetchProducts()` hits `/api/products`, caches the raw response to disk (`shared_preferences`), and `AppState.loadProducts()` paints instantly from that cache on launch before quietly refreshing from the network — a transient network blip doesn't blank the screen if there's cached data to fall back on. Every product/variant image is precached right after a successful fetch.
- **Images**: `ProductImage` resolves, in order — the network photo for the currently selected variant (if that option has one), then the product's base `image` (which may itself be a bundled asset filename or a URL), then a category icon as a last-resort placeholder.

## Running it

### 1. Backend (Express + Neon)

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

### 2. Flutter app

```bash
cd 1fi_flutter
flutter pub get
flutter run                                            # macOS / web / iOS simulator → localhost:4000 by default
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000   # Android emulator
```

**Physical device** (real phone, not a simulator): neither `localhost` nor `10.0.2.2` reach your computer, since the phone is on its own network stack. Two options:

- **USB (Android)**: `adb reverse tcp:4000 tcp:4000`, then run with the default `localhost` base URL — the app then always launches with `--dart-define=API_BASE_URL=http://localhost:4000`.
- **Wi-Fi (either platform)**: find your computer's LAN IP (`ipconfig getifaddr en0` on macOS) and run with `--dart-define=API_BASE_URL=http://<that-ip>:4000`, making sure the phone and computer are on the same network.

## Known limitation

The Express server isn't deployed anywhere public — it needs to be running (`npm start`) on whatever machine the Flutter app's `API_BASE_URL` points at. For a from-scratch cold run (no local backend available), the app's `EmptyState` error screen with a **Retry** button will explain what's missing.

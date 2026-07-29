# Gus Foods — Ops Dashboard

Single-file dashboard (sales · scrap · stock adjustments per fridge) served on GitHub Pages, fed nightly from Odoo via Supabase.

```
Odoo (XML-RPC) → sync_ops_dashboard.py (GitHub Actions, daily 06:30 Brussels)
              → Supabase staging tables → ops_rollup matview → 3 read RPCs
              → index.html (GitHub Pages, Supabase Auth login required)
```

## Access

The page is public but shows no data without signing in. Data access requires a
Supabase Auth account **on the gusfoods.com domain** — enforced server-side in the
RPCs, not in the browser. Manage users in Supabase → Authentication → Users
(project `gus-foods-dashboard`).

## Sync

- Nightly incremental (`--days 3`, overlap-safe upserts) via `.github/workflows/sync.yml`.
- Manual run / backfill: Actions → "Odoo sync" → Run workflow (optionally set a `since` date).
- Local run: put credentials in `.env.local` (see variables in the workflow file, never commit) and
  `python3 sync_ops_dashboard.py --days 3`.

## Notes

- `product_ref` columns in Supabase are DB-generated from `product_name` — never written by the sync.
- `operation_type` is derived from Odoo locations (scrap location → Scrap; inventory-usage
  destination/source → Negative/Positive Stock Adjustment; moves into a fridge stock
  location → Delivered to).
- `get_ops_rollup` returns a JSON array (not SETOF) to avoid PostgREST's 1,000-row cap.
- The xlsx drag-and-drop import in the page still works as an offline fallback.

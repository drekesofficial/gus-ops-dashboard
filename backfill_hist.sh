#!/bin/bash
# Chunked historical backfill: 2024 + 2025 in quarters, one rollup refresh at the end.
set -euo pipefail
D="$(cd "$(dirname "$0")" && pwd)"
cd "$D/../.."   # repo root, where .env.local lives

CHUNKS=(
  "2024-01-01 2024-04-01"
  "2024-04-01 2024-07-01"
  "2024-07-01 2024-10-01"
  "2024-10-01 2025-01-01"
  "2025-01-01 2025-04-01"
  "2025-04-01 2025-07-01"
  "2025-07-01 2025-10-01"
  "2025-10-01 2026-01-01"
)

for chunk in "${CHUNKS[@]}"; do
  read -r since until <<< "$chunk"
  echo "=== CHUNK $since -> $until ==="
  python3 "$D/sync_ops_dashboard.py" --since "$since" --until "$until" --no-refresh
done

echo "=== FINAL REFRESH ==="
python3 "$D/sync_ops_dashboard.py" --days 1

#!/usr/bin/env bash
set -e
set -u
set -o pipefail

(
  cd website-node-20/analytics/
  yarn install
)
rsync -a --delete website-node-20/analytics/ qljs-analytics@c.quick-lint-js.com:bun-vs-node-node-20/

(
  cd website-bunbuns/analytics/
  bun install
)
rsync -a --delete website-bunbuns/analytics/ qljs-analytics@c.quick-lint-js.com:bun-vs-node-bunbuns/

ssh qljs-analytics@c.quick-lint-js.com '
  sed \
    -e "/db\.file/s;.*;\"db.file\": \"/home/qljs-analytics/analytics-bun-vs-node-node-20.sqlite3\",;" \
    -e "/chart\.directory/s;.*;\"chart.directory\": \"/var/www/admin.quick-lint-js.com/analytics-bun-vs-node-node-20/\",;" \
    quick-lint-js-website-analytics/config.json \
    >bun-vs-node-node-20/config.json

  sed \
    -e "/db\.file/s;.*;\"db.file\": \"/home/qljs-analytics/analytics-bun-vs-node-bunbuns.sqlite3\",;" \
    -e "/chart\.directory/s;.*;\"chart.directory\": \"/var/www/admin.quick-lint-js.com/analytics-bun-vs-node-bunbuns/\",;" \
    quick-lint-js-website-analytics/config.json \
    >bun-vs-node-bunbuns/config.json
'

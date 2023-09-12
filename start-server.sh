#!/usr/bin/env bash
set -e
set -u
set -o pipefail

here="$(dirname "${0}")"

setsid() {
    exec perl -e 'use POSIX qw(setsid); setsid(); exec @ARGV;' "${@}"
}

wait_for_server_start() {
  while ! curl --silent -o /dev/null http://localhost:9001/ ; do
    sleep 0.1
  done
}

if [ -f "${here}/server.pid" ]; then
  kill -TERM -"$(cat "${here}/server.pid")" || :
fi

if lsof -i :9001 ; then
  echo "error: server already running but not managed by us" >&2
  exit 1
fi

setsid "${@}" >"${here}/server.log" 2>&1 &
echo "${!}" >"${here}/server.pid"
wait_for_server_start

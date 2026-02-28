#!/usr/bin/env bash
set -euo pipefail

OWNER="${1:-Dhyeok}"
OUT="data/github_recent.json"
TMP="$(mktemp)"

curl -fsSL \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "https://api.github.com/users/${OWNER}/repos?sort=updated&per_page=10&type=owner" \
  | jq '[.[] | {
      name,
      html_url,
      description: (.description // "설명 없음"),
      language,
      stargazers_count,
      updated_at: (.updated_at[0:10])
    }] | sort_by(.updated_at) | reverse' > "$TMP"

mv "$TMP" "$OUT"
echo "updated ${OUT} for ${OWNER}"

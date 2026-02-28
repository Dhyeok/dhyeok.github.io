#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 3 ]; then
  echo "Usage: $0 <title-slug> <source-url> <category:AI|Infra|Tech|Culture> [tags(comma)]"
  exit 1
fi

SLUG="$1"
SOURCE_URL="$2"
CATEGORY="$3"
TAGS="${4:-ai,it-news}"
TAGS_YAML="\"${TAGS//,/\", \"}\""
DATE_KST="$(TZ=Asia/Seoul date '+%Y-%m-%dT%H:%M:%S+09:00')"
FILE_DATE="$(TZ=Asia/Seoul date '+%Y-%m-%d')"
TARGET="content/posts/${FILE_DATE}-${SLUG}.md"

case "$CATEGORY" in
  AI|Infra|Tech|Culture) ;;
  *)
    echo "Invalid category: $CATEGORY (allowed: AI, Infra, Tech, Culture)"
    exit 1
    ;;
esac

if [ -f "$TARGET" ]; then
  echo "Already exists: $TARGET"
  exit 1
fi

cat > "$TARGET" <<EOF_INNER
---
title: "${SLUG}"
date: ${DATE_KST}
created: ${DATE_KST}
draft: false
tags: [${TAGS_YAML}]
categories: ["${CATEGORY}"]
source_url: "${SOURCE_URL}"
---

## 3줄 요약
- 
- 
- 

## 핵심 포인트
1. 
2. 
3. 

## 코멘트
-

## 출처
- ${SOURCE_URL}
EOF_INNER

echo "created ${TARGET}"

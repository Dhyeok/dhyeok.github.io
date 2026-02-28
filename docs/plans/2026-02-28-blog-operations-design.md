# Blog Operations Design (hyeok.github.io)

- Date: 2026-02-28
- Owner: devbot + user
- Scope: GitHub Pages(Hugo) 블로그 운영 자동화 및 링크 기반 포스팅 프로세스

## 1) Goals

1. 사용자 입력 최소화: 링크만 전달하면 초안 생성/발행까지 빠르게 진행
2. 콘텐츠 품질 보장: 출처 기반, 과장 최소화, 핵심 인사이트 제공
3. 운영 안정성: 자동 동기화 실패 시에도 블로그 핵심 기능은 유지

## 2) Information Architecture

Top menu:
- Home
- Posts
- About
- Projects

Projects page 구성:
1. Featured Projects (수동 큐레이션)
   - Source: `content/projects/*.md`
2. Recent Repos (자동 동기화)
   - Source: `data/github_recent.json`
   - Update cadence: Daily (1/day)

Card fields:
- Common: name, summary, link, tags, updated_at
- Featured extra: role, impact
- Recent extra: stars, language

## 3) Content Operation Flow (Link-based)

1. User sends article link (AI news / IT info)
2. Agent fetches + summarizes + drafts post
3. User quick review (approve/edit)
4. Agent writes markdown to `content/posts/YYYY-MM-DD-slug.md`
5. Commit & push
6. GitHub Actions deploys to Pages

Post template (hybrid tone):
- Title
- 3-line summary
- Key points (3~5)
- 코멘트 (practical implications)
- Source link

Tone policy:
- 기본은 간결한 뉴스레터형
- 중요 이슈는 해설/인사이트 비중 강화

## 4) Data & Automation Design

### 4.1 Featured Projects (Manual)
- File location: `content/projects/*.md`
- Controlled by markdown frontmatter and body

### 4.2 Recent Repos (Automated)
- Scheduled GitHub Action (daily)
- Fetch repo metadata via GitHub API
- Normalize and write to `data/github_recent.json`
- Hugo template renders this dataset on Projects page

## 5) Reliability & Failure Handling

- Partial-failure tolerant:
  - If recent repo sync fails, Featured Projects and Posts remain fully available.
- Auto-recovery:
  - Next daily run retries naturally.
- Observability:
  - Keep workflow logs for failure root cause.

## 6) Publishing Quality Gates

Before publish:
1. title/slug collision check
2. frontmatter completeness (`date`, `created`, `tags`, `categories`, `draft`)
3. source URL validation
4. local build check (`hugo --minify`)

Editorial constraints:
- Source required
- No speculative claims without basis
- Preserve original context

## 7) Success Criteria

- 링크 전달 후 초안 생성 turnaround가 빠를 것
- Recent Repos daily sync가 안정적으로 반영될 것
- 배포 실패 시 workflow 로그로 원인 확인 가능할 것

## 8) Out of Scope (initial)

- Real-time API rendering on client
- Multi-source social auto-ingest
- Advanced recommendation/personalization

## 9) Next Step

- Create implementation plan and execute incrementally:
  1) Projects page templates
  2) Repo sync workflow + script
  3) Posting helper workflow
  4) About/README polish

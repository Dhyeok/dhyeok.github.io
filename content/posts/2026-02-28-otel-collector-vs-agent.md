---
title: "OpenTelemetry Collector vs Agent: 어떤 텔레메트리 전략이 맞을까"
date: 2026-02-28T21:03:02+09:00
created: 2026-02-28T21:03:02+09:00
draft: false
tags: ["infra", "opentelemetry", "observability", "kubernetes", "sre"]
categories: ["Infra"]
---

## 3줄 요약
- CNCF 글은 OpenTelemetry 도입 시 자주 나오는 질문인 **Collector vs Agent** 선택 기준을 명확히 정리합니다.
- 핵심 차이는 역할 범위로, Agent는 소스 근처 수집에 강하고 Collector는 중앙 집계·가공·전송에 강합니다.
- 실제 운영에서는 둘 중 하나를 고르기보다 **Agent + Collector 조합**이 성능과 확장성 균형점으로 제시됩니다.

## 핵심 포인트
1. **Collector의 역할**: 여러 서비스에서 들어오는 traces/metrics/logs를 중앙에서 수집·변환·필터링·배치 후 백엔드로 전송.
2. **Agent의 역할**: 애플리케이션 가까운 위치(sidecar/daemonset)에서 로컬 데이터를 가볍게 수집·전달.
3. **처리 능력 차이**: Collector는 샘플링·가공·라우팅 등 고급 처리에 유리, Agent는 오버헤드 최소화에 유리.
4. **확장 모델 차이**: Collector는 중앙 파이프라인 확장, Agent는 워크로드 수와 함께 자연 확장.
5. **실무 권장안**: 대규모/분산 환경일수록 Agent로 근접 수집하고 Collector에서 정책 기반 처리하는 하이브리드가 유효.

## 코멘트
실무에서 이 이슈는 “무엇이 더 좋나”보다 **어디에서 어떤 책임을 지게 할 것인가**의 문제에 가깝습니다.

- 팀이 데이터 품질 정책(샘플링, 필터링, 멀티백엔드 라우팅)을 강하게 통제해야 하면 Collector 비중을 높여야 하고,
- 서비스 단위 민첩성과 최소 오버헤드가 중요하면 Agent 배치를 먼저 가져가는 게 맞습니다.

결론적으로는 Agent와 Collector를 경쟁 개념으로 보기보다, **수집 계층과 처리 계층을 분리하는 아키텍처 패턴**으로 이해하는 것이 운영 안정성에 더 유리합니다.

## 참조
- https://www.cncf.io/blog/2026/02/02/opentelemetry-collector-vs-agent-how-to-choose-the-right-telemetry-approach/

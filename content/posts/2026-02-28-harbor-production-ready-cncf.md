---
title: "Harbor를 프로덕션 레디로 만드는 핵심 체크리스트"
date: 2026-02-28T15:41:50+09:00
created: 2026-02-28T15:41:50+09:00
draft: false
tags: ["tech", "harbor", "kubernetes", "cncf", "devops"]
categories: ["Tech"]
---

## 3줄 요약
- CNCF 글은 Harbor를 단순 설치하는 수준에서 벗어나, **실서비스 운영 기준**으로 점검해야 할 항목을 체계적으로 정리합니다.
- 핵심은 HA(고가용성), 보안, 스토리지, 모니터링, 네트워크를 Helm values 수준까지 구체적으로 설계하는 것입니다.
- 특히 내장 DB/Redis 의존을 줄이고 외부 HA 구성으로 전환하는 전략이 프로덕션 안정성의 중심으로 제시됩니다.

## 핵심 포인트
1. **HA와 확장성**: Ingress + 주요 컴포넌트 replica 확장(core/jobservice/portal/registry/trivy) + 공유 스토리지 설계가 기본.
2. **DB/Redis 외부 HA 권장**: 내장 PostgreSQL/Redis는 단일 장애점과 운영 복잡도 이슈가 있어 프로덕션에 비권장.
3. **보안 강화**: TLS/내부 TLS, LDAP/OIDC 인증 연동, Trivy 취약점 스캔, Cosign/Notation 기반 콘텐츠 신뢰 검증 강조.
4. **스토리지 운영**: 스토리지 클래스 선택, 용량 산정, 백업/복구 전략, 정기 GC(garbage collection)가 필수.
5. **관측성 확보**: Prometheus/Grafana 기반 메트릭, 중앙 로그 수집, Alertmanager 규칙으로 선제 대응 체계 구축.
6. **네트워크 현실화**: Ingress/LB + DNS, 프록시 환경 설정, 이미지 push/pull 피크 트래픽을 고려한 대역폭 계획 필요.

## 코멘트
이 글의 실무적 가치는 “Harbor 설치 가이드”가 아니라 **운영 설계 가이드**라는 점입니다.

많은 팀이 레지스트리를 빠르게 붙인 뒤, 실제 트래픽과 보안 요구사항이 커진 시점에 DB/스토리지/모니터링 병목을 맞는데, 이번 정리는 그 리스크를 초기 설계 단계에서 줄이게 해줍니다.

특히 Kubernetes 기반 사내 플랫폼에서는 Harbor를 단독 툴로 보지 말고, 인증 체계(SSO), 관측성 스택, 백업 정책, 배포 파이프라인과 함께 **플랫폼 컴포넌트**로 다루는 접근이 중요합니다.

## 참조
- https://www.cncf.io/blog/2026/02/24/making-harbor-production-ready-essential-considerations-for-deployment/

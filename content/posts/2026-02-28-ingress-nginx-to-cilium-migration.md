---
title: "ingress-nginx 아카이브 이후: Cilium으로 옮겨야 하는 이유"
date: 2026-02-28T21:06:41+09:00
created: 2026-02-28T21:06:41+09:00
draft: false
tags: ["infra", "kubernetes", "cilium", "gateway-api", "networking"]
categories: ["Infra"]
---

## 3줄 요약
- CNCF 글은 ingress-nginx 아카이브(유지보수 종료) 발표 이후, 플랫폼 팀이 선택해야 할 현실적인 마이그레이션 경로를 정리합니다.
- 단기적으로는 Cilium Ingress로 빠르게 리스크를 줄이고, 중장기적으로는 Gateway API 전환을 권장합니다.
- 핵심 메시지는 “컨트롤러 교체”를 넘어, 관측성과 보안까지 포함한 네트워크 운영 모델을 함께 현대화하라는 것입니다.

## 핵심 포인트
1. **배경 변화**: ingress-nginx는 더 이상 적극 유지보수/보안패치가 보장되지 않아 운영 리스크가 커짐.
2. **빠른 대응 경로**: Cilium Ingress는 기존 Ingress 리소스를 비교적 적은 수정으로 대체 가능한 드롭인 경로 제공.
3. **권장 장기 경로**: Kubernetes 표준 방향인 Gateway API로 가면 헤더 라우팅, 트래픽 분할, 크로스 네임스페이스 등 고급 기능 활용 가능.
4. **마이그레이션 실무 포인트**: 기존 host/path/TLS/annotation inventory → 스테이징 검증 → 사이드바이사이드 운영 → 점진 컷오버.
5. **자동화 도구 활용**: ingress2gateway 같은 변환 유틸로 대규모 리소스 전환 부담을 줄일 수 있음.

## 코멘트
이 주제는 단순히 “nginx에서 다른 ingress로 갈아탄다”가 아닙니다. 실제로는 **Ingress 중심 운영에서 Gateway API 중심 운영 체계로 전환할 타이밍**에 가깝습니다.

특히 조직이 커질수록 앱팀/플랫폼팀 책임 분리가 중요해지는데, Gateway API 모델은 그 구조를 자연스럽게 반영합니다. 여기에 Cilium의 eBPF 기반 관측성과 정책 통합이 결합되면, 트래픽 처리와 보안 운영을 각각 따로 붙이는 복잡도가 줄어듭니다.

즉, 이번 전환은 마이그레이션 비용이 아니라 **향후 2~3년 네트워크 운영비용을 낮추는 투자**로 보는 게 맞습니다.

## 참조
- https://www.cncf.io/blog/2026/01/27/navigating-the-ingress-nginx-archival-why-now-is-the-time-to-move-to-cilium/

# 📱 주식 자동매매 모바일 앱 (Stock Auto Trader)

> **2024 한이음 ICT 프로젝트** | **총장배소프트웨어대회 은상** 수상작

Flutter를 활용한 주식 투자 정보 제공 및 AI 자동매매 시스템의 모바일 앱입니다. 실시간 주식 데이터 시각화, 계좌 관리, AI 챗봇 상담 등 종합적인 투자 플랫폼을 제공합니다.

## 👥 팀원 소개

| 역할     | 이름     | 담당 업무                              | 소속 대학교                              |
| -------- | -------- | -------------------------------------- | ---------------------------------------- |
| **팀장** | [여의주] | 프로젝트 총괄,                         | [서울과학기술대학교 스마트ICT융합공학과] |
| **팀원** | [김성준] | 백엔드 개발, 모바일 앱 개발 (Flutter)  | [한국방송통신대학교 컴퓨터과학과]        |
| **팀원** | [고수민] | AI/ML 알고리즘 개발                    | [동덕여자대학교 데이터사이언스전공]      |
| **팀원** | [최민경] | UI/UX 디자인, 모바일 앱 개발 (Flutter) | [서울여자대학교 경제학과과]              |
| **멘토** | [이규영] | 프로젝트 멘토링                        | [한국과학기술원 정보보호대학원]          |

## 🎯 프로젝트 개요

본 프로젝트는 개인 투자자들을 위한 종합 주식 투자 플랫폼으로, 실시간 주식 데이터 분석과 AI 기반 자동매매 시스템을 모바일 환경에서 제공합니다. 2024년 한이음 ICT 프로젝트의 일환으로 개발되었으며, 총장배소프트웨어대회에서 은상을 수상한 작품입니다.

## 📚 프로젝트 자료

### 🎬 시연 영상

- **데모 영상**: [**주식 자동매매 앱 시연 영상**](https://www.youtube.com/watch?v=ztcIzkfpueM) 🎥 - 프로젝트 기능 시연

### 📄 논문 및 연구 자료

- **최종 논문**: [**A3C 기반 딥러닝 강화학습을 활용한 주식 자동매매 시스템 구현**](docs/papers/final/The%20Implementation%20of%20an%20Automated%20Stock%20Trading%20System%20based%20on%20A3C%20using%20Deep%20Reinforcement%20Learning.pdf) 📄 - 프로젝트 완성 논문 (PDF)
- **논문 발표 자료**: [`docs/papers/final/presentation/`](docs/papers/final/presentation/) - 논문 발표 PPT 및 학회 발표 자료

### 📊 설계서 및 문서

- **유즈케이스**: [`docs/reports/usecase/`](docs/reports/usecase/) - 시스템 유즈케이스 정의서
- **WBS**: [`docs/reports/wbs/`](docs/reports/wbs/) - 프로젝트 작업 분해 구조
- **기술 문서**: [`docs/reports/technical/`](docs/reports/technical/) - 한이음 ICT 멘토링 보고서 및 설계서
- **참고자료**: [`docs/reports/references/`](docs/reports/references/) - 프로젝트 참고 자료
  - **데이터**: [`docs/reports/references/data/`](docs/reports/references/data/) - 퀀티랩 데이터 등 참고 데이터
  - **PPT**: [`docs/reports/references/ppt/`](docs/reports/references/ppt/) - 강화학습, 시계열예측 등 학습 자료

### 📚 학습 자료

- **멘토 자료**: [`docs/study/mentor/`](docs/study/mentor/) - 멘토 제공 강화학습 자료
- **멘티 발표**: [`docs/study/mentee/`](docs/study/mentee/) - 팀원별 학습 자료

### 🖼 이미지 자료

- **앱 스크린샷**: [`docs/images/screenshots/`](docs/images/screenshots/) - 앱 실행 화면
- **다이어그램**: [`docs/images/diagrams/`](docs/images/diagrams/) - 시스템 다이어그램

## 🏆 수상 내역

- **2024 한이음 ICT 프로젝트** 참여
- **2024 한이음 ICT 프로젝트** 학술발표대회 참여(논문)
- **총장배소프트웨어대회 은상** 수상
- **시연 영상**: [YouTube 링크](https://www.youtube.com/watch?v=ztcIzkfpueM)

## 🛠 기술 스택

### Frontend

- **Flutter** - 크로스 플랫폼 모바일 앱 개발
- **Dart** - 프로그래밍 언어
- **Material Design** - UI/UX 디자인

### Backend Integration

- **Dio** - HTTP 클라이언트 (REST API 통신)
- **Cookie Management** - 세션 관리
- **CSRF Token** - 보안 인증

### Social Login

- **Google Sign-In** - 구글 소셜 로그인
- **Kakao Login** - 카카오 소셜 로그인

### Data Visualization

- **fl_chart** - 실시간 주식 차트 표시
- **charts_flutter** - 데이터 시각화

### Development Tools

- **Logger** - 디버깅 및 로그 관리
- **flutter_dotenv** - 환경 변수 관리

## 📱 주요 기능

### 1. 🔐 사용자 인증 시스템

- **다중 소셜 로그인** 지원 (Google, Kakao)
- **이메일/비밀번호** 로그인
- **CSRF 토큰** 기반 보안 인증
- **세션 관리** 및 쿠키 처리

### 2. 📊 실시간 주식 데이터 시각화

- **KOSPI/KOSDAQ** 실시간 차트 표시
- **동적 차트 렌더링** (양수/음수 구간별 색상 구분)
- **실시간 데이터 업데이트**
- **터치 인터랙션** 지원

### 3. 💰 계좌 관리 시스템

- **총 자산 현황** 조회
- **보유 주식** 상세 정보
- **현금/주식** 평가금액 분리 표시
- **손익률** 및 **자산 증감** 추적

### 4. 🤖 AI 챗봇 상담

- **실시간 AI 대화** 기능
- **주식 투자 상담** 서비스
- **CSRF 토큰** 기반 안전한 통신
- **직관적인 채팅 UI**

### 5. 📈 투자 정보 제공

- **종목 순위** 조회
- **주요 지수** 모니터링
- **관심종목/보유종목** 관리
- **투자 정보** 대시보드

### 6. 🚀 AI 자동매매 시스템 (개발 예정)

- **AI 기반 자동매매** 알고리즘
- **투자 금액** 설정 및 관리
- **수익률** 실시간 추적
- **매매 내역** 기록 및 분석

## 🏗 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점
├── home/                       # 메인 홈 화면
│   ├── home_screen.dart        # 홈 화면 (차트, 메뉴)
│   ├── Screens/               # 각종 기능 화면들
│   │   ├── account_info.dart  # 계좌 정보 모델
│   │   ├── Accounts_screen.dart # 계좌 조회
│   │   ├── chatbot_screen.dart # AI 챗봇
│   │   ├── stock_ranking_screen.dart # 종목 순위
│   │   └── ...
│   └── Config/
│       └── KOSPIKOSDAK.dart   # 주식 데이터 설정
├── login/                      # 로그인 관련
│   ├── login_screen.dart      # 로그인 화면
│   └── Button/                # 로그인 버튼들
├── signup/                     # 회원가입
├── social_sign_in/            # 소셜 로그인
│   ├── google_login_screen.dart
│   ├── kakao_login_screen.dart
│   └── naver_login_screen.dart
└── utils/                      # 유틸리티
    └── logger.dart            # 로깅 시스템
```

## 🚀 설치 및 실행

### 사전 요구사항

- Flutter SDK (3.3.4 이상)
- Dart SDK
- Android Studio / VS Code
- Android/iOS 에뮬레이터 또는 실제 기기

### 설치 방법

1. **저장소 클론**

```bash
git clone [repository-url]
cd stock_auto_trader
```

2. **의존성 설치**

```bash
flutter pub get
```

3. **환경 변수 설정**

```bash
# assets/.env 파일 생성 및 설정
API_BASE_URL=https://fintech19190301.kro.kr/
```

4. **앱 실행**

```bash
flutter run
```

## 📱 지원 플랫폼

- **Android** (API 21 이상)
- **iOS** (iOS 11.0 이상)

## 🔧 API 연동

### 백엔드 서버

- **Base URL**: `https://fintech19190301.kro.kr/`
- **주요 엔드포인트**:
  - `/api/stock_data/` - 주식 데이터 조회
  - `/api/account/status/` - 계좌 상태 조회
  - `/api/stock_auto_trading_chatbot/` - AI 챗봇
  - `/api/accounts/login/` - 사용자 로그인

### 데이터 형식

- **JSON** 기반 REST API
- **CSRF 토큰** 인증
- **쿠키** 기반 세션 관리

## 🎨 UI/UX 특징

- **Material Design** 3.0 적용
- **반응형 디자인** (다양한 화면 크기 지원)
- **직관적인 네비게이션** (Bottom Navigation + Drawer)
- **실시간 데이터 시각화** (차트, 그래프)
- **다크/라이트 테마** 지원

## 🔒 보안 기능

- **CSRF 토큰** 기반 요청 인증
- **HTTPS** 통신 암호화
- **세션 관리** 및 자동 로그아웃
- **입력 데이터 검증** 및 sanitization

## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 📞 문의

프로젝트에 대한 문의사항이나 제안사항이 있으시면 언제든지 연락주세요.

- **이메일**: kkkygsos@naver.com

---

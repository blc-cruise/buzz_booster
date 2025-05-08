## 0.0.1
* [NEW] Campaign Floating Action Button으로 사용자를 캠페인으로 유입시킬 수 있습니다.

## 0.0.2
* [NEW] Campaign Entry Point로 하위 위젯을 추가하여 사용자를 캠페인으로 유입시킬 수 있습니다.
* [FIX] Campaign Floating Action Button이 iOS에서 Fullscreen을 차지하는 문제를 해결했습니다.

## 0.0.3
* [NEW] BuzzBooster 서버로 사용자 이벤트를 전송하는 기능을 추가했습니다.
* [NEW] 사용자를 캠페인으로 유입시킬 수 있는 인앱 메시지 기능을 추가했습니다.

## 0.0.4
* [UPDATE] SDK 초기화 시 플랫폼 별 AppKey를 받도록 변경되었습니다.

## 0.1.0
* [FIX] Campaign List 페이지의 배경색 관련 UX를 개선했습니다.
* [NEW] Campaign 페이지로 이동할 수 있는 API를 추가했습니다.

## 0.1.1
* [FIX] Dart 지원 버전을 Flutter SDK 지원과 동기화합니다.

## 0.1.2
* [FIX] dart 2.17 이상에서 사용 가능한 `super`키워드를 제거합니다.

## 0.1.3
* [FIX] Android Device에서 인앱 메시지의 이미지를 가운데로 조정했습니다.
* [FIX] Android Device에서 앱 테마를 투명으로 한 앱에서 캠페인 페이지에 홈 화면이 나타나는 문제를 해결했습니다.
* [FIX] Android Device에서 일부 화면에서 출석체크 캠페인 캘린더의 글자가 전부 표현되지 않는 문제 해결했습니다.
* [NEW] Android Device에서 출석체크 외의 캠페인 참여로 리워드 지급 시 notification을 렌더링합니다.
* [FIX] iOS Device에서 캠페인 페이지의 배경이 늦게 렌더링되는 문제를 해결했습니다.
* [FIX] iOS Device에서 `showCampaign()` 메소드 호출 시 간혹 캠페인 페이지로 이동되지 않는 문제를 해결했습니다.
* [FIX] iOS Device에서 `setUserId(null)` 메소드 호출 시 크래시가 발생하는 문제를 해결했습니다.

## 0.2.0
* [NEW] Point Plugin 기능을 추가했습니다.

## 0.2.1
* [NEW] 특정 캠페인으로 이동하는 `showSpecificCampaign(CampaignType)` 메소드를 추가했습니다.
* [FIX] 인앱 메시지의 아이템을 클릭하고 캠페인을 닫을 경우, 인앱 메시지를 종료합니다.

## 0.2.2
* [FIX] Android Device의 캠페인 리스트 페이지에서 간혹 발생하는 크래시를 해결했습니다.

## 0.3.0
* [NEW] 친구초대 캠페인이 추가됐습니다.

## 1.11.0
* [NEW] 유저를 이벤트 참여 페이지로 이동시킬 수 있는 커스텀 캠페인이 추가됐습니다.
* [UPDATE] 유저 행동 분석 이벤트 처리 성능이 향상됐습니다.

## 1.11.1
* [FIX] 친구초대 버튼이 정상 동작하지 않는 문제를 해결했습니다.

## 1.11.2
* [UPDATE] 캠페인 UI/UX를 개선했습니다.
* [UPDATE] 캠페인 관련 유저 행동 분석 이벤트를 저장합니다.

## 1.11.3
* [FIX] 일부 디바이스에서 친구초대 캠페인을 로딩할 수 없는 문제를 수정했습니다.
* [FIX] 간헐적으로 발생하는 크래시를 해결했습니다.

## 1.11.4
* [NEW] 친구초대 공유 기능을 구현했습니다.
* [FIX] Android에서 친구초대 '인증' 시 키보드를 내리게 수정했습니다.
* [FIX] Android에서 포인트 플러그인을 사용 시 캠페인 리스트로 이동하게 수정했습니다.
* [UPDATE] UI/UX를 개선했습니다.

## 1.11.5
* [UPDATE] 친구초대 메시지 복사를 코드 복사로 변경했습니다.
* [FIX] 포인트 적립히스토리 시간이 맞지 않는 문제를 해결했습니다.

## 1.11.6
* [UPDATE] 지원되지 않는 신규 캠페인이 리스트에 나타났을 때, 유저가 이를 클릭했을 경우 업데이트를 안내합니다.

## 2.0.0
* [NEW] 스탬프 캠페인 추가
* [NEW] 마케팅 수신 동의 유도 추가
* [NEW] 네이버 페이 전환 플러그인 추가

## 2.0.1
* [UPDATE] Push 기능 개선
* [UPDATE] Android Targert SDK Version을 33으로 조정
* [UPDATE] iOS Deployment Target 11로 조정
* [UPDATE] 친구초대 누적 현황 UI 추가
* [FIX] Network Crash Log 제거
* [FIX] iOS에서 출석체크 리워드 지급 메시지 버튼 텍스트 오류 수정
* [FIX] Android에서 마케팅 수신 동의 스크롤이 끝까지 되지 않는 현상 수정

## 2.0.2
> * [NEW] 룰렛 캠페인 추가
> * [NEW] 후지급 결과 페이지 추가
> * [UPDATE] 구버전 캠페인이 나타날 경우 업데이트 유도
> * [FIX] iOS 커스텀 캠페인 레이아웃 경고 제거

## 2.1.0
> * [NEW] 기프티콘 기능 추가
> * [UPDATE] 캠페인 목록에서 리워드 UI/UX 개선
> * [FIX] iOS에서 일부 캠페인 진입 시 Freeze되는 문제 해결
> * [FIX] 기타 UI/UX 수정

## 2.2.0
> * [NEW] SDK에서 발생하는 유저 이벤트를 확인할 수 있는 기능 추가
> * [UPDATE] iOS에서 화면 이동 시 애니메이션 개선
> * [UPDATE] 포인트 목록 조회 페이징 처리
> * [FIX] iOS에서 image 링크가 한글일 경우 보이지 않는 문제 해결
> * [FIX] iOS 스탬프 캠페인 UI 개선
> * [FIX] iOS에서 친구초대 복사 버튼 클릭 시 Toast가 나오지 않던 문제 해결

## 2.3.0
> * [NEW] Dash에서 지정한 PageId로 이동하는 기능 추가
> * [FIX] iOS에서 로그인되지 않은 상태에서 캠페인으로 이동할 경우 안내 메시지가 나오지 않던 문제 해결
> * [FIX] Android에서 Home을 Pull to Refresh할 경우 리워드도 갱신되게 수정
> * [FIX] 간헐적으로 발생하는 InAppMessage 타이밍 이슈 해결

## 4.13.0 
> * [FIX] 안정화

## 4.22.0 
> * [NEW] BuzzBooster 초기화 상태를 확인할 수 있는 기능 추가
> * [FIX] 간헐적으로 Push가 동작하지 않는 문제 수정

## 4.22.1 
> * [FIX] iOS 빌드 문제 해결
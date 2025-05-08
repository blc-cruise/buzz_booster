# buzz_booster_example

Demonstrates how to use the buzz_booster plugin.

## Getting Started

#### precondition
- 설치된 flutter/dark 제거

#### 설치 방법
1. flutter를 삭제한다 (using `which flutter`)
2. brew로 dart를 설치한다
```bash
 brew tap dart-lang/dart
 brew install dart
```
3. fvm을 설치한다.
```
 dart pub global activate fvm
```
4. 현재 버전을 설치한다
```
fvm install 3.0.1
```
5. flutter 커맨드 사용전 항상 fvm을 붙인다
eg. `fvm flutter run`
- 이 귀찮음을 방지하려면 .bashrc에 `alias flutter="fvm flutter"`를 추가

- [참고](https://velog.io/@knh4300/fvm)
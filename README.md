# SequenceQueue

## Introduce
- SequenceQueue는 시간 순서대로 동작해야 하는 기능을 편리하게 쓰기 위한 빌더입니다.

## Usage
- SequenceQueue 인스턴스를 생성하고 BuildBlock에서 SequenceTask를 작성하세요.
그리고 Block 마지막에 run() 메서드를 호출하세요.

### Serial
```swift
SequenceQueue(serial: {
  SequenceTask(timeInterval: 0) {
    title.append("1")
  }
  SequenceTask(timeInterval: 1) {
    title.append("2")
  }
  SequenceTask(timeInterval: 1) {
    title.append("3")
  }
}).run()
```

```
Time >>
0................1.............2.........
title = 1    title = 12   title = 123
```

Serial의 경우는 앞의 Task가 끝나고 난 다음 자신이 지연될 시간을 입력합니다.
0초에 첫 번째 Task가 실행되고, 그 1초 뒤에 두 번째 Task가 실행되며, 또 1초 뒤에 세 번째 Task가 실행됩니다.

### Parallel
```swift
SequenceQueue(parallel: {
  SequenceTask(timeInterval: 1) {
    title.append("1")
  }
  SequenceTask(timeInterval: 3) {
    title.append("2")
  }
  SequenceTask(timeInterval: 2) {
    title.append("3")
  }
}).run()
```
Parallel의 경우 BuildBlock 내부의 Task가 모두 동시에 시작되며, 시작시간은 timeInterval에 입력한 대로 늦춰집니다.
```
Time >>

    1..............2............3.........
    
 title = 1    title = 13   title = 132
```
## License
SequenceQueue is available under the MIT license. See the LICENSE file for more info.


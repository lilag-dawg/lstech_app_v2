import 'dart:math';

class StreamUtility {
  static Stream<int> powerStreamTest(Duration interval, [int maxCount]) async* {
    int i = 0;
    int max = 280;
    int min = 230;
    var rdm = Random();
    while (true) {
      await Future.delayed(interval);
      yield min + rdm.nextInt(max - min);
      if (i == maxCount) break;
    }
  }

  static Stream<int> cadenceStreamTest(Duration interval,
      [int maxCount]) async* {
    int i = 0;
    int max = 90;
    int min = 80;
    var rdm = Random();
    while (true) {
      await Future.delayed(interval);
      yield min + rdm.nextInt(max - min);
      if (i == maxCount) break;
    }
  }

  static Stream<int> batteryStreamTest(Duration interval,
      [int maxCount]) async* {
    int i = 0;
    var rdm = Random().nextInt(100);
    while (true) {
      await Future.delayed(interval);
      yield rdm;
      if (i == maxCount) break;
    }
  }
}

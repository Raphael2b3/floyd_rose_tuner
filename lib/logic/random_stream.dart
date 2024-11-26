import 'dart:math';

var random = Random();
double state =0.5;
Stream<double> inputStream() async* {

  while (true) {
    state = (state + ((random.nextBool()?1:-1)*(random.nextDouble() %0.01))) % 1   ;

    await Future.delayed(const Duration(milliseconds:1));
    yield state;
  }
}
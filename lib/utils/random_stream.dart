import 'dart:math';

var random = Random();
double state =441;
Stream<double> inputStream() async* {
  while (true) {
    state = state + ((random.nextBool()?1:-1)*(random.nextDouble() %0.01));

    await Future.delayed(const Duration(milliseconds:1000));
    yield state;
  }
}
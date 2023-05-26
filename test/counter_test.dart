import 'package:first_app/counter_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Counter value should be incremented', () {

    final sut = MyCounterScreen(title: 'Demo',);
    final element = sut.createElement();
    MyCounterScreenState state = element.state as MyCounterScreenState;

    state.incrementCounter();

    expect(state.counter, 10);
  });
}

import 'dart:async';
import 'dart:ui';

class DebounceHelper {
  final int miliseconds;
  Timer? _timer;

  DebounceHelper({required this.miliseconds});

  void run(VoidCallback action) {
    if(_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: miliseconds), action);
  }
}
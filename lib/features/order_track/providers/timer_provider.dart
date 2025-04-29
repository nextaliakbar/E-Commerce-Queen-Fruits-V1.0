import 'dart:async';

import 'package:flutter/foundation.dart';

class TimerProvider extends ChangeNotifier {
  Duration? _duration;
  Timer? _timer;
  Duration? get duration => _duration;
}
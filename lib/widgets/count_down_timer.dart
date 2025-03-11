import 'dart:async';
import 'package:flutter/cupertino.dart';

class CountDownTimer extends StatefulWidget {
  final bool startTimer;
  const CountDownTimer({super.key, required this.startTimer});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Duration _duration = Duration();
  Timer? _timer;

  void _startTimer() {
    if (_timer != null) return; // Avoid starting multiple timers

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = Duration(seconds: _duration.inSeconds + 1);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _duration = Duration();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.startTimer) _startTimer();
  }

  @override
  void didUpdateWidget(covariant CountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startTimer != oldWidget.startTimer) {
      if (widget.startTimer) {
        _startTimer();
      } else {
        _stopTimer();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure cleanup
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_duration),
      style: const TextStyle(fontSize: 20),
    );
  }
}

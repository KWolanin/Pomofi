import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final int workMiliseconds;
  final int relaxMiliseconds;
  final ValueNotifier<bool> isWork;
  final ValueNotifier<bool> isRunning;
  final Color darkColor;
  final Color lightColor;

  const Counter({
    super.key,
    required this.workMiliseconds,
    required this.relaxMiliseconds,
    required this.isRunning,
    required this.isWork,
    required this.darkColor,
    required this.lightColor,
  });

  @override
  State<Counter> createState() => CounterState();
}

class CounterState extends State<Counter> {
  late int _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.isRunning.addListener(_toggleTimer);
      widget.isWork.addListener(_resetTimer);
    });
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isRunning,
      builder: (context, isRunning, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: widget.isWork,
          builder: (context, isWork, child) {
            return Text(
              _formatTime(_remainingTime),
              style: TextStyle(
                color: isWork ? widget.lightColor : widget.darkColor,
                fontSize: 130,
              ),
            );
          },
        );
      },
    );
  }

  void _updateTime() {
    _remainingTime = widget.isWork.value ? widget.workMiliseconds : widget.relaxMiliseconds;
  }

  void _toggleTimer() {
    if (widget.isRunning.value) {
      _startTimer();
    } else {
      _pauseTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        timer.cancel();
        _switchMode();
      } else {
        setState(() {
          _remainingTime -= 1000;
        });
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  Future<void> _switchMode() async {
    widget.isWork.value = !widget.isWork.value;
    _resetTimer();
    if (widget.isRunning.value) {
      _startTimer();
    }
    await playSound();
  }

  Future<void> playSound() async {
    final player = AudioPlayer();
    await player.setAsset('assets/sounds/change.mp3');
    await player.play();
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _updateTime();
    });
    if (widget.isRunning.value) {
      _startTimer();
    }
  }


  @override
  void dispose() {
    _timer?.cancel();
    widget.isRunning.removeListener(_toggleTimer);
    widget.isWork.removeListener(_resetTimer);
    super.dispose();
  }

  String _formatTime(int milliseconds) {
    int totalSeconds = milliseconds ~/ 1000;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

import 'package:flutter/material.dart';
class PomoControls extends StatelessWidget {
  final ValueNotifier<bool> isRunning;
  final ValueNotifier<bool> isWork;
  final Color darkColor;
  final Color lightColor;

  const PomoControls({
    super.key,
    required this.isRunning,
    required this.isWork,
    required this.darkColor,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isWork,
      builder: (context, work, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 50),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: work ? darkColor : lightColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: ValueListenableBuilder<bool>(
                  valueListenable: isRunning,
                  builder: (context, running, child) {
                    return Icon(
                      running ? Icons.pause : Icons.play_arrow,
                      // color: work ? darkColor : lightColor,
                      color: work ? lightColor : darkColor,

                    );
                  },
                ),
                iconSize: 80,
                onPressed: () {
                  isRunning.value = !isRunning.value;
                },
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.skip_next, color: work ? lightColor : darkColor),
        iconSize: 80,
                onPressed: () {
                  isWork.value = !isWork.value;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pomofi/pomo_controls.dart';
import 'package:pomofi/quotes.dart';
import 'package:pomofi/settings_page.dart';
import 'package:pomofi/theme_notifier.dart';
import 'package:provider/provider.dart';

import 'counter.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.title});

  final String title;
  final ValueNotifier<bool> isRunning = ValueNotifier(false);
  final ValueNotifier<bool> isWork = ValueNotifier(true);

  final Color darkColor = Color(0xFF07280C);
  final Color lightColor = Color(0xFFfae9bd);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int workMiliseconds = 60000;
  int relaxMiliseconds = 30000;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);

    return ValueListenableBuilder<bool>(
      valueListenable: widget.isWork,
      builder: (context, isWork, child) {
        Color bgColor = isWork ? theme.darkColor : theme.lightColor;
        Color textColor = isWork ? theme.lightColor : theme.darkColor;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: bgColor,
            title: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              style: TextStyle(color: widget.isWork.value ? theme.lightColor : theme.darkColor, fontSize: 20),
              child: Text(widget.title),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings, size: 50, color: widget.isWork.value ? theme.lightColor : theme.darkColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage(darkColor: theme.darkColor, lightColor: theme.lightColor)),
                  );
                },
              ),
            ],
          ),
          backgroundColor: bgColor,
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: widget.isWork.value ? theme.darkColor : theme.lightColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Counter(
                      workMiliseconds: workMiliseconds,
                      relaxMiliseconds: relaxMiliseconds,
                      isWork: widget.isWork,
                      isRunning: widget.isRunning,
                      darkColor: theme.darkColor,
                      lightColor: theme.lightColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: widget.isWork,
                      builder: (context, isWork, child) {
                        return Text(
                          isWork ? 'Time for work!' : 'Good job, relax now!',
                          style: TextStyle(color: textColor, fontSize: 40),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: PomoControls(
                      isRunning: widget.isRunning,
                      isWork: widget.isWork,
                      darkColor: theme.darkColor,
                      lightColor: theme.lightColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Quotes(
                      isWork: widget.isWork,
                      lightColor: theme.darkColor,
                      darkColor: theme.lightColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

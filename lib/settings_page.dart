import 'package:flutter/material.dart';
import 'package:pomofi/theme_notifier.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {

   final Color darkColor;
   final Color lightColor;

  final List<String> themes = [
    'forestGreen',
    'liliacGrey',
    'whitePink',
    'richBlackBlue',
    'ashNight',
    'standardGreen'
  ];

   SettingsPage({super.key, required this.darkColor, required this.lightColor});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Change theme", style: TextStyle(color: lightColor))
          , backgroundColor: darkColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: lightColor),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      backgroundColor: darkColor,
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.2,
        ),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          String themeName = themes[index];
          return GestureDetector(
            onTap: () {
              theme.changeTheme(themeName);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: lightColor, width: 1),
                      image: DecorationImage(
                        image: AssetImage('assets/themes/$themeName.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.black.withOpacity(0.0),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        themeName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      if (theme.currentTheme == themeName)
                        Icon(Icons.check, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
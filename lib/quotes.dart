import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

class Quotes extends StatefulWidget {
  final Color lightColor;
  final Color darkColor;
  final ValueNotifier<bool> isWork;

  const Quotes({
    super.key,
    required this.lightColor,
    required this.darkColor,
    required this.isWork,
  });

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  List<String> quotes = [];
  String currentQuote = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadQuotes();
    widget.isWork.addListener(_updateQuote);
  }

  Future<void> _loadQuotes() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/quotes.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<String> listOfQuotes = List<String>.from(jsonData['quotes']);
      setState(() {
        quotes = listOfQuotes;
        _updateQuote();
      });
    } catch (e) {
      setState(() {
        currentQuote = "Quote not found. Something gone wrong, but it won't stop you!";
      });
    }
  }

  void _updateQuote() {
    if (quotes.isNotEmpty) {
      setState(() {
        currentQuote = quotes[Random().nextInt(quotes.length)];
      });
    }
  }

  @override
  void dispose() {
    widget.isWork.removeListener(_updateQuote);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isWork,
      builder: (context, work, child) {
        return AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            color: work ? widget.darkColor : widget.lightColor,
            fontSize: 24,
          ),
          child: Text(currentQuote, textAlign: TextAlign.center),
        );
      },
    );
  }
}

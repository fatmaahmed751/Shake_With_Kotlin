import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShakeQuoteApp extends StatefulWidget {
  const ShakeQuoteApp({super.key});

  @override
  State<ShakeQuoteApp> createState() => _ShakeQuoteAppState();
}

class _ShakeQuoteAppState extends State<ShakeQuoteApp> {
  static const eventChannel = EventChannel('shake_channel');
  String quote = "Shake your phone to get inspired! 💡";

  final List<String> quotes = [
    "Believe you can and you're halfway there💪",
    "Stay hungry, stay foolish🔥",
    "Push yourself, because no one else will do it for you🚀",
    "Dream big. Start small. Act now🌟",
    "Don’t watch the clock; do what it does. Keep going🎯",
  ];

  StreamSubscription? _shakeSubscription;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _shakeSubscription = eventChannel.receiveBroadcastStream().listen((event) {
      if (event == "shake_detected") {
        _showRandomQuote();
      }
    });
  }

  void _showRandomQuote() async {
    await player.play(AssetSource('sounds/shake.wav'));
    setState(() {
      quote = quotes[Random().nextInt(quotes.length)];
    });
  }

  @override
  void dispose() {
    _shakeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Shake to Get a Quote",
            style: TextStyle(color: Colors.blueGrey[100]),
          ),
          backgroundColor: Colors.purple[900],
        ),
        backgroundColor: Colors.blueGrey[100],
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: SizedBox(
              width: 300,
              child: Text(
                quote,
                maxLines: 2,
                key: ValueKey(quote),
                style: TextStyle(
                  color: Colors.purple[900],
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
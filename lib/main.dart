import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(child: CreativityCircle()),
    );
  }
}

const _kCharWidth = 15.0;

class CreativityCircle extends StatefulWidget {
  const CreativityCircle({super.key});

  @override
  State<CreativityCircle> createState() => _CreativityCircleState();
}

class _CreativityCircleState extends State<CreativityCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15));
    _animationController.forward();
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            child!,
            Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationZ(_animationController.value * 2 * pi),
                child: WordCircle(
                  angle: _animationController.value * 2 * pi,
                ))
          ],
        );
      },
      child: const Text(
        "I am",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }
}

class WordCircle extends StatelessWidget {
  WordCircle({super.key, required this.angle});
  final double angle;
  final _words = <String>[
    "Thinker",
    "     ",
    "Innovator",
    "     ",
    "Developer",
    "     ",
    "Coffeeholic",
    "     ",
    "Nightowl",
    "     ",
  ];

  double _calculateRadius() {
    return _words.join('').length * (_kCharWidth + 5) / (2 * pi);
  }

  int _charCounts(int i) {
    var counter = 0;
    for (int j = 0; j < i; j++) {
      counter += _words[j].length;
    }
    return counter;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (int i = 0; i < _words.length; i++) ...[
          Transform(
            transform: Matrix4.rotationZ(
                _charCounts(i) * (2 * pi / _words.join('').length)),
            alignment: Alignment.center,
            child: CircularWord(
                charCounts: _charCounts(i),
                currentPosition: angle,
                startAngle: _charCounts(i) * (2 * pi / _words.join('').length),
                radius: _calculateRadius(),
                word: _words[i]),
          )
        ]
      ],
    );
  }
}

class CircularWord extends StatelessWidget {
  const CircularWord(
      {super.key,
      required this.currentPosition,
      required this.radius,
      required this.word,
      required this.charCounts,
      required this.startAngle});
  final double radius;
  final String word;
  final double currentPosition;
  final double startAngle;
  final int charCounts;

  double _rotationAngle(int i) {
    var angleOnCenter = (word.length * _kCharWidth) / radius;
    return i * (angleOnCenter / word.length);
  }

  TextStyle _getTextStyle(int i) {
    var tempAngle = startAngle + _rotationAngle(i) + currentPosition;
    var angle = tempAngle > 2 * pi ? (tempAngle - 2 * pi) : tempAngle;
    if ((angle > (2 * pi - pi / 4) || angle < pi / 4)) {
      return const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue);
    }
    return const TextStyle(fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (word.trim().isEmpty)
          Transform(
            transform:
                Matrix4.rotationZ(((word.length * _kCharWidth) / radius) / 2),
            alignment: Alignment.center,
            child: Container(
                height: 2 * radius,
                width: _kCharWidth * word.length,
                alignment: Alignment.bottomCenter,
                child: Icon(Icons.arrow_back)),
          )
        else
          for (int i = 0; i < word.length; i++) ...[
            Transform(
              transform: Matrix4.rotationZ(_rotationAngle(i)),
              alignment: Alignment.center,
              child: Container(
                height: 2 * radius,
                width: _kCharWidth,
                alignment: Alignment.bottomCenter,
                child: Text(
                  word[word.length - 1 - i],
                  style: _getTextStyle(i),
                ),
              ),
            )
          ]
      ],
    );
  }
}

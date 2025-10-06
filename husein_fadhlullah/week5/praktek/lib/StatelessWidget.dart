import 'package:flutter/material.dart';

void main() {
  runApp(const MyStatelessWidget());
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Stateless Widget'),
        ),
        body: const Center(
          child: Text('Hello, Stateless Widget!'),
        ),
      ),
    );
  }
}
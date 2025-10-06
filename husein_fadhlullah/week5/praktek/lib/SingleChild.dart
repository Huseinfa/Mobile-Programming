import 'package:flutter/material.dart';

void main() {
  runApp(const SingleChildExample());
}

class SingleChildExample extends StatelessWidget {
  const SingleChildExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SingleChild Example'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Text(
            'Hello, SingleChild!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

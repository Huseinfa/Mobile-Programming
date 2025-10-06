import 'package:flutter/material.dart';

void main() {
  runApp(const GantiWarnaApp());
}

class GantiWarnaApp extends StatefulWidget {
  const GantiWarnaApp({super.key});

  @override
  State<GantiWarnaApp> createState() => _GantiWarnaAppState();
}

class _GantiWarnaAppState extends State<GantiWarnaApp> {
  Color _warna = Colors.blue;

  void _gantiWarna() {
    setState(() {
      _warna = _warna == Colors.blue ? Colors.red : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ganti Warna'),
        ),
        body: Center(
          child: GestureDetector(
            onTap: _gantiWarna,
            child: Container(
              color: _warna,
              width: 200,
              height: 200,
              child: const Center(
                child: Text(
                  'Ketuk untuk ganti warna',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
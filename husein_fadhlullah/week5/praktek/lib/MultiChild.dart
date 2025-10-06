import 'package:flutter/material.dart';

void main() {
  runApp(ColumnExample());
}

class ColumnExample extends StatelessWidget{
  const ColumnExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Column Example')),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text ('Ini Baris Pertama'),
              Text ('Ini Baris Kedua'),
              Text ('Ini Baris Ketiga'),
              ElevatedButton(
                onPressed: () {},
                child: Text("Tombol"),
              )
            ],
          ),
        ),
      );
  }
}
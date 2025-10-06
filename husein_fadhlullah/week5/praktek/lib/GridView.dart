import 'package:flutter/material.dart';

class GridExample extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('GridView Example')),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(6, (index){
          return Card(
            color: Colors.blue[100],
            margin: EdgeInsets.all(8),
            child: Center(
              child: Text('Item ${index + 1}', style: TextStyle(fontSize: 20)),
            ),
          );
        }),
      ),
    );
  }
}
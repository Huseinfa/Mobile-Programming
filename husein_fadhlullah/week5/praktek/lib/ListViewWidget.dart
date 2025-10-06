import 'package:flutter/material.dart';

class ListViewWidget extends StatelessWidget {
  final List<String> items = ['Flutter', 'Dart', 'UI/UX'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ListView Example')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context,index){
          return ListTile(
            leading: Icon(Icons.code),
            title: Text(items[index]),
            onTap: () => print('Klik: ${items[index]}'),
          );
        },
      ),
    );
  }
}
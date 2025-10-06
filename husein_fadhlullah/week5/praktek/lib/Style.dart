import 'package:flutter/material.dart';

class StylingExample extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Styling and Positioning Example')),
      body: Stack(
        children:[
          Container(color: Colors.lightBlueAccent),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Text(
              'Tengah Layar',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
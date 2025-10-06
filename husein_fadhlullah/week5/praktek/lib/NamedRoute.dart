import 'package:flutter/material.dart';
void main(){
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/second': (context) => SecondPage(),
    },
  ));
}

class HomePage extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Named Route Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/second'),
          child: Text('Ke Halaman Kedua'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Named Route Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/second'),
          child: Text('Ke Halaman Kedua'),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:praktek/SingleChild.dart';

void main(){
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomePage()),
      GoRoute(path: '/about', builder: (context, state) => AboutPage()),
      GoRoute(path: '/singlechild', builder: (context, state) => SingleChildExample())
    ],
  );

  runApp(MaterialApp.router(
    routerConfig: router,
  ));
}

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Router Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/about'),
              child: Text('Ke Halaman About'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/singlechild'),
              child: Text('Ke Halaman SingleChild'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('About Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: Text('Ke Halaman Home'),
        ),
      ),
    );
  }
}

class button extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Button')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/singlechild'),
          child: Text('Ke Halaman SingleChild'),
        ),
      ),
    );
  }
}
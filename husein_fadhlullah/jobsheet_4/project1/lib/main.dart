import 'package:flutter/material.dart';

void main() {
  runApp(const Percobaan1());

}

  class Percobaan1 extends StatelessWidget {
    const Percobaan1({super.key});

    @override 
    Widget build(BuildContext context) {
      return MaterialApp(
        title: "Husein Fadhlullah",
        home: Scaffold(
          appBar: AppBar(
            title: Text("Husein Fadhlullah", 
                                      style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      ) 
            ),
            centerTitle: true,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
          ),
          body: Container(
            color: Colors.grey,
            alignment: Alignment.center,
            child: Column(
              children: [
                  Text("\nCicak-Cicak Di Dinding\nCiptaan : A.T Mahmud\n\n", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Cicak-cicak di dinding \nDiam-diam merayap \nDatang seekor nyamuk\nHap...lalu ditangkap\n"),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text("Cicak-cicak di dinding \nDiam-diam merayap \nDatang seekor nyamuk",),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text("Hap...lalu ditangkap\n", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.orange),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            )
            ),
          );
    }
  }

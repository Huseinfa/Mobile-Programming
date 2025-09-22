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
            title: Text("Percobaan 1", 
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
          body: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                  Text("Cicak-Cicak Di Dinding\nCiptaan : A.T Mahmud", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),

                      Column(
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
                            child: Text("Hap...lalu ditangkap\n", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
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
                            child: Text("Hap...lalu ditangkap\n", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
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
                            child: Text("Hap...lalu ditangkap\n", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),


                        ],
                      ),
                    ],
                  ),
            )
            ),
          );
    }
  }

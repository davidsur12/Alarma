import 'package:flutter/material.dart';
import 'package:alarma/screen/home.dart';
import 'package:alarma/widgets/bottonNav.dart';


/*
paleta de colores 
#081B3D
#477BD6
#20478A
#3D2A02
#8A6820
 */
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      color: Colors.black,

      home: Scaffold(
        backgroundColor: Colors.white,
        
        appBar: AppBar(title: Text("Alarma melo"),),
        body: ButtonNav() //SingleChildScrollView(child: home(),),
      ),
    );
  }
}

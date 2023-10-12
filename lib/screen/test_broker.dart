import 'package:flutter/material.dart';
import 'package:alarma/mqtt/cliente.dart';
import 'package:alarma/screen/config.dart';
import 'package:alarma/screen/topicos.dart';

class TextCliente extends StatefulWidget {
  const TextCliente({super.key});

  @override
  State<TextCliente> createState() => _TextClienteState();
}

class _TextClienteState extends State<TextCliente> {



  var mqtt= MqttCliente();
var conectado=false;
  @override
  void initState() {

mqtt.pong().listen((event) { 
  print("88888888888888888888888888   $event");
});

    mqtt.connectBroker();
    // TODO: implement initState

   mqtt.EstadoConection().listen((event) { 

    setState(() {
      conectado=event;
      print("*********************estado " + event.toString());
    });
   });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return txt();
  }
  
Widget textCliente(){
    if(conectado){
return Text("Conectado");

//muetro la pantalla para configurar los topicos
    }
    else{
return Text("No Conectado");
//muestro la pantalla para poder configurar el host y el puerto
    }
  }

  Widget txt(){

    return StreamBuilder(stream: mqtt.streamc.stream, builder: (context, snapshot) {
      if(snapshot.hasData != null){
        if((snapshot.data )== 1){
return Topicos(mqtt);//Text(snapshot.data.toString() + "   true");
        }else{

           return   Config(mqtt); //(snapshot.data.toString() + "   else");
        }
        
      }else{
          return Text(snapshot.hasData.toString() + "  sin datos");
      }
    },);
  }
}

import 'package:flutter/material.dart';
import 'package:alarma/mqtt/cliente.dart';
import 'package:mqtt_client/mqtt_client.dart';
class Topicos extends StatefulWidget {

  final  MqttCliente cliente;
  const Topicos(this.cliente);

  @override
  State<Topicos> createState() => _TopicosState();
}

class _TopicosState extends State<Topicos> {
  
  final controllerSuscriptor= TextEditingController();
  final controllerMensaje= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return suscriptor();
  }

  Widget suscriptor(){

return Column(children: [Text("ingresa el suscriptor"),
txtField(controllerSuscriptor , "Suscriptor"),
txtField(controllerMensaje , "Mensaje") ,
ElevatedButton(onPressed: (){

  widget.cliente.enviarInfo(controllerSuscriptor, controllerMensaje);
}, child: Text("Enviar")) 
],);


  }
  Widget txtField(TextEditingController controlador , String txt) {
    return  TextField(
      controller: controlador,
      decoration:  InputDecoration(
        border: const OutlineInputBorder(),
        labelText: txt,
      ),
      cursorColor: Colors.green,
    );
  }
}

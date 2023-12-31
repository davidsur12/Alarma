import 'package:flutter/material.dart';
import 'package:alarma/mqtt/cliente.dart';

class Config extends StatefulWidget {
  
   final  MqttCliente cliente;
   const Config( this.cliente);

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {



  final host= TextEditingController();
  final puerto= TextEditingController();

  @override
  Widget build(BuildContext context) {


    return Scaffold(body: configMqtt(),);
  }
  //{}
  Widget configMqtt(){
    var width =MediaQuery.of(context).size.width;
    return  Column(


        children: [
          SizedBox(height: 10.0,),
          Center(child:   Text("Configuracion alarmamelo")),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            Container(
              width: width/2.5,
              child: txtField(host , "Host"),),
              SizedBox(width: 10.0,),
            Container(
              width:width/2.5,
              child: txtField(puerto , "Puerto"),)



          ],),
          ElevatedButton(onPressed: (){

if(host.text != null  &&  host.text.toString().length>0 && puerto.text != null  &&  puerto.text.toString().length>0 ){
widget.cliente.host=host.text;
            widget.cliente.puerto=int.parse(puerto.text);
            print("hosttttt   "  + widget.cliente.host);
            print("puertooooooo     "   +   widget.cliente.puerto.toString());

}
            
            
            
            widget.cliente.connectBroker();
          }, child: Text("Conectar"))


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

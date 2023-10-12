import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:alarma/mqtt/cliente.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:text_area/text_area.dart';
class Topicos extends StatefulWidget {

  final  MqttCliente cliente;
  const Topicos(this.cliente);

  @override
  State<Topicos> createState() => _TopicosState();
}

class _TopicosState extends State<Topicos> {
  late FToast fToast;
  final controllerSuscriptor= TextEditingController();
  final controllerMensaje= TextEditingController();
  final controllerTopico= TextEditingController();
  final controllerTxtbox= TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: suscriptor(),);
  }

  Widget suscriptor(){

return Column(children: [
  SizedBox(height: 15,),
  Text("ingresa el suscriptor"),
txtField(controllerSuscriptor , "Suscriptor"),
SizedBox(height: 15,),
txtField(controllerMensaje , "Mensaje") ,
ElevatedButton(onPressed: () async {
  if(  await widget.cliente.enviarInfo(controllerSuscriptor.text.toString(), controllerMensaje.text.toString())){
    print("topico" +controllerSuscriptor.text);
    toast("Msg enviado");
  }else{
    print("topico  no enviado" );
    toast("Msg no enviado");
  }



}, child: Container(

    width:MediaQuery.of(context).size.width/2,
  child: Center(child: Text("Enviar"),),)) ,
linea(),
topico(),
  SizedBox(height: 15,),
  linea(),
  ElevatedButton(onPressed: (){
    widget.cliente.disconnect();

  }, child: Container(
    width:MediaQuery.of(context).size.width/2,
    child: Center(child:Text("Desconectar de broker"),),)),
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
  Widget topico(){

    return Column(

      children: [
      Center(child:Text("Agregar un topico")),
      SizedBox(height: 15,),
      txtField(controllerTopico, "Topico"),
        SizedBox(height: 15,),


    StreamBuilder(stream: widget.cliente.subdscritorController.stream , builder: (context, snapshot) {


      if(snapshot.hasData != null){

        //controllerTopico.text=snapshot.data.toString();
        print("el mensaje es " + snapshot.data.toString());
        controllerTxtbox.text=snapshot.data.toString();
      }
      return Container(
        color: Colors.green,

        width:MediaQuery.of(context).size.width/1.5,
        child:
        TextArea(
          borderRadius: 10,
          borderColor: Colors.green,
          textEditingController: controllerTxtbox,
          suffixIcon: Icons.attach_file_rounded,
          onSuffixIconPressed: () => {},
          validation: true,
          errorText: 'Error en Textarea',
        ),);
    },),

        ElevatedButton(onPressed: (){

          widget.cliente.suscribctor(controllerTopico.text.toString());


        }, child: Container(

          width:MediaQuery.of(context).size.width/2,
    child: Center(child: Text("Suscribirse al un topico "),),))

    ],);

  }
Widget linea(){

    return Container(color: Colors.green,child: SizedBox( width:MediaQuery.of(context).size.width , height: 5),);
}
  toast(String msg){
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(msg),
        ],
      ),
    );


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );




  }
}

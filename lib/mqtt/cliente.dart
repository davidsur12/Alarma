import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


/*
con
ws://broker.emqx.io
cliente: mqttx_160c815e
puerto: 8083
path: /mqtt
*/
class MqttCliente extends ChangeNotifier{

//final client = MqttServerClient('broker.emqx.io', '');
late  MqttServerClient cliente;
var pongCount = 0;
String _url="127.0.0.1";
int _puerto=1883;
String _idAlarma="mqttx_160c815ee";
String _topico="";


Future<Object> connectBroker() async{

cliente=MqttServerClient.withPort(_url, _idAlarma, _puerto);//parametros de coneccion con el brokker
cliente.logging(on: true);// configuro el loggeo
cliente.setProtocolV311();// configuro la version del protocolo

try{
  //me conecto al broker
await cliente.connect();
print("conectado");
}catch(e){
  //error no se conecto al broker
  print("______________________Error___________");
  print("error $e");
  cliente.disconnect();
  
}
return 0;

}
enviarInfo(var info ){

if(cliente.connectionStatus?.state == MqttConnectionState.connected ){

print("--------------------------Conectado----------------------");
//publicarMessage("casa", "{tem:17}");

final builder = MqttClientPayloadBuilder();//preparo el mensaje
builder.addString(info.toString());
  
 if (cliente.connectionStatus?.state == MqttConnectionState.connected) {
  
  //verifico si el cliente esta conectado con el broker
cliente.publishMessage(_topico, MqttQos.atMostOnce, builder.payload!);

print("--------------------------mensaje enviado-------------------");
  
    
  }

}
else{
print("**************** No conectado *******************");
cliente.disconnect();
exit(-1);

}
}
suscribctor(){


    cliente.subscribe(_topico, MqttQos.atMostOnce); //seleciono el topico

    cliente.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      //data.value = pt;
      print(
          'MQTT_LOGS:: New data arrived: topic is <${c[0].topic}>, payload is $pt');
      print('');
    });
}


}

/*
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


/*
con
ws://broker.emqx.io
cliente: mqttx_160c815e
puerto: 8083
path: /mqtt
*/
class MqttCliente {


late  MqttServerClient cliente;
var pongCount = 0;

 Future<Object> connect() async{

cliente=MqttServerClient.withPort("127.0.0.1", "mqttx_160c815ee", 1883);
cliente.logging(on: true);
cliente.setProtocolV311();

 final connMessage = MqttConnectMessage()
        .withWillTopic('salida01')
        .withWillMessage('este es un mensaje')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
         cliente.connectionMessage = connMessage;
try{
await cliente.connect();

}catch(e){
  print("______________________Error___________");
  print("error $e");
  cliente.disconnect();
}

if(cliente.connectionStatus?.state == MqttConnectionState.connected ){

print("--------------------------Conectado----------------------");
publicarMessage("casa", "{tem:17}");
//suscribctor();
}
else{
print("**************** No conectado *******************");
cliente.disconnect();
exit(-1);

}
return 0;
}


publicarMessage(String topic, String msg){

   


 final builder = MqttClientPayloadBuilder();
  builder.addString(msg);
  
 if (cliente.connectionStatus?.state == MqttConnectionState.connected) {
  
cliente.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);

print("--------------------------mensaje enviado-------------------");
  
    
  }

}

suscribctor(){

   //print('MQTT_LOGS::Subscribing to the test/lol topic');
    const topic = 'Entrada/01';
    cliente.subscribe(topic, MqttQos.atMostOnce);

    cliente.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      //data.value = pt;
      print(
          'MQTT_LOGS:: New data arrived: topic is <${c[0].topic}>, payload is $pt');
      print('');
    });
}

}
*/
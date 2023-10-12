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

//final client = MqttServerClient('broker.emqx.io', '');

var pongCount = 0;
StreamController<int> streamc= StreamController();

//broker
 String _host="broker.emqx.io";
int _puerto=1883;//puerto tcp
String _idAlarma="mqttx_160c815ee";
String _topico="prueba";
late MqttServerClient cliente; //= MqttServerClient.withPort(host, _idAlarma, _puerto);
  var strController = StreamController<int>();
int con=0;

Future<int> connectBroker() async{


try{

    //configuro el cliente
    cliente=MqttServerClient.withPort(_host, _idAlarma, _puerto);
    //cliente=MqttServerClient.withPort("127.0.0.1", "mqttx_160c815", 1883);//parametros de coneccion con el brokker
    cliente.logging(on: true);// configuro el loggeo
    cliente.setProtocolV311();// configuro la version del protocolo

    cliente.keepAlivePeriod = 10; 
    
    cliente.onConnected = onConnected;
    cliente.onDisconnected = onDisconnected;
    cliente.onSubscribed = onSubscribed;
    cliente.pongCallback = pong;


}catch(e){print("error  en configuracion $e");
return 0;
}


final connMess = MqttConnectMessage()
    .withClientIdentifier('Mqtt_MyClientUniqueId')
    .withWillTopic('prueba') // If you set this you must set a will message
    .withWillMessage('My Will message')
    .startClean() // Non persistent session for testing
    .withWillQos(MqttQos.atLeastOnce);
print('EXAMPLE::Mosquitto client connecting....');
cliente.connectionMessage = connMess;

try{
  //me conecto al broker
  await  cliente.connect().then((value) => print("conectadooooooooooooooo"));

print("conectado");
}on NoConnectionException catch (e) {
      print('MQTTClient::Client exception - $e');
      cliente.disconnect();
      return 0;
    } on SocketException catch (e) {
      print('MQTTClient::Socket exception - $e');
      cliente.disconnect();
      return 0;
    }

if(cliente.connectionStatus?.state == MqttConnectionState.connected ){

  print("--------------------------------Cliente conectado");
  streamc.add(1);
  //enviarInfo("tem:15");
  //suscribctor();
//return 1;
strController.add(1);
return 1;
}else{
  print("------------------------------Cilente no conectado");
 // return 0;
  strController.add(0);
  return 0;
}

//return 0;

 

}

Stream<bool> EstadoConection()async*{


if(cliente.connectionStatus?.state == MqttConnectionState.connected ){

  print("--------------------------------Cliente conectado");
  //enviarInfo("tem:15");
  //suscribctor();
//return 1;
//strController.add(1);
yield true;
//return true;
}else{
  print("------------------------------Cilente no conectado");
 // return 0;
  //strController.add(0);
  //return false;
  yield false;
}




}

enviarInfo(var topico,var info ){

if(cliente.connectionStatus?.state == MqttConnectionState.connected ){

final builder = MqttClientPayloadBuilder();//preparo el mensaje
builder.addString(info.toString());
  

  
  //verifico si el cliente esta conectado con el broker
cliente.publishMessage(topico, MqttQos.atMostOnce, builder.payload!);

print("--------------------------mensaje enviado-------------------");
  
    
  

}
else{
print("**************** Broker no conectado *******************");
cliente.disconnect();
//exit(-1);

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
          'date------------- <${c[0].topic}>, payload is $pt');
      print('');
    });
}

void disconnect(){
    cliente.disconnect();
  }

  void subscribe(String topic) {
    cliente.subscribe(topic, MqttQos.atLeastOnce);
  }

  Stream<bool> onConnected() async*{
    print('MQTTClient::Connected');
    yield true;
    streamc.add(1);
  }

  void onDisconnected() {
    print('MQTTClient::Disconnected');
    streamc.add(0);
  }

  void onSubscribed(String topic) {
    print('MQTTClient::Subscribed to topic: $topic');
  }

  Stream<int> pong() async*{
    print('MQTTClient::Ping response received');
print("cont $con");
    yield con++;
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
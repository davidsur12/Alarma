import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

/*
con
ws://broker.emqx.io
cliente: mqttx_160c815e
puerto: 8083
path: /mqtt
*/
class MqttClienteWeb {

//final client = MqttServerClient('broker.emqx.io', '');
late  MqttBrowserClient cliente;
var pongCount = 0;
String _url="ws://broker.emqx.io";
//String _url="ws://127.0.0.1";
int _puerto=8083;//1883 8083
String _idAlarma="mqttx_925a411dd121";
String _topico="testtopic/planta";


Future<int> connectBroker() async{
 cliente = MqttBrowserClient(_url, _idAlarma, );

//try{
    
    cliente.port = _puerto;
   // cliente.withClientIdentifier("dsjdsjddsad");
    cliente.logging(on: false);
    cliente.setProtocolV311();// configuro la version del protocolo
    cliente.keepAlivePeriod = 20;
    cliente.onConnected = onConnected;
    cliente.onDisconnected = onDisconnected;
    cliente.onSubscribed = onSubscribed;
    cliente.pongCallback = pong;
    print("cliente log");

/*
cliente.logging(on: true);
cliente.setProtocolV311();// configuro la version del protocolo
cliente.keepAlivePeriod = 20;
cliente.connectTimeoutPeriod = 2000;
*/

cliente.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
   //cliente.websocketProtocols = ['mqtt'];

   
/*
}catch(e){
  
  print("error en la configuracion $e");
  return -1;
  }

  */
  final connMess = MqttConnectMessage()
      .withClientIdentifier('Mqtt_MyClientUniqueId')
      .withWillTopic('willtopic') // If you set this you must set a will message
      .withWillMessage('My Will message')
      .startClean() // Non persistent session for testing
      .withWillQos(MqttQos.atLeastOnce);
  print('Conectando.....');
  cliente.connectionMessage = connMess;

//----------------------------------

try {
    await cliente.connect();
  } on Exception catch (e) {
    print('error en  la coneccion $e');
    cliente.disconnect();
    return -1;
  }
 /*try {
    await cliente.connect();


    
  } on Exception catch (e) {
    print(' error en coneccion = $e');
    cliente.disconnect();
    return -1;
  }
  */


  if (cliente.connectionStatus!.state == MqttConnectionState.connected) {
    print('Conectado');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    print(
        'No conectado');
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

void disconnect(){
    cliente.disconnect();
  }

  void subscribe(String topic) {
    cliente.subscribe(topic, MqttQos.atLeastOnce);
  }

  void onConnected() {
    print('MQTTClient::Connected');
  }

  void onDisconnected() {
    print('MQTTClient::Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTTClient::Subscribed to topic: $topic');
  }

  void pong() {
    print('MQTTClient::Ping response received');
  }
}

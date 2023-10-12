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
late StreamController<int> streamc = new StreamController();//= StreamController.broadcast();
  late StreamController<String> subdscritorController; // 
//broker
 //String host="broker.emqx.io";
  String host="140.238.178.88";
int puerto=1883;//puerto tcp
String idAlarma="mqttx_160c815eegh";
String _topico="prueba";
late MqttServerClient cliente; //= MqttServerClient.withPort(host, _idAlarma, _puerto);
  var strController = StreamController<int>();

int con=0;

Future<int> connectBroker() async{


try{

    //configuro el cliente
  print("host22222  "  + host);
  print("puerto22222  $puerto" );
    cliente=MqttServerClient(host,  "");
    //cliente=MqttServerClient.withPort("127.0.0.1", "mqttx_160c815", 1883);//parametros de coneccion con el brokker
    //cliente.logging(on: true);// configuro el loggeo
    cliente.setProtocolV311();// configuro la version del protocolo

    cliente.keepAlivePeriod = 20;
    cliente.port=puerto;
    cliente.onConnected = onConnected;
    cliente.onDisconnected = onDisconnected;
    cliente.onSubscribed = onSubscribed;
    cliente.pongCallback = pong;


}catch(e){print("error  en configuracion $e");
return 0;
}

/*
final connMess = MqttConnectMessage()
    .withClientIdentifier('Mqtt_MyClientUniqueId')
    .withWillTopic('prueba') // If you set this you must set a will message
    .withWillMessage('My Will message')
    .startClean() // Non persistent session for testing
    .withWillQos(MqttQos.atLeastOnce);
print('EXAMPLE::Mosquitto client connecting....');
cliente.connectionMessage = connMess;
*/
try{
  
  //me conecto al broker
  await  cliente.connect().then((value) => print("conectadooooooooooooooo"));
subdscritorController = StreamController<String>();
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

Future<bool> enviarInfo(var topico,var info )async{



if(cliente.connectionStatus?.state == MqttConnectionState.connected ){

final builder = MqttClientPayloadBuilder();//preparo el mensaje
builder.addString(info.toString());
  

  
  //verifico si el cliente esta conectado con el broker
try{

  cliente.publishMessage(topico, MqttQos.atMostOnce, builder.payload!) ;
  print("--------------------------mensaje enviado-------------------");
  return true;
}catch(e){
  return false;
}
  
    
  

}
else{
  return false;
print("**************** Broker no conectado *******************");
cliente.disconnect();
//exit(-1);

}
}

 suscribctor(String topico)  {


    cliente.subscribe(topico, MqttQos.atMostOnce); //seleciono el topico

    cliente.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      subdscritorController.add( MqttPublishPayload.bytesToStringAsString(recMess.payload.message));

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
    print("mensaje enviado---------------------------");
  }

  Stream<bool> onConnected() async*{
    print('MQTTClient::Connected');
    yield true;
    streamc.add(1);
  }

  void onDisconnected() {
    print('MQTTClient::Disconnected');
    if (cliente != null && cliente.connectionStatus?.state== MqttConnectionState.connected) {
      cliente.disconnect();
       streamc.close();
       subdscritorController.close;
      print('Cliente MQTT desconectado.');
    }
    streamc.add(0);
  }

  void onSubscribed(String topic) {
    print('MQTTClient::Subscribed to topic: $topic');
    print("mensaje enviado---------------------------");
  }

  Stream<int> pong() async*{
    print('MQTTClient::Ping response received');
print("cont $con");
    yield con++;
  }
}
/*
/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 31/05/2017
 * Copyright :  S.Hamblett
 */

import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

/// An annotated simple subscribe/publish usage example for mqtt_server_client. Please read in with reference
/// to the MQTT specification. The example is runnable, also refer to test/mqtt_client_broker_test...dart
/// files for separate subscribe/publish tests.

/// First create a client, the client is constructed with a broker name, client identifier
/// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
/// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
/// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
/// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
/// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
/// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
/// of 1883 is used.
/// If you want to use websockets rather than TCP see below.

final client = MqttServerClient('test.mosquitto.org', '');

var pongCount = 0; // Pong counter

Future<int> main() async {
  /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
  /// for details.
  /// To use websockets add the following lines -:
  /// client.useWebSocket = true;
  /// client.port = 80;  ( or whatever your WS port is)
  /// There is also an alternate websocket implementation for specialist use, see useAlternateWebSocketImplementation
  /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.
  /// You can also supply your own websocket protocol list or disable this feature using the websocketProtocols
  /// setter, read the API docs for further details here, the vast majority of brokers will support the client default
  /// list so in most cases you can ignore this.

  /// Set logging on if needed, defaults to off
  client.logging(on: true);

  /// Set the correct MQTT protocol for mosquito
  client.setProtocolV311();

  /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
  client.keepAlivePeriod = 20;

  /// The connection timeout period can be set if needed, the default is 5 seconds.
  client.connectTimeoutPeriod = 2000; // milliseconds

  /// Add the unsolicited disconnection callback
  client.onDisconnected = onDisconnected;

  /// Add the successful connection callback
  client.onConnected = onConnected;

  /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
  /// You can add these before connection or change them dynamically after connection if
  /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
  /// can fail either because you have tried to subscribe to an invalid topic or the broker
  /// rejects the subscribe request.
  client.onSubscribed = onSubscribed;

  /// Set a ping received callback if needed, called whenever a ping response(pong) is received
  /// from the broker.
  client.pongCallback = pong;

  /// Create a connection message to use or use the default one. The default one sets the
  /// client identifier, any supplied username/password and clean session,
  /// an example of a specific one below.
  final connMess = MqttConnectMessage()
      .withClientIdentifier('Mqtt_MyClientUniqueId')
      .withWillTopic('willtopic') // If you set this you must set a will message
      .withWillMessage('My Will message')
      .startClean() // Non persistent session for testing
      .withWillQos(MqttQos.atLeastOnce);
  print('EXAMPLE::Mosquitto client connecting....');
  client.connectionMessage = connMess;

  /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
  /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
  /// never send malformed messages.
  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    // Raised by the client when connection fails.
    print('EXAMPLE::client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    print('EXAMPLE::socket exception - $e');
    client.disconnect();
  }

  /// Check we are connected
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('EXAMPLE::Mosquitto client connected');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    print(
        'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  /// Ok, lets try a subscription
  print('EXAMPLE::Subscribing to the test/lol topic');
  const topic = 'test/lol'; // Not a wildcard topic
  client.subscribe(topic, MqttQos.atMostOnce);

  /// The client has a change notifier object(see the Observable class) which we then listen to to get
  /// notifications of published updates to each subscribed topic.
  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print(
        'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
  });

  /// If needed you can listen for published messages that have completed the publishing
  /// handshake which is Qos dependant. Any message received on this stream has completed its
  /// publishing handshake with the broker.
  client.published!.listen((MqttPublishMessage message) {
    print(
        'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
  });

  /// Lets publish to our topic
  /// Use the payload builder rather than a raw buffer
  /// Our known topic to publish to
  const pubTopic = 'Dart/Mqtt_client/testtopic';
  final builder = MqttClientPayloadBuilder();
  builder.addString('Hello from mqtt_client');

  /// Subscribe to it
  print('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
  client.subscribe(pubTopic, MqttQos.exactlyOnce);

  /// Publish it
  print('EXAMPLE::Publishing our topic');
  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

  /// Ok, we will now sleep a while, in this gap you will see ping request/response
  /// messages being exchanged by the keep alive mechanism.
  print('EXAMPLE::Sleeping....');
  await MqttUtilities.asyncSleep(60);

  /// Finally, unsubscribe and exit gracefully
  print('EXAMPLE::Unsubscribing');
  client.unsubscribe(topic);

  /// Wait for the unsubscribe message from the broker if you wish.
  await MqttUtilities.asyncSleep(2);
  print('EXAMPLE::Disconnecting');
  client.disconnect();
  print('EXAMPLE::Exiting normally');
  return 0;
}

/// The subscribed callback
void onSubscribed(String topic) {
  print('EXAMPLE::Subscription confirmed for topic $topic');
}

/// The unsolicited disconnect callback
void onDisconnected() {
  print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
  } else {
    print(
        'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    exit(-1);
  }
  if (pongCount == 3) {
    print('EXAMPLE:: Pong count is correct');
  } else {
    print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
  }
}

/// The successful connect callback
void onConnected() {
  print(
      'EXAMPLE::OnConnected client callback - Client connection was successful');
}

/// Pong callback
void pong() {
  print('EXAMPLE::Ping response client callback invoked');
  pongCount++;
}
*/
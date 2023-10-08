import 'package:alarma/mqtt/cliente.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}
/*
mejorar el codigo para que tenga una funcion que agregre las filas con las opciones correspondientes las 
opciones o btones estaran en una lista que contendra otra lista que  contendra todos los datos
 */

class _homeState extends State<home> {
  double espcaio = 15.0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [
      //SizedBox(height: 30,),//espacio
      Center(child: alarma()), //alarma principal
      SizedBox(
        height: espcaio,
      ), //espacio
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          alarmaGenerica(
              "assets/perroPopo.jpg", "Alarma Levante el desecho del perro"),
           //espacio
          alarmaGenerica("assets/casa.png", "Alarma incendio")
        ],
      )),

      SizedBox(
        height: 20,
      ), //espacio
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          alarmaGenerica(
              "assets/terremoto.png", "Alarma sismo"),
          alarmaGenerica("assets/sin-sonido.png", "Alarma Bajar el volumnen")
        ],
      )),

      SizedBox(
        height: espcaio,
      ), //espacio
      Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          alarmaGenerica(
              "assets/pelea.png", "Alarma pelea callejera"),
          alarmaGenerica("assets/anuncios.png", "Anuncio")
        ],
      )),
      SizedBox(
        height: espcaio,
      ),
    ])
  ,);
    
    
  
  }

  Widget alarma() {
    //alarma principal
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('AlertDialog Title'),
              content: const Text('AlertDialog description'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 120,
                child: Image.asset("assets/siren.png"),
              ),
              Text("Presiona para activar la alarma cotra robos"),
            ],
          ), //Icon(Icons.menu),
          style: ButtonStyle(
            // shape: MaterialStateProperty.all(CircleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.all(2)),
            backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 8, 27, 61)), // <-- Button color
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed))
                return Colors.red; // <-- Splash color
            }),
          ),
        )
      ],
    );
  }

  Widget alarmaGenerica(String img, String txt) {
    //alarma items  se puede pasar la funcion en onpressed
    double espacioTxt=10.0;
    TextStyle stilo = TextStyle(color: Colors.white, fontSize: 15.0);
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
          MqttCliente().connectBroker();

          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top:10 ),
                height: 120,
                width: MediaQuery.of(context).size.width / 2.2,
                child: Image.asset(
                  img,
                  width: 70,
                  height: 50,
                ),
              ),
             
              SizedBox(
                height: espacioTxt
              ),
        Container(
          //container de txt
          width: MediaQuery.of(context).size.width / 3.2,
          height:40,
          child: Center(child:Text(txt,style: stilo,textAlign: TextAlign.center,)),),
             SizedBox(
                height: espacioTxt
              ),
              Container(
                color: Colors.green,
                width:  MediaQuery.of(context).size.width/2.2,
                margin: EdgeInsets.all(0),
                height: 30,
                child: Center(child:Text(
                  "Activar",
                  textAlign: TextAlign.center,
                  style: stilo,
                )),
              )
            ],
          ), //Icon(Icons.menu),
          style: ButtonStyle(
            // shape: MaterialStateProperty.all(CircleBorder()),
            shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            // Change your radius here
            borderRadius: BorderRadius.circular(16),
          ),
        ),


            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 8, 27, 61)), // <-- Button color
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed))
                return Colors.red; // <-- Splash color
            }),
          ),
        )
      ],
    ));
  }

  Widget alarmaGenerica2(String img, String txt) {
    //sin uso
    return ElevatedButton(
        onPressed: () {},
        child: Container(
          //card principal
          color: Colors.green,
          height: 140,
          width: MediaQuery.of(context).size.width / 2.5,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
             Center(child:  Image.asset(img, width: 70),),
              Container(
                height: 30,
                color: Colors.white,)
            ],
          ),
        ),
         style: ButtonStyle(
            // shape: MaterialStateProperty.all(CircleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.all(20)),
            backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 8, 27, 61)), // <-- Button color
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed))
                return Colors.red; // <-- Splash color
            }),
          ));
  
  
  }
}

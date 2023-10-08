import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  CarouselController buttonCarouselController = CarouselController();
  double espacio=15.0;

  List<Widget> listaCarusel=[];
  List<String> date1=["assets/camara1.png", "Turbo HD con resolución de 1MP visión nocturna incluida blanca","59.000"];
  List<String> date2=["assets/teaser.png", "Arma de electroshock Taser oficial de policía","79.000"];
  List<String> date3=["assets/cerca.jpg", "Gas lacrimógeno gas pimienta aerosol cs gas aerosol","89.000"];
   List<String> date4=["assets/llavero.png", "Llavero activa las alarmas con tu llavero","29.000"];
  //List<List<String>> date=[date1, date2, date3, date4];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body:SingleChildScrollView(child: Column(
 
  
  children:[
     SizedBox(height: 10.0,),
     carusel(),
       SizedBox(height: 10.0,),
       
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [itemProducto(date1),
        SizedBox(width:espacio ,), itemProducto(date2)],),
         SizedBox(height: 10.0,),
         Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [itemProducto(date3),
        SizedBox(width:espacio ,), itemProducto(date4)],),
         SizedBox(height: 10.0,),
        ]),)


    );
  }

llenarLista(){

  listaCarusel=[itemCarusel("assets/camara1.png", "Cámara de segurida)"),
  itemCarusel("assets/camara1.png", "Cámara de s")
  ];

}
  Widget carusel(){

llenarLista();
return CarouselSlider(
      carouselController: buttonCarouselController,
  options: CarouselOptions(height: 200.0 , autoPlay: true),
  items: listaCarusel,
);


  }

  Widget itemCarusel(String img, String txt){

return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 8, 27, 61)
          ),
          child: Row(children: [
Image.asset(img , width: 70,),
Text(txt)

          ],)
        );

  }


Widget itemProducto(List<String> date){
TextStyle stilo=TextStyle(fontSize: 25);
return ElevatedButton(onPressed: (){}, 
child: 
Container(
 // color:Colors.amber,
  width: MediaQuery.of(context).size.width/2.5,
  height: 230,
  child: Column(children: [
    SizedBox(height:espacio ,),
Center(child: Image.asset(date[0], width: 80, height:80), ),//image
SizedBox(height:espacio ,),
Container(height: 50,
width: (MediaQuery.of(context).size.width/2.5)-20,
  child:Center(child:Text(date[1], textAlign: TextAlign.center,))),//texto descripcion
SizedBox(height:espacio ,),//espacio
Row(
  //precio e icono compra
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children:[Text(date[2], style: stilo,) , SizedBox(width:espacio ,),
Container(
  alignment: Alignment.bottomRight,
  width: 35,
 
  padding: EdgeInsets.all(5.0),
  color: Colors.green,
  child: Icon(Icons.local_grocery_store_outlined),
)
 ]),
 SizedBox(height:espacio ,),//espacio

  ],),


),
style:ButtonStyle(
             //shape: MaterialStateProperty.all(CircleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.all(2)),
            backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 8, 27, 61)), // <-- Button color
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed))
                return Colors.green; // <-- Splash color
            }),
          )
);


}

}
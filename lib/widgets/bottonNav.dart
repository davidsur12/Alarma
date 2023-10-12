import 'package:alarma/screen/test_broker.dart';
import 'package:flutter/material.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import 'package:alarma/screen/home.dart';
import 'package:alarma/screen/store.dart';
import 'package:alarma/screen/config.dart';
class ButtonNav extends StatefulWidget {
  const ButtonNav({super.key});

  @override
  State<ButtonNav> createState() => _ButtonNavState();
}

class _ButtonNavState extends State<ButtonNav> {

  List<Widget> _buildScreens() {
        return [
          Store(),
           home(),
          TextCliente(),
         

        ];
    }
    

    List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: Icon(Icons.store),
                title: ("Tienda"),
                activeColorPrimary: Colors.blue,
                inactiveColorPrimary: Colors.grey,
            ),
             PersistentBottomNavBarItem(
                icon: Icon(Icons.railway_alert),
                title: ("Alarmas"),
                activeColorPrimary: Colors.blue,
                inactiveColorPrimary: Colors.grey,
            ),
             PersistentBottomNavBarItem(
                icon: Icon(Icons.settings),
                title: ("Configuracion"),
                activeColorPrimary: Colors.blue,
                inactiveColorPrimary: Colors.grey,
            ),

          
            
        ];
    }
  @override
  Widget build(BuildContext context) {

    PersistentTabController _controller;
_controller = PersistentTabController(initialIndex: 0);

     return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}


class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green,
    child: Text("Screen1"),);
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red,
    child: Text("Screen2"),);
  }
}

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.indigoAccent,
    child: Text("Screen3"),);
  }
}
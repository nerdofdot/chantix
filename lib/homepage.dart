import 'package:flutter/material.dart';
import 'package:chantix/page1.dart';
import 'package:chantix/page2.dart';
import 'package:chantix/page3.dart';
import 'package:chantix/page4.dart';
import 'package:chantix/page5.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import 'firbase_notification_handler.dart';

class HomePage extends StatefulWidget {
  Map<String,dynamic> info;
  HomePage({this.info});
  @override
  _HomePageState createState() => _HomePageState(infomap: info);
}

int _selectedItemInBottomNavigation = 0;
List widget = [CounterPage(),GraphView(),ChemicalView(),DoctorsViewPage(),InfoPageView()];

Map<String,dynamic> infoMap;





class _HomePageState extends State<HomePage> {
  Map<String,dynamic> infomap;
  _HomePageState({this.infomap});

  setFirebaseMess()async
  {
    //await new FirebaseNotifications().setUpFirebase();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("------------------------------------------------");
    print(infomap);
    infoMap = infomap;
    setFirebaseMess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget[_selectedItemInBottomNavigation],
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        elevation: 2,
        height: 70,
        snakeShape: SnakeShape.indicator,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.only(left: 17,right: 17,bottom: 20),
        snakeViewColor: Colors.red[200],
        selectedItemColor: Colors.red[700],
        unselectedItemColor: Colors.grey[800],
        currentIndex: _selectedItemInBottomNavigation,
        onTap: (index){
          setState(() {
            _selectedItemInBottomNavigation = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot_rounded,size: 27,), label: 'tickets'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined,size: 27,), label: 'calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded,size: 27,), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined,size: 27,), label: 'micro'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline_rounded,size: 27,), label: 'search')
        ],
      ),
    );
  }
}

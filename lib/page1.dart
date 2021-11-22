import 'package:chantix/databasehelper.dart';
import 'package:chantix/homepage.dart';
import 'package:chantix/loadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

DatabaseHelper dbhelper = DatabaseHelper();

int _currentCounter = 0;
int lifeReduced = 0;

class CounterPage extends StatefulWidget
{
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage>
{


  void showInSnackBar(String value)
  {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content:Row(
      children: [
        Icon(Icons.info_rounded,color: Colors.white,),
        Text("   "+value),
      ],
    ),
      backgroundColor: Colors.red[700],
      duration: Duration(milliseconds: 1500),
    ));
  }

  addACigarette()async
  {
    _currentCounter+=1;
    infoMap['dailyCounter'] = _currentCounter;
    infoMap['totalSmokedMonth'] +=1;
    infoMap['totalSmoked']+=1;
    infoMap['moneySpentMonth'] += infoMap['costOfOne'];

    Map<String,dynamic> newMap={
      "dailyCounter": infoMap['dailyCounter'],
      "totalSmokedMonth":infoMap['totalSmokedMonth'],
      "totalSmoked":infoMap['totalSmoked'],
      "moneySpentMonth": infoMap['moneySpentMonth'],
    };


    dbhelper.updateDatawithMap("appDetails", newMap);

    setState(() {

    });
    if(_currentCounter>=infoMap['maxLimit'])
    {
      showInSnackBar("You have crossed your limits!");
    }
  }

  deleteACigarette()async
  {
    if(_currentCounter>0)
    {
      _currentCounter-=1;
      infoMap['dailyCounter'] = _currentCounter;
      infoMap['totalSmokedMonth'] -=1;
      infoMap['totalSmoked']-=1;
      infoMap['moneySpentMonth'] -= infoMap['costOfOne'];

      Map<String,dynamic> newMap2={
        "dailyCounter": infoMap['dailyCounter'],
        "totalSmokedMonth":infoMap['totalSmokedMonth'],
        "totalSmoked":infoMap['totalSmoked'],
        "moneySpentMonth": infoMap['moneySpentMonth'],
      };

      dbhelper.updateDatawithMap("appDetails", newMap2);
    }

    setState(() {

    });
    if(_currentCounter==0)
    {
      showInSnackBar("Cannot go below zero!");
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _currentCounter = infoMap['dailyCounter'];
     lifeReduced=((infoMap['totalSmoked']*11)/1440).toInt();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
              child: Text('CHANTIX',style: TextStyle(color: Colors.red[900],fontSize: 25,fontWeight: FontWeight.w300,),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17,right: 95),
              child: Container(
                height: 100,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Lottie.asset("assets/lifeLostAni.json",repeat: false),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Life lost till date:',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.grey[800],),),
                          Text('$lifeReduced days',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w300,color: Colors.red[900],)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),

            Stack(
              alignment: Alignment.topLeft,
              children: [
                Lottie.asset("assets/heartAni.json"),
                Padding(
                  padding: const EdgeInsets.only(left: 17,right: 95),
                  child: Container(
                    height: 100,
                    child: Card(
                      color: Colors.transparent,
                      elevation: 0.00001,
                      shadowColor: Colors.redAccent[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColorFiltered(
                            child: Lottie.asset("assets/counterAni.json"),
                            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Smoked today:',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.white,),),
                              Text('$_currentCounter cigs',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400,color: Colors.white,),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 340,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
                      child: Text('Smoking is not injurious for you, isn\'t it?',style: TextStyle(color: Colors.grey[500],),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                      child: Text('If you smoke a cigarette, add it!',style: TextStyle(color: Colors.grey[700],fontSize: 15,),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Add cigarette',style: TextStyle(color: Colors.red[800],),),
                          ),
                          icon: Icon(Icons.add,color: Colors.red[800],),
                          onPressed: addACigarette,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red[100]),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.red[200]),
                            overlayColor: MaterialStateProperty.all<Color>(Colors.red[200]),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        TextButton.icon(
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Remove cigarette',style: TextStyle(color: Colors.grey[800],),),
                          ),
                          icon: Icon(Icons.remove,color: Colors.grey[800],),
                          onPressed: deleteACigarette,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[300]),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.grey[400]),
                            overlayColor: MaterialStateProperty.all<Color>(Colors.grey[400]),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          ),
                        )
                      ],
                    ),
                  ],
                ),

              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 45),
              child: Text('app by dotdevelopingteam',style: TextStyle(color: Colors.grey[500],),),
            ),


            //Lottie.network("https://assets5.lottiefiles.com/packages/lf20_GWhY6Y.json",),
          ],
        ),
      ),
    );
  }
}


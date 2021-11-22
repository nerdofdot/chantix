import 'package:chantix/databasehelper.dart';
import 'package:chantix/locationServices.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';



class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

LocationService locationService = LocationService();
DatabaseHelper databaseHelp = DatabaseHelper();

bool isClickedCardio = false;
bool isClickedOnco = false;
bool isClickedRehab = false;

Widget _widgetForCardio = Container();
Widget _widgetForOnco = Container();
Widget _widgetForRehab = Container();

Future<dynamic> fetchedInformationForPackYears;

Map<String,dynamic> fetchedInfoForcardiologistInMap;
Future<dynamic> fetchedInformationForCardiologist;

Map<String,dynamic> fetchedInfoForoncologistInMap;
Future<dynamic> fetchedInformationForOncologist;

Map<String,dynamic> fetchedInfoForrehabInMap;
Future<dynamic> fetchedInformationForrehab;

String cityOfPerson;

Future<dynamic> fetchedCity;


Location location = new Location();

bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

bool locationEnabled = false;

//Future<dynamic> fetchedInformationForPackYears;



class DoctorsViewPage extends StatefulWidget {
  @override
  _DoctorsViewPageState createState() => _DoctorsViewPageState();
}

Future<String> getCityOfPerson() async
{
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled)
  {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled)
    {
      return 'NaN';
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied||_permissionGranted == PermissionStatus.deniedForever)
  {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted)
    {
      //_permissionGranted = await location.requestPermission();
      return 'NaN';
    }
  }

  if(_permissionGranted == PermissionStatus.grantedLimited||_permissionGranted == PermissionStatus.granted)
  {
      print('GRANTED');
      locationEnabled = true;
      if(_serviceEnabled)
        {
          await Future.delayed(Duration(seconds: 1));
          _locationData = await location.getLocation();
          await locationService.getAddressFromLatLng(_locationData);
          cityOfPerson = locationService.city;
          //await databaseHelp.getPackYears();
          return cityOfPerson;
        }
  }
  else
  {
    return 'NaN';
  }
}

class _DoctorsViewPageState extends State<DoctorsViewPage> {

  getLocationInfo()async
  {
    fetchedCity = getCityOfPerson();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchedCity,
        builder: (context,snapshot)
        {
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/searchingAni.json",height: 150,width: 150),
                    Text('Finding doctors...',style: TextStyle(color: Colors.grey[600]),),
                  ],
                ),
              );
            }
          else if(snapshot.hasData)
            {
              print('Data received here');
              cityOfPerson = snapshot.data;
              print(cityOfPerson);
              if(cityOfPerson=='NaN')
                {
                  cityOfPerson = 'berlin';
                  locationEnabled = false;
                }
              return Page4();
            }
          else if(snapshot.hasError)
            return Container();
          else
            return Container();
        },
      ),
    );
  }
}






class _Page4State extends State<Page4> {

  getPackYear()async
  {
    fetchedInformationForPackYears = databaseHelp.getPackYears();
  }

  getCardioDetails() async
  {
    fetchedInformationForCardiologist = databaseHelp.getBestCardiologist(cityOfPerson);
  }

  getOncoDetails() async
  {
    fetchedInformationForOncologist = databaseHelp.getBestOncologist(cityOfPerson);
  }

  getRehabDetails() async
  {
    fetchedInformationForrehab = databaseHelp.getBestRehab(cityOfPerson);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPackYear();
    getCardioDetails();
    getOncoDetails();
    getRehabDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
            child: Text('BEST DOCS',style: TextStyle(color: Colors.brown[900],fontSize: 25,fontWeight: FontWeight.w300),),
          ),
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Lottie.asset("assets/doctorAni.json",reverse: true,height: 330,width: 330),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: TextButton.icon(
                      icon: Icon(Icons.location_searching_rounded,color: Colors.grey[700],),
                      onPressed: null,
                      label: Text('${locationService.city} ',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w600,fontSize: 18),),
                      style: ButtonStyle(
                        //backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[500]),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.red[200]),
                        overlayColor: MaterialStateProperty.all<Color>(Colors.red[200]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  //
                  Padding(
                      padding: const EdgeInsets.only(left: 23,bottom: 25),
                      child: Tooltip(
                        message: 'Show it to the doctor',
                        child: TextButton(
                          child: FutureBuilder(
                            future: fetchedInformationForPackYears,
                            builder: (context,snapshot)
                            {
                              if(snapshot.connectionState == ConnectionState.waiting)
                                return Text('Computing..',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500,),);
                              else if (snapshot.hasData)
                              {
                                print('Data received');
                                String packY = snapshot.data.toString();
                                return Text('Pack years : ${packY}',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500,),);
                              }
                              else if(snapshot.hasError)
                              {
                                return Container();
                              }
                              else
                                return Container();
                            },
                          ) ,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.grey),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                          ),
                        ),
                      )
                  ),

                ],
              ),
            ],
          ),


          Padding(
            padding: EdgeInsets.only(left: 25,right: 25,bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Cardiologist',style: TextStyle(color: Colors.red[800],fontSize: 22,fontWeight: FontWeight.w300),),
                    IconButton(
                      icon: Icon(Icons.info_outline_rounded),
                      color: Colors.grey[700],
                      focusColor: Colors.grey[300],
                      onPressed: (){
                        setState(() {
                          isClickedCardio = !isClickedCardio;
                          isClickedCardio?_widgetForCardio=DoctorInfoC(phoneNumber: fetchedInfoForcardiologistInMap['result']['international_phone_number'].toString(),web: fetchedInfoForcardiologistInMap['result']['website'],mapUrl:fetchedInfoForcardiologistInMap['result']['url'],):_widgetForCardio=Container();
                        });
                      },
                    )
                  ],
                ),
                FutureBuilder(
                 future: fetchedInformationForCardiologist,
                 builder: (context,snapshot)
                 {
                   if(snapshot.connectionState == ConnectionState.waiting)
                     return Text('Finding best cardiologist for you...',style: TextStyle(color: Colors.grey[700],fontSize: 14,fontWeight: FontWeight.w300),);
                   else if (snapshot.hasData)
                   {
                     print('Data received');
                     fetchedInfoForcardiologistInMap = snapshot.data;
                     //print(fetchedInfoForcardiologistInMap);
                     return Text('${fetchedInfoForcardiologistInMap['result']['name']}',style: TextStyle(color: Colors.grey[700],fontSize: 14,fontWeight: FontWeight.w300),);
                   }
                   else if(snapshot.hasError)
                   {
                     return Text('Error occurred. Revisit the page..',style: TextStyle(color: Colors.grey[700],fontSize: 14,fontWeight: FontWeight.w300),);
                   }
                   else
                     return Container();
                 },
                ),

                AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  child: _widgetForCardio,
                  switchOutCurve: Curves.easeOut,
                  switchInCurve: Curves.easeIn,
                )
              ],
            ),
          ),


          Padding(
            padding: EdgeInsets.only(left: 25,right: 25,bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Oncologist  ',style: TextStyle(color: Colors.grey[800],fontSize: 22,fontWeight: FontWeight.w300,),),
                    IconButton(
                      icon: Icon(Icons.info_outline_rounded),
                      color: Colors.grey[700],
                      focusColor: Colors.grey[300],
                      onPressed: (){
                        setState(() {
                          isClickedOnco = !isClickedOnco;
                          isClickedOnco?_widgetForOnco=DoctorInfoO(phoneNumber: fetchedInfoForoncologistInMap['result']['international_phone_number'].toString(),web: fetchedInfoForoncologistInMap['result']['website'],mapUrl:fetchedInfoForoncologistInMap['result']['url'],):_widgetForOnco=Container();
                        });
                      },
                    )
                  ],
                ),
                FutureBuilder(
                  future: fetchedInformationForOncologist,
                  builder: (context,snapshot)
                  {
                    if(snapshot.connectionState == ConnectionState.waiting)
                      return Text('Finding best oncologist for you...',style: TextStyle(color: Colors.grey[700],fontSize: 14,fontWeight: FontWeight.w300),);
                    else if (snapshot.hasData)
                    {
                      print('Data received for onco');
                      fetchedInfoForoncologistInMap = snapshot.data;
                      print(fetchedInfoForoncologistInMap);
                      return Text('${fetchedInfoForoncologistInMap['result']['name']}',style: TextStyle(color: Colors.grey[700],fontSize: 14,fontWeight: FontWeight.w300),);
                    }
                    else if(snapshot.hasError)
                    {
                      return Text('Error occurred. Revisit the page..',style: TextStyle(color: Colors.grey[700],fontSize: 14,fontWeight: FontWeight.w300),);
                    }
                    else
                      return Container();
                  },
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  child: _widgetForOnco,
                  switchOutCurve: Curves.easeOut,
                  switchInCurve: Curves.easeIn,
                )
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 25,right: 25,bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Rehabilitation  ',style: TextStyle(color: Colors.brown[700],fontSize: 22,fontWeight: FontWeight.w400,),),
                    IconButton(
                      icon: Icon(Icons.info_outline_rounded),
                      color: Colors.grey[700],
                      focusColor: Colors.grey[300],
                      onPressed: (){
                        setState(() {
                          isClickedRehab = !isClickedRehab;
                          isClickedRehab?_widgetForRehab=DoctorInfoR(phoneNumber: fetchedInfoForrehabInMap['result']['international_phone_number'].toString(),web: fetchedInfoForrehabInMap['result']['website'],mapUrl:fetchedInfoForrehabInMap['result']['url'],):_widgetForRehab=Container();
                        });
                      },
                    )
                  ],
                ),
                FutureBuilder(
                  future: fetchedInformationForrehab,
                  builder: (context,snapshot)
                  {
                    if(snapshot.connectionState == ConnectionState.waiting)
                      return Text('Finding best rehab for you...',style: TextStyle(color: Colors.grey[700],fontSize: 14,fontWeight: FontWeight.w300),);
                    else if (snapshot.hasData)
                    {
                      print('Data received');
                      fetchedInfoForrehabInMap = snapshot.data;
                      //print(fetchedInfoForrehabInMap);
                      return Text('${fetchedInfoForrehabInMap['result']['name']}',style: TextStyle(color: Colors.grey[700],fontSize: 14,fontWeight: FontWeight.w300),);
                    }
                    else if(snapshot.hasError)
                    {
                      return Text('Error occurred. Revisit the page..',style: TextStyle(color: Colors.grey[700],fontSize: 14,fontWeight: FontWeight.w300),);
                    }
                    else
                      return Container();
                  },
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  child: _widgetForRehab,
                  switchOutCurve: Curves.easeOut,
                  switchInCurve: Curves.easeIn,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 23,right: 23,bottom: 10),
            child: Text('dotdevelopingteam does not have any affiliation with these doctors/hospitals ',style: TextStyle(color: Colors.grey[600],fontSize: 14,fontWeight: FontWeight.w300,),),
          ),
        ],
      ),
    );
  }
}


class DoctorInfoC extends StatelessWidget {
  String phoneNumber;
  String web;
  String mapUrl;

  _launchUrl(String url) async
  {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  DoctorInfoC({this.phoneNumber,this.web,this.mapUrl});
  @override
  Widget build(BuildContext context) {
    print(phoneNumber);
    print(web);
    print(mapUrl);
    return Row(
      children: [
        TextButton.icon(
          icon: Icon(Icons.phone,color: Colors.green[600],),
          onPressed: (){
            _launchUrl("tel:"+phoneNumber);
          },
          label: Text('Call me ',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.w400),),
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all<Color>(Colors.green[100]),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.green[100]),
            overlayColor: MaterialStateProperty.all<Color>(Colors.green[200]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
        TextButton.icon(
          icon: Icon(Icons.web_asset_rounded,color: Colors.grey[600],),
          onPressed: (){
            _launchUrl(web);
          },
          label: Text('Website ',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w400),),
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[300]),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.grey[200]),
            overlayColor: MaterialStateProperty.all<Color>(Colors.grey[400]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
        TextButton.icon(
          icon: Icon(Icons.location_on,color: Colors.red[700],),
          onPressed: (){
            _launchUrl(mapUrl);
          },
          label: Text('Spot me ',style: TextStyle(color: Colors.red[700],fontWeight: FontWeight.w400),),
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all<Color>(Colors.red[100]),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.red[200]),
            overlayColor: MaterialStateProperty.all<Color>(Colors.red[200]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
      ],
    );
  }
}

class DoctorInfoO extends StatelessWidget {
  String phoneNumber;
  String web;
  String mapUrl;

  _launchUrl(String url) async
  {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  DoctorInfoO({this.phoneNumber,this.web,this.mapUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          icon: Icon(Icons.phone,color: Colors.green[600],),
          onPressed: (){
            _launchUrl("tel:"+phoneNumber);
          },
          label: Text('Call me ',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.w400),),
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all<Color>(Colors.green[100]),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.green[100]),
            overlayColor: MaterialStateProperty.all<Color>(Colors.green[200]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
        TextButton.icon(
          icon: Icon(Icons.web_asset_rounded,color: Colors.grey[600],),
          onPressed: (){
            _launchUrl(web);
          },
          label: Text('Website ',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w400),),
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[300]),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.grey[200]),
            overlayColor: MaterialStateProperty.all<Color>(Colors.grey[400]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
        TextButton.icon(
          icon: Icon(Icons.location_on,color: Colors.red[700],),
          onPressed: (){
            _launchUrl(mapUrl);
          },
          label: Text('Spot me ',style: TextStyle(color: Colors.red[700],fontWeight: FontWeight.w400),),
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all<Color>(Colors.red[100]),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.red[200]),
            overlayColor: MaterialStateProperty.all<Color>(Colors.red[200]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
      ],
    );
  }
}




class DoctorInfoR extends StatelessWidget {
  String phoneNumber;
  String web;
  String mapUrl;

  _launchUrl(String url) async
  {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  DoctorInfoR({this.phoneNumber,this.web,this.mapUrl});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          icon: Icon(Icons.phone,color: Colors.green[600],),
          onPressed: (){
            _launchUrl("tel:"+phoneNumber);
          },
          label: Text('Call me ',style: TextStyle(color: Colors.green[700],fontWeight: FontWeight.w400),),
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all<Color>(Colors.green[100]),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.green[100]),
            overlayColor: MaterialStateProperty.all<Color>(Colors.green[200]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
        TextButton.icon(
          icon: Icon(Icons.web_asset_rounded,color: Colors.grey[600],),
          onPressed: (){
            _launchUrl(web);
          },
          label: Text('Website ',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w400),),
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[300]),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.grey[200]),
            overlayColor: MaterialStateProperty.all<Color>(Colors.grey[400]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
        TextButton.icon(
          icon: Icon(Icons.location_on,color: Colors.red[700],),
          onPressed: (){
            _launchUrl(mapUrl);
          },
          label: Text('Spot me ',style: TextStyle(color: Colors.red[700],fontWeight: FontWeight.w400),),
          style: ButtonStyle(
            //backgroundColor: MaterialStateProperty.all<Color>(Colors.red[100]),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.red[200]),
            overlayColor: MaterialStateProperty.all<Color>(Colors.red[200]),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ),
      ],
    );
  }
}





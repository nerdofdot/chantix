import 'dart:async';

import 'package:chantix/databasehelper.dart';
import 'package:chantix/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class Loading extends StatefulWidget
{
  @override
  _LoadingState createState() => _LoadingState();
}

Future<dynamic> fetchedInformation;
Map<String,dynamic> fetchedInformationinMap;
bool userExists = false;

class _LoadingState extends State<Loading>
{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

  DatabaseHelper databaseHelper = DatabaseHelper();

  // get User authentication status here
  // it checks if user is using the app and is in database.
  Future initializeUser() async
  {
    await Firebase.initializeApp();
    final User firebaseUser = await FirebaseAuth.instance.currentUser;
    await firebaseUser.reload();
    _user = await _auth.currentUser;
  }

  navigateUser() async
  {
    // checking whether user already loggedIn or not
    if (_auth.currentUser != null)
    {
      userExists = true;
      // &&  FirebaseAuth.instance.currentUser.reload() != null
    }
    else
    {
      //if user is NOT  available go to Authentication of new user screen
      Timer(Duration(milliseconds: 300),
              () => Navigator.pushReplacementNamed(context, "/auth"));
    }
  }

  getData()async
  {
    fetchedInformation = databaseHelper.getInfo();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeUser();
    navigateUser();
    if(userExists)
      {
        getData();
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchedInformation,
        builder: (context,snapshot)
        {
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CHANTIX',
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Saving your life.',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Center(
                    child: ColorFiltered(child: Lottie.asset('assets/loadAni.json',height: 300,width: 300),
                      colorFilter: ColorFilter.mode(Colors.red[600], BlendMode.srcATop),),
                  ),
                  Text(
                    'Loading screens....',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }
          else if(snapshot.hasData)
            {
              print('Data recieved in future builder for turf info from real time DB ohohohohohohoh');
              fetchedInformationinMap = snapshot.data;
              print(fetchedInformationinMap);
              return HomePage(info: fetchedInformationinMap,);
            }
          else if(snapshot.hasError)
            {
              return Center(child: Text('Wait....'),);
            }
          else
            return Center(child: Text('Wait....'),);
        },
      )
    );

  }
}
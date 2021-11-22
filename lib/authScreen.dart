import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import 'onboardingScreen.dart';


//user details
String name;
String email;
String imageUrl;

User user;


final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

//this key is for Scaffold snackbar display
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


// stful wid for auth screen
class AuthScreen extends StatefulWidget
{
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  Future<User> _signIn() async
  {
    //these lines are used to sign in the user with Google Auth
    await Firebase.initializeApp();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    // final AuthResult authResult = await auth.signInWithCredential(credential);
    // final User user = authResult.user;

    user = (await auth.signInWithCredential(credential)).user;
    if (user != null) {
      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;
    }
    return user;
  }

  //call this func for snackbar display
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content:Row(
      children: [
        Icon(Icons.info_rounded,color: Colors.white,),
        Text("   "+value),
      ],
    ),
      backgroundColor: Colors.red[800],
    ));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ColorFiltered(
              child: Lottie.asset("assets/bubbleAni.json",),
              colorFilter: ColorFilter.mode(Colors.grey[300], BlendMode.srcATop),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'It\'s Chantix',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/chantixLogoFinal.png',
                          height: 200.0,
                          width: 200.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text('Controls your urge to smoke.',style: TextStyle(color: Colors.grey,),),
                    SizedBox(height: 15,),
                    Text('Yearly 5 million people die due',style: TextStyle(color: Colors.grey,),),
                    Text('to it and you may be the next.',style: TextStyle(color: Colors.grey,),),
                    SizedBox(height: 70,),
                    Container(
                        height: 55,
                        width: 200,
                        child: ElevatedButton.icon(
                          onPressed: (){
                            //call signin function
                            _signIn().whenComplete(() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>OnBoardingPage()),
                                      (Route<dynamic> route) => false);
                            }).catchError((onError) {
                              showInSnackBar("Error occurred. Check your internet!");
                              Navigator.pushReplacementNamed(context, "/auth");
                            });
                          },
                          icon: Image.asset("assets/googleLogo.png",height: 25,width: 25,color: Colors.white,),
                          label: Text(' Create account'),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              elevation: MaterialStateProperty.all(5),
                              backgroundColor: MaterialStateProperty.all(Colors.red[700])
                          ),
                        )
                    ),
                    SizedBox(height: 20,),
                    Text(
                      'app by dotdevelopingteam',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontFamily: 'Comfortaa',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}




import 'package:chantix/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chantix/homepage.dart';

String costOfOneCig = "";
double maxLimitOfCigarette = 0;

final formkey = new GlobalKey<FormState>();

List <String> urls = ["https://www.instagram.com/dotdevelopingteam/",
  "https://www.facebook.com/Dotdevelopingteam-119380963227164","https://youtu.be/S0Dq4n6PTRc"];

DatabaseHelper dbhelper2 = DatabaseHelper();

class InfoPageView extends StatefulWidget {
  @override
  _InfoPageViewState createState() => _InfoPageViewState();
}


class _InfoPageViewState extends State<InfoPageView> {


  launchURL(value) async {
    if (await canLaunch(urls[value])) {
      await launch(urls[value]);
    } else {
      throw 'Could not launch ${urls[value]}';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    costOfOneCig = infoMap['costOfOne'].toString();
    maxLimitOfCigarette = infoMap['maxLimit'].toDouble();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                child: Text('INFO',style: TextStyle(color: Colors.red[900],fontSize: 25,fontWeight: FontWeight.w300),),
              ),
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  ColorFiltered(child: Lottie.asset("assets/deviceAni.json",height: 350,width: 350),
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcATop),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
                        child: Text('Chantix\'s wrist band.',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 18),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 50,bottom: 0),
                        child: Text('We will be launching a wrist band that detects when you smoke a cigarette. Coming soon.. Stay connected with dotdevelopingteam',style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey[600],fontSize: 14),),
                      ),
                    ],
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
                child: Text('Set max limit of cigarettes (per day)',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 16),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
                child: Text('${maxLimitOfCigarette.toInt()}',style: TextStyle(fontWeight: FontWeight.w800,color: Colors.grey[500],fontSize: 24),),
              ),

              Slider(
                value: maxLimitOfCigarette,
                activeColor: Colors.red[800],
                max: 40,
                min: 1,
                onChanged: (value){
                  setState(() {
                    maxLimitOfCigarette = value;
                  });
                },
                onChangeEnd: (valu)
                {
                  dbhelper2.setData("appDetails", "maxLimit", valu.toInt());
                },
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0,top: 20),
                child: Text('Set cost of one cigarette',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 16),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 50,bottom: 15),
                child: Text('May vary depending on your city/locality',style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey[600],fontSize: 14),),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20,right: 170,bottom: 0),
                child:TextFormField(
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Cost of one",border:OutlineInputBorder(borderRadius: BorderRadius.circular(12),),hintStyle: TextStyle(fontSize: 14),prefixIcon: Icon(Icons.attach_money_rounded)),
                  onChanged: (val){
                    print(val);
                    setState(() {
                      costOfOneCig = val;
                    });
                  },
                  onFieldSubmitted: (val)
                  {
                    print(val);
                    if(double.parse(val)!=null)
                    {
                      dbhelper2.setData("appDetails", "costOfOne", double.parse(val));
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0,top: 50),
                child: Text('About us',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 18),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 50,bottom: 0),
                child: Text('dotdevelopingteam coded Chantix for you betterment.',style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey[600],fontSize: 14),),
              ),
              Container(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Image(image: AssetImage('assets/instagramlogo.png'),color: Colors.grey[600],),
                      iconSize: 30,
                      onPressed:(){
                        launchURL(0);
                      },
                      highlightColor: Colors.deepPurple[50],
                    ),
                    IconButton(
                      icon: Image(image: AssetImage('assets/facebooklogo.png'),color: Colors.grey[600],),
                      iconSize: 30,
                      onPressed:(){
                        launchURL(1);
                      },
                      highlightColor: Colors.blue[50],
                    ),
                    IconButton(
                      icon: Image(image: AssetImage('assets/youlogo.png'),color: Colors.grey[600],),
                      iconSize: 35,
                      onPressed:(){
                        launchURL(2);
                      },
                      highlightColor: Colors.red[50],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/dotlogo.png',
                      height: 200.0,
                      width: 200.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}


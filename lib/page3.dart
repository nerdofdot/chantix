import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:chantix/homepage.dart';

import 'databasehelper.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

List<int> cigaretteSmokedInList = [];
int totalCigarettesInAWeek = 0;

double nicotineInBody = 0;
double cohbInBody = 0;
double tarInBody =0;


bool isInformDoctorsClicked = false;
Widget displayWidget = Container();

class ChemicalView extends StatefulWidget {
  @override
  _ChemicalViewState createState() => _ChemicalViewState();
}

class _ChemicalViewState extends State<ChemicalView>
{

  setDataForChemicals()async
  {
    int j = 0 ;
    totalCigarettesInAWeek=0;
    cigaretteSmokedInList = [];
    for(int i = infoMap['listCounter']-7;i<infoMap['listCounter'];i++)
    {
      cigaretteSmokedInList.insert(j, infoMap['count$i']);
      totalCigarettesInAWeek +=infoMap['count$i'];
      j++;
    }
    calculateNicotine();
    calculateCOHB();
    calculateTar();
  }

  calculateNicotine()async
  {
    nicotineInBody = (1.8*totalCigarettesInAWeek)/7;
  }

  calculateCOHB() async
  {
    cohbInBody = (1.12*totalCigarettesInAWeek/7)*3.2;
  }

  calculateTar()
  {
    tarInBody = (totalCigarettesInAWeek*12/50)*12.5;
  }



  bool calculateSafetyForNicotine()
  {
    if(nicotineInBody<35)
      return true;
    else
      return false;
  }

  String calculateNicotineInNG()
  {
    int intensity = 0;
    for(int i =0;i<7;i++)
    {
      if(cigaretteSmokedInList[i]!=0)
        intensity++;
    }
    if(intensity>=5)
      return '1000 ng/ml in urine';
    else
      return '50 ng/ml in urine';
  }

  bool calculateSafetyForCOHB()
  {
    if(cohbInBody<40)
      return true;
    else
      return false;
  }

  bool calculateSafetyForTar()
  {
    if(tarInBody<240)
      return true;
    else
      return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDataForChemicals();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
              child: Text('IN YOUR BODY',style: TextStyle(color: Colors.brown[900],fontSize: 25,fontWeight: FontWeight.w300),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
              child: Text('Disclaimer',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 18),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
              child: Text('The accuracy is 80%.',style: TextStyle(color: Colors.brown[900],fontSize: 14,fontWeight: FontWeight.w300),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
              child: Text('Seek medical advice if needed.',style: TextStyle(color: Colors.brown[900],fontSize: 14,fontWeight: FontWeight.w300)),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 25,right: 25),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                    child: Container(
                        height: 110,
                        width: 110,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ColorFiltered(child: Lottie.asset("assets/bubbleAni.json",reverse: true),
                              colorFilter:  ColorFilter.mode(Colors.brown[500], BlendMode.srcATop),),
                            CircularStepProgressIndicator(
                              totalSteps: 50,
                              currentStep: nicotineInBody.toInt(),
                              stepSize: 3,
                              selectedColor: Color(0xff440b0b),
                              unselectedColor: Colors.grey[200],
                              padding: 0,
                              width: 150,
                              height: 150,
                              selectedStepSize: 4,
                              roundedCap: (_, __) => true,
                            ),
                            Text('${nicotineInBody.toInt()} mg',style: TextStyle(color: Colors.brown[600],fontWeight: FontWeight.w400,fontSize: 16),)
                          ],
                        )
                    ),
                  ),
                  Container(
                    height: 110,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nicotine',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w300,color: Colors.brown[600]),),
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,color:calculateSafetyForNicotine()?Colors.grey:Colors.red[900],),
                              SizedBox(width: 10,),
                              Icon(Icons.check_circle_outline,color: calculateSafetyForNicotine()?Colors.green[800]:Colors.grey,),
                            ],
                          ),
                          Text(calculateNicotineInNG(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.grey),),
                          Text('Max limit : 65 mg',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.grey[600]),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 25,right: 25),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                    child: Container(
                        height: 110,
                        width: 110,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ColorFiltered(child: Lottie.asset("assets/bubbleAni.json",reverse: true),
                              colorFilter:  ColorFilter.mode(Colors.green[500], BlendMode.srcATop),),
                            CircularStepProgressIndicator(
                              totalSteps: 100,
                              currentStep: cohbInBody.toInt(),
                              stepSize: 3,
                              selectedColor: Color(0xff0d3908),
                              unselectedColor: Colors.grey[200],
                              padding: 0,
                              width: 150,
                              height: 150,
                              selectedStepSize: 4,
                              roundedCap: (_, __) => true,
                            ),
                            Text('${cohbInBody.toInt()} ppm',style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.w400,fontSize: 16),)
                          ],
                        )
                    ),
                  ),
                  Container(
                    height: 110,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('COHb',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w300,color: Colors.green[900]),),
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,color: calculateSafetyForCOHB()?Colors.grey:Colors.red[800],),
                              SizedBox(width: 10,),
                              Icon(Icons.check_circle_outline,color: calculateSafetyForCOHB()?Colors.green[800]:Colors.grey,),
                            ],
                          ),
                          Text('parts per million',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.grey),),
                          Text('Max limit : 100 ppm',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.grey[600]),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),


            SizedBox(height: 15,),


            Padding(
              padding: const EdgeInsets.only(left: 25,right: 25),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                    child: Container(
                        height: 110,
                        width: 110,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ColorFiltered(child: Lottie.asset("assets/bubbleAni.json",reverse: true),
                              colorFilter:  ColorFilter.mode(Colors.grey[500], BlendMode.srcATop),),
                            CircularStepProgressIndicator(
                              totalSteps: 310,
                              currentStep: tarInBody.toInt(),
                              stepSize: 3,
                              selectedColor: Color(0xd3000000),
                              unselectedColor: Colors.grey[200],
                              padding: 0,
                              width: 150,
                              height: 150,
                              selectedStepSize: 4,
                              roundedCap: (_, __) => true,
                            ),
                            Text('${tarInBody.toInt()} mg',style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w400,fontSize: 16),)
                          ],
                        )
                    ),
                  ),
                  Container(
                    height: 110,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tar',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w300,color: Colors.grey[800]),),
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,color: calculateSafetyForTar()?Colors.grey:Colors.red[800],),
                              SizedBox(width: 10,),
                              Icon(Icons.check_circle_outline,color: calculateSafetyForTar()?Colors.green[800]:Colors.grey,),
                            ],
                          ),
                          Text('Tobacco residue',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.grey),),
                          Text('Max limit : 350 mg',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.grey[600]),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 25,bottom: 0),
              child: Row(
                children: [
                  Text('Inform doctors   ',style: TextStyle(color: Colors.brown[900],fontSize: 18,fontWeight: FontWeight.w300),),
                  Icon(Icons.verified,color: infoMap['informDoc']?Colors.green:Colors.grey[500],),
                  IconButton(icon: Icon(Icons.info_outline_rounded),
                      onPressed: (){
                        setState(() {
                          isInformDoctorsClicked = !isInformDoctorsClicked;
                          isInformDoctorsClicked?displayWidget=InformDocEnableDisableView():displayWidget=Container();
                        });
                      })
                ],
              ),
            ),
            displayWidget,
            ChemicalInformationView(),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}



class InformDocEnableDisableView extends StatefulWidget {
  @override
  _InformDocEnableDisableViewState createState() => _InformDocEnableDisableViewState();
}

class _InformDocEnableDisableViewState extends State<InformDocEnableDisableView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 25,right: 25,bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enable it to inform best doctors in your city\nabout your degrading health condition.\nWhen enabled, the app will automatically\nsend SMS to them!'),
            Row(
              children: [
                Text(infoMap['informDoc']?'Enabled ':'Disabled',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                Switch(
                  value: infoMap['informDoc'],
                  activeColor: Colors.green,
                  onChanged: (val)
                  {
                    infoMap['informDoc'] = !infoMap['informDoc'];


                    databaseHelper.setData("appDetails", "informDoc", val);

                    setState(() {

                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}



class ChemicalInformationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 25,right: 25,top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nicotine',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 18),),
            SizedBox(height: 5,),
            Text('Consumption of nicotine more than 65 mg is fatal.',style: TextStyle(color: Colors.brown[900],fontSize: 14,fontWeight: FontWeight.w300),),
            Text('It can affect the heart, hormones, and gastrointestinal system.',style: TextStyle(color: Colors.brown[900],fontSize: 14,fontWeight: FontWeight.w300),),

            SizedBox(height: 25,),
            Text('Carbon Monoxide',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 18),),
            SizedBox(height: 5,),
            Text('Inhalation of CO more than 100 ppm may be fatal.',style: TextStyle(color: Colors.brown[900],fontSize: 14,fontWeight: FontWeight.w300),),
            Text('Symptoms of CO poisoning are headache, dizziness, vomiting, chest pain, and confusion.',style: TextStyle(color: Colors.brown[900],fontSize: 14,fontWeight: FontWeight.w300)),

            SizedBox(height: 25,),
            Text('Tar/Tobacco residue',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 18),),
            SizedBox(height: 5,),
            Text('Tar in cigarette smoke paralyzes the cilia in the lungs and contributes to lung diseases such as emphysema, chronic bronchitis, and lung cancer.',style: TextStyle(color: Colors.brown[900],fontSize: 14,fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}



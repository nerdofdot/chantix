import 'package:chantix/databasehelper.dart';
import 'package:chantix/homepage.dart';
import 'package:chantix/loadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'check_internet.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

double averageCigarettes = 5;
double maxCigarettes = 10;

final formkey = new GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



DateTime dateToday = DateTime.now();
DateTime selectedDate = DateTime.now();

CheckInternet checkInternet = CheckInternet();

class _UserInfoState extends State<UserInfo> {

  DatabaseHelper _databaseHelper = DatabaseHelper();

  validateAndSave() async{
    final FormState form = formkey.currentState;
    if (form.validate()) {
      print('Form is valid');
     print(averageCigarettes.toInt());
     print(maxCigarettes.toInt());
     print(selectedDate);
     print(double.parse(costOfOne));
     print(double.parse(monthlyBudget));
      bool internetStatus = await checkInternet.isIntenetAvailable();
      if(internetStatus)
        {
          _databaseHelper.setDataForFirstTime(averageCigarettes.toInt(),selectedDate, maxCigarettes.toInt(), double.parse(monthlyBudget), double.parse(costOfOne));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>Loading()),
                  (Route<dynamic> route) => false);
        }
      else
        {
          showInSnackBar("No internet available");
        }

    }
    else
    {
      print('Form is invalid');
    }
  }

  String costOfOne = "";
  String monthlyBudget = "";

  Future<void> _selectDate(BuildContext context) async {

    final DateTime picked = await showDatePicker(
        context: context,
        helpText: 'SELECT DATE WHEN TOU STARTED SMOKING!',
        fieldLabelText: 'Be precise!',
        initialDate: selectedDate,
        firstDate: DateTime(dateToday.year, dateToday.month,dateToday.day).subtract(Duration(days: 36500)),
        lastDate: DateTime(dateToday.year,dateToday.month,dateToday.day));

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Center(child: Text('Fill the form',style: TextStyle(color: Colors.grey[700],fontSize: 25,fontWeight: FontWeight.w500),)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/formAni.json",height: 100,width: 100),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0,right: 20,top: 20),
                          child: Text('Cigarettes you smoke daily',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 16),),
                        ),
                        Row(
                          children: [
                            Text('${averageCigarettes.toInt()}',style: TextStyle(fontWeight: FontWeight.w800,color: Colors.grey[500],fontSize: 24),),
                            Slider(
                              value: averageCigarettes,
                              activeColor: Colors.purple,
                              inactiveColor: Colors.purple[100],
                              max: 40,
                              min: 1,
                              onChanged: (value){
                                setState(() {
                                  averageCigarettes = value;
                                });
                              },
                            ),
                          ],
                        ),

                      ],
                    )
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/formAni.json",height: 100,width: 100),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0,right: 20,top: 20),
                          child: Text('Max cigarettes in a day',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 16),),
                        ),
                        Row(
                          children: [
                            Text('${maxCigarettes.toInt()}',style: TextStyle(fontWeight: FontWeight.w800,color: Colors.grey[500],fontSize: 24),),
                            Slider(
                              value: maxCigarettes,
                              activeColor: Colors.purple,
                              inactiveColor: Colors.purple[100],
                              max: 40,
                              min: 1,
                              onChanged: (value){
                                setState(() {
                                  maxCigarettes = value;
                                });
                              },
                            ),
                          ],
                        ),

                      ],
                    )
                  ],
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/calendarAni.json",height: 100,width: 100),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0,right: 20,top: 20),
                          child: Text('Date started smoking',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 16),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0,right: 0,top: 0),
                          child: Text('Tap below to select date',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 12),),
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              icon: Icon(Icons.calendar_today_rounded,color: Colors.grey[700],),
                              label: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',style: TextStyle(color: Colors.grey[700]),),
                              onPressed: (){
                                _selectDate(context);
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.blue[200]),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                              ),
                            )
                          ],
                        ),

                      ],
                    )
                  ],
                ),

                SizedBox(height: 30,),
                Center(child: Text('Budgeting',style: TextStyle(color: Colors.grey[700],fontSize: 25,fontWeight: FontWeight.w500),)),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 10),
                  child: Text('Cost of one cigarette',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 16),),
                ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 170,bottom: 25),
              child:TextFormField(
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.left,
                initialValue: "",
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Cost of one",border:OutlineInputBorder(borderRadius: BorderRadius.circular(12),),hintStyle: TextStyle(fontSize: 14),prefixIcon: Icon(Icons.attach_money_rounded)),
                onChanged: (val){
                  print(val);
                  setState(() {
                    this.costOfOne = val;
                  });
                },
                validator: (String value)
                {
                  if(value==""||value=="0")
                  {
                    print('here');
                    return 'Please enter a valid value';
                  }
                  else
                    return null;
                },
              ),
            ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 10),
                  child: Text('Maximum monthly budget',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey[600],fontSize: 16),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 170,bottom: 30),
                  child:TextFormField(
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.left,
                    initialValue: "",
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Month\'s budget",border:OutlineInputBorder(borderRadius: BorderRadius.circular(12),),hintStyle: TextStyle(fontSize: 14),prefixIcon: Icon(Icons.attach_money_rounded)),
                    onChanged: (val){
                      setState(() {
                        this.monthlyBudget = val;
                      });
                    },
                    validator: (String values)
                    {
                      if(values==""||values=="0")
                      {
                        print('here');
                        return 'Please enter a valid value';
                      }
                      else
                        return null;
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,bottom: 30),
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text('Lets go',style: TextStyle(color: Colors.white),),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
                        elevation: MaterialStateProperty.all(5)

                      ),
                      onPressed:validateAndSave,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

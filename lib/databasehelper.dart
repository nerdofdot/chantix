import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:async/async.dart';
import 'package:http/http.dart';
import 'dart:convert';

class DatabaseHelper
{
  final dbref_for_cloud = FirebaseFirestore.instance;
  DatabaseReference dbref_for_realTime= FirebaseDatabase.instance.reference();

  final FirebaseDatabase database = FirebaseDatabase();

  bool visited = false;

  double packYears = 0;

  String key = "AIzaSyBJQcJHahFxYintO8pPPI7KkKnOaS7DwJM";

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  tripFunction(int dateInDatabase,int previousCounted,int listCounterIndex,int monthInDatabase) async
  {
    DateTime today = DateTime.now();
    int dayToday = today.day;
    int monthToday = today.month;
    if(dayToday!= dateInDatabase)
      {
        visited = true;
        Map<String,dynamic> resetMap = {
          "dayNow":dayToday,
          "dailyCounter":0,
          "listCounter":listCounterIndex+1,
        };
        updateDatawithMap("appDetails", resetMap);
        setData("listDetails", "count$listCounterIndex",previousCounted);
      }
    print('Done with date');
    if(monthToday!=monthInDatabase)
      {
        visited = true;
        Map<String,dynamic> resetMap2 = {
          "monthNow":monthToday,
          "moneySpentMonth":0,
          "totalSmokedMonth":0,
        };
        updateDatawithMap("appDetails", resetMap2);
      }
  }

  Future getInfo() async
  {
    final FirebaseAuth authnow = FirebaseAuth.instance;
    User usernow;
    usernow = await authnow.currentUser;

    return this._memoizer.runOnce(() async
    {
      Map<dynamic,dynamic> map1 = await dbref_for_cloud.collection(usernow.email.toString()).doc("appDetails").get().then((value) => value.data());
      Map<dynamic,dynamic> map2 = await dbref_for_cloud.collection(usernow.email.toString()).doc("listDetails").get().then((value) => value.data());

      await tripFunction(map1['dayNow'].toInt(), map1['dailyCounter'], map1['listCounter'], map1['monthNow']);

      if(visited)
      {
        map1 = await dbref_for_cloud.collection(usernow.email.toString()).doc("appDetails").get().then((value) => value.data());
        map2 = await dbref_for_cloud.collection(usernow.email.toString()).doc("listDetails").get().then((value) => value.data());
      }
      Map<String,dynamic> map3 ={...map1,...map2,};
      await Future.delayed(Duration(milliseconds: 200));
      return map3;
    });
  }


  Future getPackYears()async
  {
    final FirebaseAuth authnow = FirebaseAuth.instance;
    User usernow;
    usernow = await authnow.currentUser;

    return this._memoizer.runOnce(() async
    {
      Map<dynamic,dynamic> temp = await dbref_for_cloud.collection(usernow.email.toString()).doc("appDetails").get().then((value) => value.data());
      packYears = double.parse(((temp['totalSmoked'])/(20*365)).toStringAsFixed(2));
      return packYears;
    });
  }

  void setData(String docName,String fieldName,dynamic valueOfField)async
  {
    final FirebaseAuth authnow = FirebaseAuth.instance;
    User usernow;
    usernow = await authnow.currentUser;
    try
    {
      await dbref_for_cloud.collection(usernow.email.toString()).doc(docName).update({fieldName:valueOfField}).whenComplete(() => print("Done"));
    }
    catch(E)
    {
      Map<String,dynamic> setAMap = {"a":"a"};
      await dbref_for_cloud.collection(usernow.email.toString()).doc(docName).set(setAMap).whenComplete(() => print('Okay'));
    }
  }

  void setDataForFirstTime(int avgLimit,DateTime dateStarted,int maxLimit,double moneyLimit,double costOfOne)async
  {
    final FirebaseAuth authnow = FirebaseAuth.instance;
    User usernow;
    usernow = await authnow.currentUser;

    DateTime dateNow = DateTime.now();
    Duration temp = dateNow.difference(dateStarted);
    Map<String,dynamic> appDetailsMap ={
      "avgLimit":avgLimit,
      "dateStarted":dateStarted,
      "maxLimit":maxLimit,
      "costOfOne":costOfOne,
      "dailyCounter":0,
      "dayNow":dateNow.day,
      "informDoc":false,
      "listCounter":7,
      "moneyLimit":moneyLimit,
      "moneySpentMonth":0,
      "monthNow":dateNow.month,
      "totalSmoked":(temp.inDays)*avgLimit,
      "totalSmokedMonth":0,
    };
    await dbref_for_cloud.collection(usernow.email.toString()).doc("appDetails").set(appDetailsMap);

    Map<String,dynamic> listDetailsMap ={
      "count0":avgLimit,
      "count1":avgLimit,
      "count2":avgLimit,
      "count3":avgLimit,
      "count4":avgLimit,
      "count5":avgLimit,
      "count6":avgLimit,
    };
    await dbref_for_cloud.collection(usernow.email.toString()).doc("listDetails").set(listDetailsMap);


  }

  void updateDatawithMap(String docName,Map<dynamic,dynamic> mapVal) async
  {
    final FirebaseAuth authnow = FirebaseAuth.instance;
    User usernow;
    usernow = await authnow.currentUser;

    await dbref_for_cloud.collection(usernow.email.toString()).doc(docName).update(mapVal).whenComplete(() => print('Completed'));
  }



  Future getBestCardiologist(String city)async
  {
      Uri urlCard = Uri.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=best+cardiologist+in+${city}&key="+key);
      Response responseForCardio = await get(urlCard);
      Map cardioMap = jsonDecode(responseForCardio.body);
      int max_ratings_cardio = 0;
      int indexCardio = 0;
      for(int i = 0;i<cardioMap['results'].length;i++)
      {
        if(cardioMap['results'][i]['user_ratings_total']>max_ratings_cardio)
        {
          max_ratings_cardio = cardioMap['results'][i]['user_ratings_total'];
          indexCardio = i ;
        }
      }
      //print(cardioMap['results'][indexCardio]);
        Uri urlCardRes = Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=${cardioMap['results'][indexCardio]['place_id']}&key="+key);
        Response responseForCardiowithID = await get(urlCardRes);
        Map<String,dynamic> bestcardioMap = jsonDecode(responseForCardiowithID.body);
        return bestcardioMap;
  }

  Future getBestOncologist(String city)async
  {
      Uri urlOnco = Uri.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=best+oncologist+in+${city}&key="+key);
      Response responseForOnco = await get(urlOnco);
      Map oncoMap = jsonDecode(responseForOnco.body);
      int max_ratings_onco = 0;
      int indexOnco = 0;
      for(int i = 0;i<oncoMap['results'].length;i++)
      {
        if(oncoMap['results'][i]['user_ratings_total']>max_ratings_onco)
        {
          max_ratings_onco = oncoMap['results'][i]['user_ratings_total'];
          indexOnco = i ;
        }
      }
      //print(oncoMap['results'][indexOnco]);
      Uri urlOncoRes = Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=${oncoMap['results'][indexOnco]['place_id']}&key="+key);
      Response responseForOncowithID = await get(urlOncoRes);
      Map bestOncoMap = jsonDecode(responseForOncowithID.body);
      return bestOncoMap;
  }

  Future getBestRehab(String city)async
  {
    Uri urlRehab = Uri.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=best+rehabilitaion+in+${city}&key="+key);
    Response responseForRehab = await get(urlRehab);
    Map rehabMap = jsonDecode(responseForRehab.body);
    int max_ratings_Rehab = 0;
    int indexRehab = 0;
    for(int i = 0;i<rehabMap['results'].length;i++)
    {
      if(rehabMap['results'][i]['user_ratings_total']>max_ratings_Rehab)
      {
        max_ratings_Rehab = rehabMap['results'][i]['user_ratings_total'];
        indexRehab = i ;
      }
    }
    //print(rehabMap['results'][indexRehab]);

    Uri urlRehabRes = Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=${rehabMap['results'][indexRehab]['place_id']}&key="+key);
    Response responseForRehabwithID = await get(urlRehabRes);
    Map bestRehabMap = jsonDecode(responseForRehabwithID.body);
    return bestRehabMap;
  }

}
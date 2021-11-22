import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:chantix/homepage.dart';


List<double> cigaretteSmokedInList = [];
List<double> lifeLostInList = [];
double maxLifeLostValue = 0;
List<double> moneySpentInList = [];
double maxMoneyValue = 0;


class GraphView extends StatefulWidget {
  @override
  _GraphViewState createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {


  setDataForLifeReducedGraph() async
  {
    cigaretteSmokedInList = [];
    lifeLostInList = [];
    moneySpentInList = [];
    int j = 0 ;
    for(int i = infoMap['listCounter']-7;i<infoMap['listCounter'];i++)
      {
        cigaretteSmokedInList.insert(j, infoMap['count$i'].toDouble());
        lifeLostInList.insert(j, double.parse((infoMap['count$i']*11/60.toDouble()).toStringAsFixed(2)));
        moneySpentInList.insert(j,  double.parse((infoMap['count$i']*infoMap['costOfOne'].toDouble()).toStringAsFixed(2)));
        j++;
      }
  }


  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    setDataForLifeReducedGraph();
  }

  bool checkOverspending()
  {
    if(infoMap['moneySpentMonth']>=infoMap['moneyLimit'])
    {
      return true;
    }
    else
    {
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 15),
              child: Text('ANALYSIS',style: TextStyle(color: Colors.red[900],fontSize: 25,fontWeight: FontWeight.w300,),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
              child: Text('Life you lost due to smoking in past week',style: TextStyle(color: Colors.grey,fontSize: 16,fontWeight: FontWeight.w300,),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
              child: Text('(in Hours)',style: TextStyle(color: Colors.grey[700],fontSize: 16,fontWeight: FontWeight.w500),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
              child: Text('Tap on the graph line to see the values',style: TextStyle(color: Colors.grey[800],fontSize: 16,fontWeight: FontWeight.w400),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: LineChartSample2(),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
              child: Text('Money spent on smoking in past week',style: TextStyle(color: Colors.grey[600],fontSize: 16,fontWeight: FontWeight.w300),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 0),
              child: Text('SCROLL DOWN',style: TextStyle(color: Colors.red[800],fontSize: 16,fontWeight: FontWeight.w500),),
            ),
            LineChartSample1(),
            //Lottie.network("https://assets5.lottiefiles.com/packages/lf20_GWhY6Y.json",),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(checkOverspending()?Icons.warning_amber_rounded:Icons.attach_money,size: 50,color: Colors.red[200],),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(checkOverspending()?'You are overspending this month':'Money spent this month',style: TextStyle(color: Colors.red[800],fontSize: 14),),
                      Text('${infoMap['moneySpentMonth'].toStringAsFixed(2)}',style: TextStyle(color: Colors.red[700],fontSize: 20),),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Icon(Icons.attach_money,size: 50,color: Colors.green[200],),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Money spent till date',style: TextStyle(color: Colors.green[800],fontSize: 14),),
                      Text('${(infoMap['totalSmoked']*infoMap['costOfOne']).toStringAsFixed(2)}',style: TextStyle(color: Colors.green[700],fontSize: 20,),),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}




class LineChartSample1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: LineChart(
                    sampleData2(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchSpotThreshold: 30,
        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: EdgeInsets.all(10),
          tooltipBgColor: Colors.white,
          showOnTopOfTheChartBoxArea: true,
          tooltipRoundedRadius: 10,
          tooltipMargin: -40,
        )
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w900
          ),
          margin: 5,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
              case 5:
                return '5';
              case 6:
                return '6';
              case 7:
                return '7';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xD2000000),
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'D';
              case 2:
                return 'N';
              case 3:
                return 'E';
              case 4:
                return 'P';
              case 5:
                return 'S';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Colors.brown,
              width: 0,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 8,
      maxY: findMaxMoney(),
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  double findMaxMoney()
  {
    maxMoneyValue = moneySpentInList[0];
    for(int i =0 ;i<lifeLostInList.length;i++)
    {
      if(moneySpentInList[i]>=maxMoneyValue)
      {
        maxMoneyValue = moneySpentInList[i];
      }
    }
    return maxMoneyValue*1.5;
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(1, moneySpentInList[0]),
          FlSpot(2, moneySpentInList[1]),
          FlSpot(3, moneySpentInList[2]),
          FlSpot(4, moneySpentInList[3]),
          FlSpot(5, moneySpentInList[4]),
          FlSpot(6, moneySpentInList[5]),
          FlSpot(7, moneySpentInList[6]),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0xBC1F1F1F),
        ],
        barWidth: 1.7,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true,),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }
}

class LineChartSample2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartSample2State();
}

class LineChartSample2State extends State<LineChartSample2> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: LineChart(
                  sampleData3(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  double findMax()
  {
    maxLifeLostValue = lifeLostInList[0];
    for(int i =0 ;i<lifeLostInList.length;i++)
    {
      if(lifeLostInList[i]>=maxLifeLostValue)
      {
        maxLifeLostValue = lifeLostInList[i];
      }
    }
    return maxLifeLostValue*1.5;
  }

  LineChartData sampleData3() {

    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: EdgeInsets.all(10),
            tooltipBgColor: Colors.white,
            showOnTopOfTheChartBoxArea: true,
            tooltipRoundedRadius: 10,
            tooltipMargin: -40,
          )
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: false,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          margin: 5,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
              case 5:
                return '5';
              case 6:
                return '6';
              case 7:
                return '7';
              case 8:
                return '8';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xffaf2a2a),
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'S';
              case 2:
                return 'R';
              case 3:
                return 'U';
              case 4:
                return 'O';
              case 5:
                return 'H';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Colors.brown,
              width: 0,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 8,
      maxY: findMax(),
      minY: 0,
      lineBarsData: linesBarData3(),
    );
  }

  List<LineChartBarData> linesBarData3() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(0.5, lifeLostInList[0]),
          FlSpot(1, lifeLostInList[1]),
          FlSpot(2, lifeLostInList[2]),
          FlSpot(3, lifeLostInList[3]),
          FlSpot(4, lifeLostInList[4]),
          FlSpot(6, lifeLostInList[5]),
          FlSpot(7, lifeLostInList[6]),
          FlSpot(7.5, lifeLostInList[6]),
        ],
        isCurved: true,
        curveSmoothness: 0.200,
        colors: const [
          Color(0xFFA53333),
        ],
        barWidth: 2.3,
        isStrokeCapRound: false,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),

    ];
  }
}
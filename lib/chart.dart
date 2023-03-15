import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dart:math' as math;
class LiveChartWidget extends StatefulWidget {
  const LiveChartWidget({Key? key}) : super(key: key);
  @override
  _LiveChartWidgetState createState() => _LiveChartWidgetState();
}

class _LiveChartWidgetState extends State<LiveChartWidget> {
  String _counter1 = ''; //temp
  String _counter2 = ''; //humid
  List<List<dynamic>> _data = [];
  late Timer _timer;
  void _loadCsv() async{
    final _rawData = await rootBundle.loadString("assets/sample.csv");
    List<List<dynamic>> _listData = const CsvToListConverter().convert(_rawData);
    setState(() {
      _data = _listData;

    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }


  void _startTimer() {
    chartData = getChartData();
    _loadCsv();
    int i=1;
    Timer.periodic(const Duration(seconds: 5), updateDataSource);
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _counter1 = _data[i][0].toString();//math.Random().nextInt(5) + 29;
        _counter2 = _data[i][1].toString();//math.Random().nextInt(10) + 32;
        i++;
      });
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 42),
      LiveData(1, 43),
      LiveData(2, 45),
      LiveData(3, 45),
      LiveData(4, 43),
      LiveData(5, 44),
      LiveData(6, 45),
      LiveData(7, 48),
      LiveData(8, 49),
      LiveData(9, 41),
    ];
  }


  int time = 10;
  updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, math.Random().nextInt(5) + 32));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slave device Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        children: [
          Container(
            height: 300,
            child: SfCartesianChart(
              series: [
                LineSeries<LiveData, int>(
                  onRendererCreated: (ChartSeriesController controller) {
                    _chartSeriesController = controller;
                  },
                  dataSource: chartData,
                  xValueMapper: (LiveData data, _) => data.time,
                  yValueMapper: (LiveData data, _) => data.speed,
                ),
              ],
              primaryXAxis: NumericAxis(
                majorGridLines: MajorGridLines(width: 1),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                interval: 2,
                title: AxisTitle(text: 'Time(seconds)'),
              ),
              primaryYAxis: NumericAxis(
                majorGridLines: MajorGridLines(width: 1),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                interval: 2,
                title: AxisTitle(text: 'Mositure content(%)'),
              ),
            ),
          ),
          //insert other containers here below
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade200,
              ),

            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.thermostat, color: Colors.red, size: 120,),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Text('Temperature : $_counter1 C'),
                ),
                SizedBox(height: 15),
                Icon(Icons.water_drop, color: Colors.blue,size: 120,),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Text('Humidity : $_counter2 %'),
                ),
              ],
            ),
          ),

          Container(

            margin: const EdgeInsets.only(top: 10),
            height: 500,
            width: 500,

            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/farm.jpg'),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade200,
              ),

            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 250,
                  right: 100,
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.place, color: Colors.red, size: 40),
                        Text('Device - 1 (ID: 56xx21)', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 120,
                  right: 245,
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.place, color: Colors.black, size: 40),
                        Text('Device -2 (ID: 56XX27)',style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(

            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade200,
              ),

            ),
            margin: const EdgeInsets.only(top: 10),
            height: 75,
            width: 75,
            child: Center(
              child: Column(
                children: [
                  Image.network('https://cdn-icons-png.flaticon.com/128/5052/5052300.png'),
                  Text('Soil type : red soil'),
                  SizedBox(height: 30),
                  Image.network('https://cdn-icons-png.flaticon.com/128/3944/3944289.png'),
                  Text('Crop : Arecanut'),
                ],
              ),
            ),
          ),
          Container(

            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade200,
                )
            ),
            margin: const EdgeInsets.only(top: 10),
            height: 75,
            width: 75,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Generic Information', style: TextStyle(fontWeight: FontWeight.bold), ),
                  SizedBox(height: 60),
                  Text('Number of crops: 100'),
                  Text('Area of the plot: 120 sq m'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LiveData {
  final int time;
  final num speed;
  LiveData(this.time, this.speed);
}

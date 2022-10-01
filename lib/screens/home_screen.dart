import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    print(await Geolocator.getCurrentPosition());
  }

  final List<String> qualityParams = [
    "TDS",
    "TSS",
    "Turbidity",
    "pH",
    "Water Temperature",
    "Dissolved O2",
  ];
  final List<Map> qualityParameters = [
    {"name": "TDS"},
  ];

  bool isLoading = true;

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await Dio().get('http://43.204.238.31/quality/getAllData');
      deserializeJSON(response.data["quality"]);
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  List<Reading> readingObjects = [];

  void deserializeJSON(List readings) {
    int count = 0;
    for (Map reading in readings) {
      if (count == 15) break;
      count++;

      readingObjects.add(
        Reading(
          atTemp: reading["atmosphericTemperature"],
          waterTemp: reading["waterTemperature"],
          turbidity: reading["turbidity"],
          tds: reading["tds"],
          tss: reading["tss"],
          pH: reading["pH"],
          spO2: reading["disOxygen"],
          timestamp: reading["createdAt"],
        ),
      );
    }
  }

  @override
  void initState() {
    //_determinePosition();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF666CDB),
        centerTitle: true,
        title: Text(
          "TORQ - RiG'22",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              GoogleSignIn().signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, "login", (Route<dynamic> route) => false);
            },
            icon: Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Consolidated Score:",
                        style: TextStyle(
                          color: Color(0xFF4F4D76),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: SleekCircularSlider(
                          innerWidget: (double value) {
                            return Center(
                              child: Text(
                                value.toStringAsFixed(0) + " / 10",
                                style: TextStyle(
                                  color: Color(0xFF4F4D76),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            );
                          },
                          appearance: CircularSliderAppearance(
                            size: 250,
                            customWidths: CustomSliderWidths(
                              trackWidth: 17,
                              progressBarWidth: 17,
                            ),
                            customColors: CustomSliderColors(
                              trackColor: Color(0xFFF2F8FF),
                              progressBarColor: Color(0xFF7671FF),
                              dotColor: Colors.transparent,
                            ),
                          ),
                          min: 0,
                          max: 10,
                          initialValue: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Detailed Analysis:",
                    style: TextStyle(
                      color: Color(0xFF4F4D76),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 250,
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(
                        qualityParams.length,
                        (index) => Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "993",
                                style: TextStyle(
                                  color: Color(0xFF4F4D76),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                qualityParams[index],
                                style: TextStyle(
                                  color: Color(0xFF4F4D76),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        "Drinkable",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 35),
                  child: Text(
                    "Historical Analysis:",
                    style: TextStyle(
                      color: Color(0xFF4F4D76),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SfCartesianChart(
                  // Initialize category axis
                  primaryXAxis: CategoryAxis(
                    arrangeByIndex: true,
                  ),

                  series: <LineSeries<Reading, String>>[
                    LineSeries<Reading, String>(
                      // Bind data source
                      dataSource: readingObjects,
                      xValueMapper: (Reading reading, _) =>
                          reading.timestamp.day.toString(),
                      yValueMapper: (Reading reading, _) =>
                          reading.aquamanScore,
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
    );
  }
}

class Reading {
  late double atTemp;
  late double waterTemp;
  late double turbidity;
  late double tds;
  late double tss;
  late double pH;
  late double spO2;
  late DateTime timestamp;
  late double aquamanScore;
  Reading(
      {required String atTemp,
      required String waterTemp,
      required String turbidity,
      required String tds,
      required String tss,
      required String pH,
      required String spO2,
      required String timestamp}) {
    this.atTemp = double.parse(atTemp);
    this.waterTemp = double.parse(waterTemp);
    this.tds = double.parse(tds);
    this.tss = double.parse(tss);
    this.pH = double.parse(pH);
    this.turbidity = double.parse(turbidity);
    this.spO2 = double.parse(spO2);
    this.timestamp = DateTime.parse(timestamp);
    calcAquamanScore();
  }

  void calcAquamanScore() {
    this.aquamanScore = this.turbidity + this.waterTemp;
  }
}

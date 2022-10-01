import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class HomeScreen extends StatefulWidget {
  final bool initialSignIn;
  HomeScreen(this.initialSignIn);
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

  void fetchData() async {}

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
                // Container(
                //   padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                //   decoration: BoxDecoration(
                //     color: Color(0xBB666CDB),
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: Column(
                //     children: List.generate(
                //       qualityParams.length,
                //       (index) {
                //         return Column(
                //           children: [
                //             Container(
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Text(
                //                     qualityParams[index],
                //                     style: TextStyle(
                //                       fontSize: 16,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                   Text(
                //                     "2829",
                //                     style: TextStyle(
                //                       fontSize: 16,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.symmetric(
                //                 vertical: 15,
                //               ),
                //               child: Divider(),
                //             ),
                //           ],
                //         );
                //       },
                //     ),
                //   ),
                // ),
                // Container(
                //   height: 80,
                //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                //   decoration: BoxDecoration(
                //     color: Colors.green,
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         "Rating : ",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 25,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       Text(
                //         "9.8 / 10",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 25,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                //   child: Text(
                //     "Water is fit for drinking and other consumption purposes as well",
                //     style: TextStyle(
                //       fontSize: 18,
                //     ),
                //   ),
                // ),
              ],
            ),
    );
  }
}

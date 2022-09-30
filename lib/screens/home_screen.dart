import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF666CDB),
        centerTitle: true,
        title: Text(
          "TORQ - RIG'22",
        ),
      ),
      body: Column(
        children: [
          Text(
            "Hi Kannan",
          ),
        ],
      ),
    );
  }
}

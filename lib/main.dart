import 'package:flutter/material.dart';
import 'pages/select_flight_screen.dart'; // Import màn hình đã tách ra

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectFlightScreen(), // Điều hướng đến màn hình "Tìm kiếm chuyến bay"
    );
  }
}

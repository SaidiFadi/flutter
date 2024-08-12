import 'package:delivery_app/screens/login_screen.dart';
import 'package:delivery_app/utils/delivery_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
    runApp(
    ChangeNotifierProvider(
      create: (context) => DeliveryData(),
      child:  DeliveryApp(),
    ),
  );
}

class DeliveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginView(),  // Updated this line
    );
  }
}
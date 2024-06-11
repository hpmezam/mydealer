import 'package:flutter/material.dart';
import 'package:mydealer/views/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'myDe@ler',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // useMaterial3: false,
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen());
  }
}

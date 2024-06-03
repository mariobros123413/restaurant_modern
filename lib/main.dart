import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_modern/comanda/comanda_create_widget.dart';
import 'package:restaurant_modern/home/home_page_model.dart';
import 'package:restaurant_modern/home/home_page_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<HomePageModel>(
        create: (_) => HomePageModel(),
      ),
      ChangeNotifierProvider<ComandaCreateModel>(
        create: (_) => ComandaCreateModel(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  String _response = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Modern',
      theme: ThemeData(
          // Configura el tema
          ),
      home: HomePageWidget(),
    );
  }
}

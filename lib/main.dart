import 'package:e_cure_app/constants.dart';
import 'package:e_cure_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main()async {
  // Set the status bar color to blue
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    systemStatusBarContrastEnforced: true,
    statusBarIconBrightness: Brightness.dark
  ));

  if(Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  runApp(

      const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecure App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        primarySwatch: primaryColor,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,

          )
        )

      ),
       initialRoute: '/login',
       routes: {
          '/login' :  (context) =>  LoginPage(),

       },
      home: LoginPage(),
    );
  }
}





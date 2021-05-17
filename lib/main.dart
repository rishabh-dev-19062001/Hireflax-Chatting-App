import 'package:chatting_app/helper/authenticate.dart';
import 'package:chatting_app/helper/helperfunctions.dart';
import 'package:chatting_app/views/chatRoomScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // bool userIsLoggedIn = false;
  //
  // @override
  // void initState() {
  //   var loggedInState = getLoggedInState();
  //   super.initState();
  // }
  //
  // getLoggedInState() async{
  //   await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
  //     setState(() {
  //       userIsLoggedIn = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
        primarySwatch: Colors.amber,
      ),
      home: Authenticate() /*userIsLoggedIn ? ChatRoom() :Authenticate()*/ ,
    );
  }
}

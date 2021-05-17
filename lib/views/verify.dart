import 'dart:async';

import 'package:chatting_app/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';


class VerifyScreen extends StatefulWidget {

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {

  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();

    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryAppBar2(context),
      body: Center(
        child: Text('An Email has been send to ${user.email} \n\nplease verify it and Come again',
          textAlign: TextAlign.center, style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            fontFamily: 'Open Sans',
            fontSize: 20,

        ),),),
    );
  }

  Future<void> checkEmailVerified() async{

    user = auth.currentUser;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();


        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ChatRoom()
            ));
    }
  }
}

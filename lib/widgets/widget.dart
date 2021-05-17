import 'package:chatting_app/helper/authenticate.dart';
import 'package:chatting_app/helper/constants.dart';
import 'package:chatting_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  AuthMethods authMethods = new AuthMethods();
  return AppBar(
    automaticallyImplyLeading: false,
    title: Image.asset("assets/images/logohireflax.png",
      height: 30,),
    actions: [
      GestureDetector(
        onTap: () {
          authMethods.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Authenticate()));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Icon(Icons.logout),
        ),
      ),
    ],
  );
}

Widget secondaryAppBar(BuildContext context){

    return AppBar(
      title: Image.asset("assets/images/logohireflax.png",
        height: 30,),

    );
}

Widget secondaryAppBar2(BuildContext context){

  return AppBar(
    titleSpacing: -10.0,
    title: Image.asset("assets/images/logohireflax.png",
      height: 30,),

  );
}

Widget chatScreenAppBar(BuildContext context){

  return AppBar(
    titleSpacing: -10.0,
    title: Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.0,
            child: Text(Constants.myName[0].toUpperCase(), style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w400,


            ),),
            backgroundColor: Colors.white70,

          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7.0),
              // child: Text(Constants.myName, style: TextStyle(
              //   fontSize: 18.0,
              //   fontWeight: FontWeight.w500,
              //   color: Colors.white60
              // ),)
          )
        ],
      ),
    ),
  );
}
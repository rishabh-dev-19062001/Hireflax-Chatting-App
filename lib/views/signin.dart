import 'package:chatting_app/services/auth.dart';
import 'package:chatting_app/services/database.dart';
import 'package:chatting_app/views/chatRoomScreen.dart';
import 'package:chatting_app/views/forgotPassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:chatting_app/helper/helperfunctions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chatting_app/helper/authenticate.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  QuerySnapshot snapshotUserInfo;

  signMeIn(){
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      setState(() {
        isLoading = true;

      });

      databaseMethods.getUserByEmail(emailTextEditingController.text)
          .then((value){
            snapshotUserInfo = value;
            HelperFunctions
                .saveUserNameSharedPreference(snapshotUserInfo
                .docs[0]
                .data()["name"]);
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((value){

            if(value != null){
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=> ChatRoom()));
            }
            else{
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=> Authenticate()));
              Fluttertoast.showToast(
                  msg: "Please Enter Valid Email or Password",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black26,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:  appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator(),),
      ) :SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/mainhireflax.png", height: 250,),
                SizedBox(height: 30.0,),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) => !EmailValidator.validate(val, true) ? 'Please provide valid email.': null,
                        controller: emailTextEditingController,
                        decoration: InputDecoration(
                            hintText: "Email"
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) => val.length > 6 ? null : "Password should be more than 6 character",
                        controller: passwordTextEditingController,
                        decoration: InputDecoration(
                            hintText: "Password"
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      child: Text("Forgot Password"),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                GestureDetector(
                  onTap: (){
                    signMeIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          // const Color(0xffffc137),
                          // const Color(0xfff6db3d),
                          const Color(0xff152439),
                          const Color(0xff25436c),
                        ]
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text("Sign In", style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),),
                  ),
                ),
                SizedBox(height: 30.0,),
                // Container(
                //   alignment: Alignment.center,
                //   width: MediaQuery.of(context).size.width,
                //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                //   child: Text("Sign In with Google", style: TextStyle(
                //     fontSize: 15.0,
                //   ),),
                // ),
                SizedBox(height: 30.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account? ", style: TextStyle(
                      fontSize: 12.0,
                    ),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Register Now", style: TextStyle(
                          fontSize: 12.0,
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

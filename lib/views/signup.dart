import 'package:chatting_app/helper/helperfunctions.dart';
import 'package:chatting_app/services/auth.dart';
import 'package:chatting_app/services/database.dart';
import 'package:chatting_app/views/verify.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';


import 'chatRoomScreen.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp(){


    if(formKey.currentState.validate()){

      Map<String, String> userInfo = {
        "name" : userNameTextEditingController.text,
        "email" :emailTextEditingController.text
      };
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);

      setState(() {
        isLoading = true;

      });

      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
            // return print("$val");

        databaseMethods.uploadUserInfo(userInfo);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        String userNameText = userNameTextEditingController.text;
        String emailIdText = emailTextEditingController.text;
        String passwordText = passwordTextEditingController.text;

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VerifyScreen()
            ));


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
                Image.asset("assets/images/mainhireflax.png", height: 200,),
                SizedBox(height: 30.0,),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length<=6 ? "Please provide username/username should be equal to or more than 6 character": null;
                        },
                        controller: userNameTextEditingController,
                        decoration: InputDecoration(
                            hintText: "Name"
                        ),
                      ),
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
                SizedBox(height: 20.0,),
                GestureDetector(
                  onTap: signMeUp,
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
                    child: Text("Sign Up", style: TextStyle(
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
                //   child: Text("Sign Up with Google", style: TextStyle(
                //     fontSize: 15.0,
                //   ),),
                // ),
                SizedBox(height: 30.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have account? ", style: TextStyle(
                      fontSize: 12.0,
                    ),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Login Now", style: TextStyle(
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

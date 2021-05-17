import 'package:chatting_app/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController emailTextEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  forgotPassword(){

    if(formKey.currentState.validate()){
      authMethods.resetPass(emailTextEditingController.text);
      emailTextEditingController.text = "";

      Fluttertoast.showToast(
          msg: "Reset Link is sended to your given email: ${emailTextEditingController.text}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black26,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:  appBarMain(context),
      body: Container(
        child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/mainhireflax.png", height: 250,),
                SizedBox(height: 100.0,),
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
                    ],
                  ),
                ),
                SizedBox(height: 15.0,),

                SizedBox(height: 20.0,),
                GestureDetector(
                  onTap: (){
                    forgotPassword();
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
                    child: Text("Reset Password", style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),),
                  ),
                ),

                SizedBox(height: 50.0,),
              ],
            ),
          ),
        ),
      ),
    )
    );
  }
}

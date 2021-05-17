import 'package:chatting_app/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users _userFromFirebaseUser(User user){
    return user !=null ? Users(userId: user.uid) : null;

  }

  Future signInWithEmailAndPassword(String email, String password) async{

    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);

    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{

    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User firebaseuser = result.user;
      return _userFromFirebaseUser(firebaseuser);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

  }

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}
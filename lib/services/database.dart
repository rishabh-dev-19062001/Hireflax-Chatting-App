import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseMethods{

  getUserByUsername(String username) async{
    return await FirebaseFirestore.instance.collection("ChattingUsers")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByEmail(String email) async{
    return await FirebaseFirestore.instance.collection("ChattingUsers")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("ChattingUsers")
        .add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId).set(chatRoomMap).catchError((e){
          print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
        
  }

  getConversationMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time")
        .snapshots();

  }
  
  getChatRooms(String userName) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
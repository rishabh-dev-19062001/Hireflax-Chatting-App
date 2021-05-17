import 'package:chatting_app/helper/constants.dart';
import 'package:chatting_app/services/database.dart';
import 'package:chatting_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'conversation_screen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController searchTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot searchSnapshot;
  initiateSearch(){
    databaseMethods.getUserByEmail(searchTextEditingController.text)
        .then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }


  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
            userName: searchSnapshot.docs[index].data()["name"],
            userEmail: searchSnapshot.docs[index].data()["email"],
          );
        }) : Container();
  }

  /// Create chatroom, send user to conversation screen, push Replacement
  createChatroomAndStartConversation({String userName}){

    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatroomId" : chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);

      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)));
    }else{
      print("You cannot send message to your self");
    }
  }

  Widget SearchTile({String userName, String userEmail}){
    return Container(
      color: Colors.white70,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22.0,
            child: Text(userName[0].toUpperCase(), style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w400,


            ),),
            backgroundColor: Colors.white70,

          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: TextStyle(
                  fontSize: 17.0,
                ),),
                Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                Text(userEmail)
              ],
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(
                userName: userName
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: secondaryAppBar(context),
      body: Container(
        color: Colors.amber,
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Search Email...",
                          border: InputBorder.none,
                        ),
                      ),
                  ),
                  // Image.asset("assets/images/search_icon.png", width: 25,),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        child: Icon(
                          Icons.search,
                          size: 30,
                        )
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}


getChatRoomId(String a, String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}

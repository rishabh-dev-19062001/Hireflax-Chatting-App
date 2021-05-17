import 'package:chatting_app/helper/constants.dart';
import 'package:chatting_app/helper/helperfunctions.dart';
import 'package:chatting_app/services/database.dart';
import 'package:chatting_app/views/conversation_screen.dart';
import 'package:chatting_app/views/search.dart';
import 'package:chatting_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget ChatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return ChatRoomTile(snapshot.data.docs[index].data()["chatroomId"].toString()
            .replaceAll("_", "")
            .replaceAll(Constants.myName, ""),
                snapshot.data.docs[index].data()["chatroomId"]
            );
          },
        ) : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBarMain(context),
      body: ChatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search, color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Search()
          ));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomId;
  ChatRoomTile(this.username, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.0,
              child: Text(username[0].toUpperCase(), style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w400,


              ),),
              backgroundColor: Colors.amberAccent,

            ),
            SizedBox(width: 10.0,),
            Text(username, style: TextStyle(
              fontSize: 16.0,
            ),),
          ],
        ),
      ),
    );
  }
}


import 'package:chatting_app/helper/constants.dart';
import 'package:chatting_app/services/database.dart';
import 'package:chatting_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextEditingController = new TextEditingController();


  Stream chatMessageStream;

  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return MessageTile(snapshot.data.docs[index].data()["message"],
            snapshot.data.docs[index].data()["sendBy"] == Constants.myName);
          }
        ) : Container();
      },
    );
  }

  sendMessage(){

    if(messageTextEditingController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message": messageTextEditingController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
    };
    databaseMethods.addConversationMessages(widget.chatRoomId,messageMap);
    messageTextEditingController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chatScreenAppBar(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      height: 50.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: TextField(
                        maxLines: null,
                        expands: true,
                        controller: messageTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Type Your Message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
                    },
                    child: Container(
                        child: Icon(
                          Icons.send,
                          size: 30,
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String Message;
  final bool isSendByMe;

  MessageTile(this.Message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 14 , right: isSendByMe ? 14:0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:16 ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xffF4F4F4),
              const Color(0xffFAEA8E),
            ]
                : [
              const Color(0xffFCFF2E),
              const Color(0xffE9C62C),
            ]
          ),
          borderRadius: isSendByMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
              )
              : BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          )
        ),
        child: Text(Message),
      ),
    );
  }
}

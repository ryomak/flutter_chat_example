import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_clone/components/rounded_button.dart';
import 'package:flutter_line_clone/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_line_clone/model/screen/ChatScreenArguments.dart';
import 'package:flutter_line_clone/screens/chat_screen.dart';
import 'package:flutter_line_clone/screens/init_screen.dart';

final _firestore = Firestore.instance;
class RoomListScreen extends StatefulWidget {
  static String id = 'room_list_screen';
  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String roomName;
  List<String> rooms = new List<String>();
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getRoomList();
  }

  void getRoomList() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        final users = await _firestore.collection('users')
            .document(loggedInUser.uid).get();
        setState(() {
          rooms = List.from(users['rooms']);
        });
      }else{
        Navigator.pushNamed(context, InitScreen.id);
      }
    }catch (e) {
      Navigator.pushNamed(context, InitScreen.id);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, InitScreen.id);
              }),
        ],
        title: Text('MY ROOM'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: rooms.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Room(rooms[index]);
                  }),
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  roomName = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your room name'
                ),
              ),
              RoundedButton(
                  title: "Join Room",
                  color: Colors.blueAccent,
                  onPressed: () {
                    if (!rooms.contains(roomName)){
                      rooms.add(roomName);
                    }
                    _firestore.collection('users')
                        .document(loggedInUser.uid).updateData({
                      'rooms':rooms,
                    });
                    Navigator.pushNamed(
                        context,
                        ChatScreen.id,
                        arguments: ChatScreenArguments(roomName)
                    );
                  }),
          ]
        ),
      ),
    );
  }
}


class Room extends StatelessWidget {
  const Room(this.room);

   final String room;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.lightBlue),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.white24))),
              child: Icon(Icons.room, color: Colors.white),
            ),
            title: Text(
              room,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
            onTap:(){
              Navigator.pushNamed(
                  context,
                  ChatScreen.id,
                  arguments: ChatScreenArguments(room)
              );
            },
        ),
        ),
      ),
    );
  }
}
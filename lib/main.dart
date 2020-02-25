import 'package:flutter/material.dart';
import 'package:flutter_line_clone/screens/chat_screen.dart';
import 'package:flutter_line_clone/screens/init_screen.dart';
import 'package:flutter_line_clone/screens/login_screen.dart';
import 'package:flutter_line_clone/screens/registration_screen.dart';
import 'package:flutter_line_clone/screens/room_list_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      */
      initialRoute: InitScreen.id,
      routes: {
        InitScreen.id: (context) => InitScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ChatScreen.id : (context) => ChatScreen(),
        RoomListScreen.id: (context) => RoomListScreen()
      },

    );
  }
}
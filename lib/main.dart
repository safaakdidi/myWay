import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ppp/screens/authenticate/sign_in.dart';
import 'package:ppp/screens/wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyCAkkHN30PVPw9z3pNOLLylQ7brNLI4lkQ",
      appId: "1:668972407346:android:11c8810e27a2db17bcfa2b",
      messagingSenderId: "668972407346",
      projectId: "myway-501ea",
    ),
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final _initialization=Firebase.initializeApp();

 Color _primaryColor=HexColor('#80FF72');
 Color _accentColor=HexColor('#7EE8FA');

//Color _primaryColor=HexColor('#7EE8FA');
  //Color _accentColor=HexColor('#7CFFCB');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
             if(snapshot.connectionState!=ConnectionState.done){
               return Center(child: CircularProgressIndicator(),);
             }
        return MaterialApp(
          title: 'MyWay',
          theme: ThemeData(
            primaryColor: _primaryColor,
            accentColor: _accentColor,
            scaffoldBackgroundColor:Colors.grey.shade100 ,
            primarySwatch: Colors.grey,
          ),
          home: Wrapper(),
        );
      }
    );
  }
}

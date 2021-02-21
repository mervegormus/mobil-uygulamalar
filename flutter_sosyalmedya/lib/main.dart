import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_odev/models/post.dart';
import 'package:flutter_odev/models/user.dart';
import 'package:flutter_odev/screens/home.dart';
import 'package:flutter_odev/services/auth.dart';
import 'package:flutter_odev/services/database.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuthenticated = false;
  String testProviderText = 'Merhaba Provider!';

  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      //print('onAuthStateChanged fonksiyonu çağrıldı');

      setState(() {
        isAuthenticated = user != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

  
    return MultiProvider(
      providers: [
        Provider<String>(create: (context) => testProviderText),
        StreamProvider<FirebaseUser>(
          create: (context) => FirebaseAuth.instance.onAuthStateChanged,
        ),
        StreamProvider<User>.value(value:AuthService().user),
        StreamProvider<List<Post>>(
          create: (context) => DatabaseService().posts,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase Crud',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
      ),
    );
  }
}

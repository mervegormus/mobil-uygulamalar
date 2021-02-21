import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_odev/screens/home.dart';
import 'package:flutter_odev/screens/login.dart';
import 'package:flutter_odev/screens/my_posts.dart';
import 'package:flutter_odev/screens/profile.dart';
import 'package:flutter_odev/screens/register.dart';
import 'package:flutter_odev/services/auth.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final bool isAuthenticated = user != null;
    String email = '';

    if (isAuthenticated) {
      email = user.email;
    } else {
      email = 'Anonim';
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                '$email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile(user:user)),
                  );
              },
            ),
          ),
          if (isAuthenticated) ...[
            InkWell(
              child: ListTile(
                leading: Icon(Icons.sentiment_very_satisfied),
                title: Text('Postlarım'),
                onTap: ()  {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPosts(user:user)),
                  );
                },
              ),
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign out'),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
            ),
          ],
          if (!isAuthenticated) ...[
            InkWell(
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Login'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()),
                  );
                },
              ),
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Register'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

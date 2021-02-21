import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_odev/screens/home.dart';
import 'package:flutter_odev/screens/register.dart';
import 'package:flutter_odev/services/auth.dart';
import 'package:flutter_odev/shared/constants.dart';
import 'package:flutter_odev/shared/loading.dart';


class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _loginFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Giriş Yap'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'email'),
                        controller: _emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Lütfen email giriniz";
                          } else if (!EmailValidator.validate(value)) {
                            return "Lütfen geçerli bir email giriniz";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'şifre'),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Lütfen şifre giriniz";
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: RaisedButton(
                            child: Text("Giriş Yap"),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () async {
                              if (_loginFormKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  // Log in user by firebase auth
                                  FirebaseUser user =
                                      await _auth.logInWithEmailAndPassword(
                                          _emailController.text,
                                          _passwordController.text);
                                  if (user != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Home(),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      error = 'Bilgilerini kontrol ediniz!';
                                      loading = false;
                                    });
                                  }
                                } catch (e) {
                                  print('Hata Oluştu!!: $e');
                                }
                              }
                            }),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.0,
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('Hesabınız yok mu?'),
                      FlatButton(
                        child: Text('Kayıt ol'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_odev/screens/home.dart';
import 'package:flutter_odev/screens/login.dart';
import 'package:flutter_odev/services/auth.dart';
import 'package:flutter_odev/shared/constants.dart';
import 'package:flutter_odev/shared/loading.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _registerFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _auth = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Kayıt Ol'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _registerFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'isim'),
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Lütfen isim giriniz";
                          }
                          return null;
                        },
                      ),
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
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'doğrulama şifresi'),
                        obscureText: true,
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Şifreleriniz eşleşmiyor";
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: RaisedButton(
                            child: Text("Kayıt Ol"),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () async {
                              if (_registerFormKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  // Register user by firebase auth
                                  FirebaseUser user =
                                      await _auth.registerWithEmailAndPassword(
                                          _nameController.text,
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
                      Text('Hesabınız var mı?'),
                      FlatButton(
                        child: Text('Giriş Yap'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LogIn()),
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

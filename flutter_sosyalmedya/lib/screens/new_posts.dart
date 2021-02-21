import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_odev/screens/home.dart';
import 'package:flutter_odev/services/database.dart';
import 'package:flutter_odev/shared/constants.dart';
import 'package:flutter_odev/shared/loading.dart';
import 'package:provider/provider.dart';


class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _newPostFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final _db = DatabaseService();

   @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      appBar: AppBar(
        title: Text('NewPost'),
      ),
      body: Container(
        padding : const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
              child: Form(
                key: _newPostFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'başlık'),
                        controller: _titleController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Lütfen başlık giriniz";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'içerik'),
                        controller: _contentController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Lütfen içerik giriniz";
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: RaisedButton(
                            child: Text("Postu kaydet"),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () async {
                              if (_newPostFormKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  // Log in user by firebase auth
                                  final user = Provider.of<FirebaseUser>(
                                    context,
                                    listen:false
                                  );
                                  dynamic result =
                                      await _db.createPost(
                                          user.uid,
                                          _titleController.text,
                                          _contentController.text);

                                  if (result != null) {
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
                      
                    ],
                  ),
                
              ),
            ),
      ),
    );
  }
}

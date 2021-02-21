import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_odev/models/user.dart';
import 'package:flutter_odev/services/auth.dart';
import 'package:flutter_odev/services/database.dart';
import 'package:flutter_odev/shared/constants.dart';
import 'package:flutter_odev/shared/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class Profile extends StatefulWidget {
  Profile({Key key, @required this.user}) : super(key: key);
  final user;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _profileFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';

  final _auth = AuthService();

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userImageController = TextEditingController();

  User user;
  File _image;

  @override
  void dispose() {
    _nameController.dispose();
    _userImageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future getUser() async {
      var currentUser = await DatabaseService().getProfile(widget.user.uid);
      setState(() {
        user = currentUser;
        _nameController.text = currentUser.name;
        _userImageController.text = currentUser.userImage ?? '';
      });
    }

    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future getUser() async {
      var currentUser = await DatabaseService().getProfile(widget.user.uid);
      setState(() {
        user = currentUser;
      });
    }

    Future getImage() async {
      var image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        _image = image;
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);

      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      _userImageController.text = url.toString();
      print('Profil resmi yüklendi');

      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profil resmi yüklendi')));
    }

    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Profil'),
            ),
            body: Builder(
              builder: (context) => SingleChildScrollView(
                child: Form(
                  key: _profileFormKey,
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
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.cyanAccent[400],
                          child: ClipOval(
                            child: new SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: (_image != null)
                                  ? Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    )
                                  : (_userImageController.text != '')
                                      ? Image.network(
                                          _userImageController.text,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR8QMTmCUwPeDMiZ0pZFQqQkHCQvcWY7ECb_Lcfc4QqqS2PL9rb&usqp=CAU',
                                          fit: BoxFit.fill,
                                        ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        IconButton(
                            icon: Icon(
                              Icons.camera,
                              size: 30.0,
                            ),
                            onPressed: () {
                              getImage();
                            }),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                elevation: 4.0,
                                splashColor: Colors.blueGrey,
                                child: Text(
                                  'İptal',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                              RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                onPressed: () {
                                  uploadPic(context);
                                },
                                elevation: 4.0,
                                splashColor: Colors.blueGrey,
                                child: Text(
                                  'Resmi yükle',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ]),
                        Container(
                          margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: RaisedButton(
                              child: Text("Güncelle"),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () async {
                                if (_profileFormKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  try {
                                    await DatabaseService(uid: widget.user.uid)
                                        .editProfile(
                                      widget.user.uid,
                                      _nameController.text,
                                      _userImageController.text,
                                    );

                                    if (_passwordController.text.isNotEmpty) {
                                      FirebaseUser updatedUser =
                                          await FirebaseAuth.instance
                                              .currentUser();
                                      updatedUser
                                          .updatePassword(
                                              _passwordController.text)
                                          .then((_) {
                                            
                                        //getUser();
                                      }
                                      ).catchError((e) {
                                        print(error.toString());
                                      });
                                    }
                                    setState(() {
                                      error = 'Profil güncellendi!';
                                      loading = false;
                                    });
                                    //Navigator.pop(context);
                                  } catch (e) {
                                    setState(() {
                                      error = 'Bilgilerini kontrol ediniz!';
                                      loading = false;
                                    });
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
            ),
          );
  }
}

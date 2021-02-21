import 'package:flutter/material.dart';
import 'package:flutter_odev/models/post.dart';
import 'package:flutter_odev/screens/edit_post.dart';
import 'package:flutter_odev/screens/new_posts.dart';
import 'package:flutter_odev/screens/show_posts.dart';
import 'package:flutter_odev/services/database.dart';
import 'package:flutter_odev/shared/loading.dart';


class MyPosts extends StatefulWidget {
  MyPosts({Key key, @required this.user}) : super(key: key);
  final user;
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyPosts'),
      ),
      body: StreamBuilder<List<Post>>(
        stream: DatabaseService(uid: widget.user.uid).individualPosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post> posts = snapshot.data;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    posts[index].title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(posts[index].content),
                  trailing: PopupMenuButton(
                    onSelected: (result) async {
                      final type = result['type'];
                      final post = result['value'];
                      switch (type) {
                        case 'edit':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPost(post: post),
                            ),
                          );
                          break;
                        case 'delete':
                          DatabaseService(uid: widget.user.uid)
                              .deletePost(post.id);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                          value: {'type': 'edit', 'value': posts[index]},
                          child: Text('Düzenle')),
                      PopupMenuItem(
                          value: {'type': 'delete', 'value': posts[index]},
                          child: Text('Sil')),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowPosts(post: posts[index]),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Loading();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewPost(),
              ),
            );
          },
          tooltip: 'Yeni Post',
          child: Icon(Icons.note_add)),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task/models/posts.dart';
import 'package:task/screens/Forms/add_User.dart';
import 'package:task/screens/Forms/edit_User.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> _posts = []; //data in form of  array//

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    /*at initially when site was opened this inteState will call 
    if internet is there data will be fetch from the server else it shows 'TypeError: Failed to fetch'*/
  }

//Read///
  Future<void> _fetchPosts() async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts')); /*getting the request from the api url*/

    if (response.statusCode == 200) {
      /* success status code*/
      final data = json.decode(response.body) as List;
      final posts = data.map((json) => Post.fromJson(json)).toList();
      setState(() {
        _posts = posts; //assign to the list//
      });
    }
  }

//Delete///
  Future<void> _deletePost(Post post) async {
    final response = await http.delete(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts/${post.id}')); //when click on the delete icon it identify the id and get deleted//
    if (response.statusCode == 200) {
      // if the response is success//
      setState(() {
        _posts.remove(post); //item get removed//
      });
    }
  }

//Update//
  Future<void> _editPost(Post post) async {
    final updatedPost = await Navigator.push<Post>(
        context,
        MaterialPageRoute(
          builder: (context) => EditPostPage(
            //on click on the card it navigate to the edit page//
            post: post, //sending post as args//
          ),
        ));
    if (updatedPost != null) {
      final index = _posts.indexWhere((p) =>
          p.id ==
          updatedPost
              .id); /*if updatePost has data it perform p.id and updatedPost.id both are matches then it will update
      to data that user selected.*/
      setState(() {
        _posts[index] = updatedPost;
      });
    }
  }

//Add Post//
  Future<void> _addPost() async {
    final newPost = await Navigator.push<Post?>(
      context,
      MaterialPageRoute(builder: (context) => const AddPostPage()),
    );
    if (newPost != null) {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(Post.toJson(newPost)),
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          _posts.add(Post.fromJson(data));
          // print(_posts);
        });
      }
    }
  }

// UI to visible to the users//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rest API'),
      ),
      body: Center(
        child: ListView.builder(
            reverse: true,
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              final post = _posts[index];
              return GestureDetector(
                onTap: () => _editPost(post),
                child: Card(
                  shadowColor: const Color.fromARGB(255, 124, 124, 124),
                  elevation: 2.0,
                  key: ValueKey(post.id),
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _deletePost(post), //delete icon button//
                      )),
                ),
              );
            }),
      ),
      floatingActionButton: Container(
        width: 45,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: FloatingActionButton(
          onPressed: () {
            _addPost(); //add icon button//
          },
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
    );
  }
}

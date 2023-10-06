// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'package:task/screens.dart/favorite_screen.dart';
import 'package:task/screens.dart/post_data_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final url = 'https://jsonplaceholder.typicode.com/posts';

  List postsJson = [];
  void fetchData() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        postsJson = jsonData;
      });
    } catch (error) {
      print(error.toString());
    }
  }

  // for favorite screen data adding
  void addToFavorites(int index) {
    Map<String, dynamic> selectedPost = postsJson[index];
    FavoriteScreen.favoritePosts.add(selectedPost);
    FavoriteScreen.storeFavorite(selectedPost);
    showSnackBar('Added to Favorites');
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const SizedBox(
            width: 15,
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteScreen(),
                    ));
              },
              icon: const Icon(
                Icons.favorite_rounded,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          'DASHBOARD',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: postsJson.length,
              itemBuilder: (context, index) {
                final post = postsJson[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Card(
                    shape: Border.all(
                        color: Colors.black87, width: 3, strokeAlign: 1),
                    elevation: 5,
                    shadowColor: const Color.fromARGB(255, 37, 66, 81),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Title',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(post["title"]),
                          const Text(
                            'Body',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(post["body"]),

                          const SizedBox(
                            height: 5,
                          ),

                          // Icons for favorites
                          GestureDetector(
                            onTap: () {
                              addToFavorites(index);
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        child: const Text(
          'POST',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostDataScreen(),
            ),
          );
          if (result != null) {
            setState(() {
              postsJson.add(result);
            });
          }
        },
      ),
    );
  }
}

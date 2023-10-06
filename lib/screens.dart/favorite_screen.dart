// lib/screens/favorite_screen.dart
// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  static List<Map<String, dynamic>> favoritePosts = [];
  static CollectionReference favorites =
      FirebaseFirestore.instance.collection('favorites');

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();

  static Future<void> storeFavorite(Map<String, dynamic> favorite) async {
    try {
      await favorites.add(favorite);
      print('Favorite stored successfully.');
    } catch (error) {
      print('Failed to store favorite: $error');
    }
  }
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FavoriteScreen.favorites.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No favorites available.'));
          }

          List<Map<String, dynamic>> favoritePosts = snapshot.data!.docs
              .map<Map<String, dynamic>>((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return data;
          }).toList();

          return ListView.builder(
            itemCount: favoritePosts.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(favoritePosts[index]['id'].toString() ??
                    UniqueKey().toString()),
                onDismissed: (direction) {
                  deleteFavorite(favoritePosts[index]['id'].toString());
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: Border.all(
                        color: Colors.black87, width: 3, strokeAlign: 1),
                    elevation: 5,
                    shadowColor: const Color.fromARGB(255, 37, 66, 81),
                    child: ListTile(
                      title: Text(
                          'Title:\n${favoritePosts[index]['title'].toString()}'),
                      subtitle: Text(
                          "Body:\n${favoritePosts[index]['body'] ?? 'No body available'}"),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> deleteFavorite(String documentId) async {
    try {
      await FavoriteScreen.favorites.doc(documentId).delete();
      print('Favorite deleted successfully.');
    } catch (error) {
      print('Failed to delete favorite: $error');
    }
  }
}

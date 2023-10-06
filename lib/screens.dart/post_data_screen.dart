// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task/Comman%20Widgets/inputField.dart';

class PostDataScreen extends StatefulWidget {
  const PostDataScreen({super.key});

  @override
  State<PostDataScreen> createState() => _PostDataScreenState();
}

class _PostDataScreenState extends State<PostDataScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  // posting data
  final url = 'https://jsonplaceholder.typicode.com/posts';
  // void postData() async {
  //   final response = await post(Uri.parse(url), body: {
  //     'title': titleController.text,
  //     'body': bodyController.text,
  //     'userId': '1'
  //   });
  //   print(response.body);
  // }
  void postData() async {
    try {
      final response = await post(Uri.parse(url), body: {
        'title': titleController.text,
        'body': bodyController.text,
        'userId': '1'
      });
      if (response.statusCode == 201) {
        // Data successfully posted
        print('Data posted successfully: ${response.body}');
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.blueGrey[100],
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Column(
                    children: [
                      Text(
                        "Post Your Data",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Column(
                    children: <Widget>[
                      inputField(
                          contoller: titleController,
                          label: "Title",
                          hintText: 'Enter Your Title'),
                      inputField(
                        contoller: bodyController,
                        label: "Body",
                        hintText: 'Enter Your Description',
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: GestureDetector(
                      onTap: () {},
                      child: GestureDetector(
                        onTap: () async {
                          final response = await post(
                            Uri.parse(url), // Use your server URL here
                            body: {
                              'title': titleController.text,
                              'body': bodyController.text,
                              'userId': '1',
                            },
                          );

                          if (response.statusCode == 201) {
                            // Data successfully posted
                            print('Data posted successfully: ${response.body}');
                            // Pass the posted data back to the previous screen
                            Navigator.of(context).pop({
                              'title': titleController.text,
                              'body': bodyController.text,
                            });
                          } else {
                            // Handle posting error
                            print(
                                'Failed to post data. Status code: ${response.statusCode}');
                            print('Response body: ${response.body}');
                          }
                        },
                        child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.height * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Post',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

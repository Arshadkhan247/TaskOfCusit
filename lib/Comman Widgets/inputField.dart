// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget inputField({label, obscureText = false, hintText,contoller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        controller: contoller,
        cursorColor: Colors.grey,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          // Enable Borders
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}

import 'package:flutter/material.dart';

Widget buildTextField(String hintText, {bool obscureText = false,TextEditingController? controller}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: 8.0,
    ),
    child: TextField(
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder()
      ),
      obscureText: obscureText,
    ),
  );
}



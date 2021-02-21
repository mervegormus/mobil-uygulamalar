import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  hintText:'',
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide:BorderSide(
      color: Colors.white,
      width:2.0,
    ),
  ),
    focusedBorder: OutlineInputBorder(
    borderSide:BorderSide(
      color: Colors.cyanAccent,
      width:2.0,
    ),
  ),
);
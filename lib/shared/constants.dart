import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.blueGrey,
  filled: true,
  contentPadding: EdgeInsets.all(10.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

const textStyleAppBar = TextStyle(
  color: Colors.black
);

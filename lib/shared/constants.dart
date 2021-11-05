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

const textStyleAppBar =
    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 25);

const titleAppBar = 'Change Calculator';

const thankYou = "Thank you!";

const errorText = "Your text entry is incorrect.";

const openBillReminderText = "You still have to pay ";

const moneyBack1Text = "You get ";
const moneyBack2Text = " back!";

const instructionPriceText = "Price in ";
const instructionPayedText = "Payed in ";


const textStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16);

const buttonTextStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 20);

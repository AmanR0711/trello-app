// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum TrelloBoardBgColor {
  red(Colors.red),
  pink(Colors.pink),
  deep_orange(Colors.orange),
  yellow(Colors.yellow),
  amber(Colors.amber),
  lime(Colors.lime),
  light_green(Colors.lightGreen),
  green(Colors.green),
  teal(Colors.teal),
  cyan(Colors.cyan),
  light_blue(Colors.lightBlue),
  blue(Colors.blue),
  indigo(Colors.indigo),
  deep_purple(Colors.deepPurple),
  purple(Colors.purple),
  blue_grey(Colors.blueGrey),
  brown(Colors.brown),
  grey(Colors.grey),
  white(Colors.white),
  black(Colors.black);

  final Color color;

  const TrelloBoardBgColor(this.color);
}
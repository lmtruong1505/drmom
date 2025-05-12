import 'package:flutter/material.dart';

double widthDevice(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double heightDevice(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

bool isPortrait(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait;
}

bool isLandscape(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.landscape;
}

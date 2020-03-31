import 'package:flutter/material.dart';



class SpaceBox extends SizedBox {
  SpaceBox({double width = 1, double height = 1})
      : super(width: width, height: height);

  SpaceBox.width([double value = 1]) : super(width: value);
  SpaceBox.height([double value = 1]) : super(height: value);
}

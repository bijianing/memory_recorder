import 'package:flutter/material.dart';

enum FieldTypes
{
  Text,
  Number,
  Place,
  DateTime,
}


class FieldType {
  FieldType(this.type);
  final FieldTypes type;

  String toString() {
    return 'null';
  }
}

class FieldTypeText extends FieldType {
  FieldTypeText(type) : super(type);

  
}

class DataCenter {

  
}
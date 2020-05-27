import 'package:flutter/material.dart';
import 'package:memory_recorder/view/localization.dart';

class FieldType
{
  final int _id;
  static const FieldType TEXT = FieldType._privateConstractor(1);
  static const FieldType NUMBER = FieldType._privateConstractor(2);
  static const FieldType PLACE = FieldType._privateConstractor(3);
  static const FieldType DATETIME = FieldType._privateConstractor(4);

  static const List <FieldType> values = [TEXT, NUMBER, PLACE, DATETIME];
  static const Map _toName = {
    TEXT: 'Text', NUMBER: 'Number', PLACE: 'Place', DATETIME: 'DateTime'
  };
  static Map _toId = {
    'Text': TEXT.id, 'Number': NUMBER.id, 'Place': PLACE.id, 'DateTime': DATETIME.id
  };
  static Map _toLocalizedName;

  const FieldType._privateConstractor(this._id);

  factory FieldType(t){
    switch (t) {
      case TEXT:
      case NUMBER:
      case PLACE:
      case DATETIME:
        return FieldType._privateConstractor(t);
      default:
        return null;
    }
  }

  String get name {
    return _toName[this];
  }
  static String name2Id(String name) {
    return _toId[name];
  }

  static String toLocalizedName(BuildContext context, FieldType t) {
    if (_toLocalizedName == null) {
      _toLocalizedName = {
        TEXT: MRLocalizations.of(context).fieldTypeText,
        NUMBER: MRLocalizations.of(context).fieldTypeNumber,
        PLACE: MRLocalizations.of(context).fieldTypePlace,
        DATETIME: MRLocalizations.of(context).fieldTypeTime
      };
    }

    return _toLocalizedName[t];
  }

  int get id {
    return _id;
  }
}

class Field {
  String name;
  FieldType type;
  bool must;
  bool decimal;     // Number option
  bool multiline;   // Text option

  Field({
    this.name = '',
    this.must = false,
    this.decimal = false,
    this.multiline = false,
    this.type = FieldType.TEXT,
  });
}

class DataType {
  String name;
  List <Field> fields;
  DataType(this.name, this.fields);
}

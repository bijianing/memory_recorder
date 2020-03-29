import 'package:flutter/material.dart';

import '../view/localization.dart';


enum FieldTypes
{
  Text,
  Number,
  Place,
  DateTime,
}


class MRDataManager {

static String getFieldTypeName(BuildContext context, FieldTypes f) {
  switch (f) {
    case FieldTypes.Text:
      return MRLocalizations.of(context).field_type_text;
    case FieldTypes.Number:
      return MRLocalizations.of(context).field_type_number;
    case FieldTypes.Place:
      return MRLocalizations.of(context).field_type_place;
    case FieldTypes.DateTime:
      return MRLocalizations.of(context).field_type_time;
  }

  return null;
}
  
}
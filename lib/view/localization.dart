import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class MRLocalizations {
  MRLocalizations(this.locale);

  final Locale locale;

  static MRLocalizations of(BuildContext context) {
    return Localizations.of<MRLocalizations>(context, MRLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Memory Recorder',
      'setting': 'Settings',
      'view_data': 'View Data',
      'add_data': 'Add Data',
      'add_data_type': 'Add Data Type',
      'name': 'Name',
      'fields': 'Fields',
      'field_name_error_empty': 'Please enter field name',
      'field_name_error_short': 'field name is too short',
      'add': 'Add',
      'field_type_text': 'Text',
      'field_type_number': 'Number',
      'field_type_place': 'Place',
      'field_type_time': 'DateTime',
      'field_name_hint': 'Field name',
      'field_type_hint': 'Field type',
    },
    'ja': {
      'title': 'メモリ レコーダー',
      'setting': '設定',
      'view_data': 'データ表示',
      'add_data': 'データ追加',
      'add_data_type': 'データ種類追加',
      'name': '名前',
      'fields': 'フィールド',
      'add': '追加',
      'field_name_error_empty': 'フィールド名を入力してください',
      'field_name_error_short': 'フィールド名が短い',
      'field_type_text': 'テキスト',
      'field_type_number': '数字',
      'field_type_place': '場所',
      'field_type_time': '日時',
      'field_name_hint': 'フィールド名',
      'field_type_hint': 'フィールド種類',
    },
    'zh': {
      'title': '回忆记录器',
      'setting': '设置',
      'view_data': '查看数据',
      'add_data': '添加数据',
      'add_data_type': '添加数据类型',
      'name': '名字',
      'fields': '字段',
      'add': '添加',
      'field_name_error_empty': '请输入字段名',
      'field_name_error_short': '字段名太短',
      'field_type_text': '文本',
      'field_type_number': '数字',
      'field_type_place': '地点',
      'field_type_time': '日期时间',
      'field_name_hint': '字段名',
      'field_type_hint': '字段类型',
    },
  };

  // about the languageCode: 
  // https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }
  String get setting {
    return _localizedValues[locale.languageCode]['setting'];
  }
  String get view_data {
    return _localizedValues[locale.languageCode]['view_data'];
  }
  String get add_data {
    return _localizedValues[locale.languageCode]['add_data'];
  }
  String get add_data_type {
    return _localizedValues[locale.languageCode]['add_data_type'];
  }
  String get name {
    return _localizedValues[locale.languageCode]['name'];
  }
  String get fields {
    return _localizedValues[locale.languageCode]['fields'];
  }
  String get add {
    return _localizedValues[locale.languageCode]['add'];
  }
  String get field_name_error_empty {
    return _localizedValues[locale.languageCode]['field_name_error_empty'];
  }
  String get field_name_error_short {
    return _localizedValues[locale.languageCode]['field_name_error_short'];
  }
  String get field_type_text {
    return _localizedValues[locale.languageCode]['field_type_text'];
  }
  String get field_type_number {
    return _localizedValues[locale.languageCode]['field_type_number'];
  }
  String get field_type_place {
    return _localizedValues[locale.languageCode]['field_type_place'];
  }
  String get field_type_time {
    return _localizedValues[locale.languageCode]['field_type_time'];
  }
  String get field_name_hint {
    return _localizedValues[locale.languageCode]['field_name_hint'];
  }
  String get field_type_hint {
    return _localizedValues[locale.languageCode]['field_type_hint'];
  }





}

class MRLocalizationsDelegate extends LocalizationsDelegate<MRLocalizations> {
  const MRLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  Future<MRLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of MRLocalizations.
    return SynchronousFuture<MRLocalizations>(MRLocalizations(locale));
  }

  @override
  bool shouldReload(MRLocalizationsDelegate old) => false;
}
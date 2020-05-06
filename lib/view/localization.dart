import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;


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

class MRLocalizations {
  MRLocalizations(this.locale);

  final Locale locale;

  static MRLocalizations of(BuildContext context) {
    return Localizations.of<MRLocalizations>(context, MRLocalizations);
  }
  String get title {
    Map _lang = {
      'en': 'Memory Recorder',
      'ja': 'メモリ レコーダー',
      'zh': '回忆记录器',
    };
    return _lang[locale.languageCode];
  }
  String get setting {
    Map _lang = {
      'en': 'Settings',
      'ja': '設定',
      'zh': '设置',
    };
    return _lang[locale.languageCode];
  }
  String get viewData {
    Map _lang = {
      'en': 'View Data',
      'ja': 'データ表示',
      'zh': '查看数据',
    };
    return _lang[locale.languageCode];
  }
  String get viewDataDescription {
    Map _lang = {
      'en': 'view added data',
      'ja': '追加済のデータを表示',
      'zh': '查看已添加数据',
    };
    return _lang[locale.languageCode];
  }
  String get addData {
    Map _lang = {
      'en': 'Add Data',
      'ja': 'データ追加',
      'zh': '添加数据',
    };
    return _lang[locale.languageCode];
  }
  String get addDataDescription {
    Map _lang = {
      'en': 'add a new data',
      'ja': '新データを追加します',
      'zh': '添加一个新数据',
    };
    return _lang[locale.languageCode];
  }
  String get addDataType {
    Map _lang = {
      'en': 'Add Data Type',
      'ja': 'データ種類追加',
      'zh': '添加数据类型',
    };
    return _lang[locale.languageCode];
  }
  String get addDataTypeDescription {
    Map _lang = {
      'en': 'add a new data type',
      'ja': '新データ種類を追加します',
      'zh': '添加一个新数据类型',
    };
    return _lang[locale.languageCode];
  }
  String get name {
    Map _lang = {
      'en': 'Name',
      'ja': '名前',
      'zh': '名字',
    };
    return _lang[locale.languageCode];
  }
  String get fields {
    Map _lang = {
      'en': 'Fields',
      'ja': 'フィールド',
      'zh': '字段',
    };
    return _lang[locale.languageCode];
  }
  String get fieldNameErrorEmpty {
    Map _lang = {
      'en': 'Please enter field name',
      'ja': 'フィールド名を入力してください',
      'zh': '请输入字段名',
    };
    return _lang[locale.languageCode];
  }
  String get fieldNameErrorShort {
    Map _lang = {
      'en': 'field name is too short',
      'ja': 'フィールド名が短い',
      'zh': '字段名太短',
    };
    return _lang[locale.languageCode];
  }
  String get add {
    Map _lang = {
      'en': 'Add',
      'ja': '追加',
      'zh': '添加',
    };
    return _lang[locale.languageCode];
  }
  String get tableNameLabel {
    Map _lang = {
      'en': 'New data type name',
      'ja': '新データ種類名',
      'zh': '新数据类型名',
    };
    return _lang[locale.languageCode];
  }
  String get tableNameHint {
    Map _lang = {
      'en': 'New data type name',
      'ja': '新データ種類名',
      'zh': '新数据类型名',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypeText {
    Map _lang = {
      'en': 'Text',
      'ja': 'テキスト',
      'zh': '文本',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypeNumber {
    Map _lang = {
      'en': 'Number',
      'ja': '数字',
      'zh': '数字',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypePlace {
    Map _lang = {
      'en': 'Place',
      'ja': '場所',
      'zh': '地点',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypeTime {
    Map _lang = {
      'en': 'DateTime',
      'ja': '日時',
      'zh': '日期时间',
    };
    return _lang[locale.languageCode];
  }
  String get fieldNameLabel {
    Map _lang = {
      'en': 'Field name',
      'ja': 'フィールド名',
      'zh': '字段名',
    };
    return _lang[locale.languageCode];
  }
  String get fieldNameHint {
    Map _lang = {
      'en': 'Field name',
      'ja': 'フィールド名',
      'zh': '字段名',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypeLabel {
    Map _lang = {
      'en': 'Field type',
      'ja': 'フィールド種類',
      'zh': '字段类型',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypeHint {
    Map _lang = {
      'en': 'Field type',
      'ja': 'フィールド種類',
      'zh': '字段类型',
    };
    return _lang[locale.languageCode];
  }
  String get fieldMustLabel {
    Map _lang = {
      'en': 'Must field',
      'ja': '必須フィールド',
      'zh': '必须字段',
    };
    return _lang[locale.languageCode];
  }
  String get fieldDecimalLabel {
    Map _lang = {
      'en': 'Decimal',
      'ja': '小数',
      'zh': '小数',
    };
    return _lang[locale.languageCode];
  }
  String get fieldMultiLineLabel {
    Map _lang = {
      'en': 'Multiple line',
      'ja': '複数行',
      'zh': '多行',
    };
    return _lang[locale.languageCode];
  }
  String get cancel {
    Map _lang = {
      'en': 'Cancel',
      'ja': 'キャンセル',
      'zh': '取消',
    };
    return _lang[locale.languageCode];
  }
  String get ok {
    Map _lang = {
      'en': 'OK',
      'ja': 'ＯＫ',
      'zh': '确定',
    };
    return _lang[locale.languageCode];
  }
  String get removeFieldMsg {
    Map _lang = {
      'en': 'Remove this field',
      'ja': 'このフィールドを削除',
      'zh': '删除此字段',
    };
    return _lang[locale.languageCode];
  }
  String removeFieldSnackMsg(Object fieldName) {
    Map _lang = {
      'en': 'Field "$fieldName" removed',
      'ja': 'フィールド"$fieldName"を削除しました',
      'zh': '字段"$fieldName"被删除',
    };
    return _lang[locale.languageCode];
  }
  String get dataTypeAlreadyExist {
    Map _lang = {
      'en': 'Data name already exists',
      'ja': 'データ名が存在しています',
      'zh': '数据名已存在',
    };
    return _lang[locale.languageCode];
  }
  String get dataTypeAddSucceed {
    Map _lang = {
      'en': 'New data type added successfully',
      'ja': '新データ種類を追加できました',
      'zh': '新数据类型添加成功',
    };
    return _lang[locale.languageCode];
  }
  String get dataAddSucceed {
    Map _lang = {
      'en': 'New data added successfully',
      'ja': '新データを追加できました',
      'zh': '新数据添加成功',
    };
    return _lang[locale.languageCode];
  }
  String get dataType {
    Map _lang = {
      'en': 'Data type',
      'ja': 'データ種類',
      'zh': '数据类型',
    };
    return _lang[locale.languageCode];
  }
  String get fieldValidateErrorAbsence {
    Map _lang = {
      'en': 'This Field is required',
      'ja': '必須フィールドです',
      'zh': '此字段必须输入',
    };
    return _lang[locale.languageCode];
  }
  String get choose {
    Map _lang = {
      'en': 'Choose',
      'ja': '選択',
      'zh': '选择',
    };
    return _lang[locale.languageCode];
  }

}
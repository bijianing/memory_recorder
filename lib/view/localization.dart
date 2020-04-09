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
    const Map _lang = {
      'en': 'Memory Recorder',
      'ja': 'メモリ レコーダー',
      'zh': '回忆记录器',
    };
    return _lang[locale.languageCode];
  }
  String get setting {
    const Map _lang = {
      'en': 'Settings',
      'ja': '設定',
      'zh': '设置',
    };
    return _lang[locale.languageCode];
  }
  String get viewData {
    const Map _lang = {
      'en': 'View Data',
      'ja': 'データ表示',
      'zh': '查看数据',
    };
    return _lang[locale.languageCode];
  }
  String get addData {
    const Map _lang = {
      'en': 'Add Data',
      'ja': 'データ追加',
      'zh': '添加数据',
    };
    return _lang[locale.languageCode];
  }
  String get addDataType {
    const Map _lang = {
      'en': 'Add Data Type',
      'ja': 'データ種類追加',
      'zh': '添加数据类型',
    };
    return _lang[locale.languageCode];
  }
  String get name {
    const Map _lang = {
      'en': 'Name',
      'ja': '名前',
      'zh': '名字',
    };
    return _lang[locale.languageCode];
  }
  String get fields {
    const Map _lang = {
      'en': 'Fields',
      'ja': 'フィールド',
      'zh': '字段',
    };
    return _lang[locale.languageCode];
  }
  String get fieldNameErrorEmpty {
    const Map _lang = {
      'en': 'Please enter field name',
      'ja': 'フィールド名を入力してください',
      'zh': '请输入字段名',
    };
    return _lang[locale.languageCode];
  }
  String get fieldNameErrorShort {
    const Map _lang = {
      'en': 'field name is too short',
      'ja': 'フィールド名が短い',
      'zh': '字段名太短',
    };
    return _lang[locale.languageCode];
  }
  String get add {
    const Map _lang = {
      'en': 'Add',
      'ja': '追加',
      'zh': '添加',
    };
    return _lang[locale.languageCode];
  }
  String get tableNameLabel {
    const Map _lang = {
      'en': 'New data type name',
      'ja': '新データ種類名',
      'zh': '新数据类型名',
    };
    return _lang[locale.languageCode];
  }
  String get tableNameHint {
    const Map _lang = {
      'en': 'New data type name',
      'ja': '新データ種類名',
      'zh': '新数据类型名',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypeText {
    const Map _lang = {
      'en': 'Text',
      'ja': 'テキスト',
      'zh': '文本',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypeNumber {
    const Map _lang = {
      'en': 'Number',
      'ja': '数字',
      'zh': '数字',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypePlace {
    const Map _lang = {
      'en': 'Place',
      'ja': '場所',
      'zh': '地点',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypeTime {
    const Map _lang = {
      'en': 'DateTime',
      'ja': '日時',
      'zh': '日期时间',
    };
    return _lang[locale.languageCode];
  }
  String get fieldNameLabel {
    const Map _lang = {
      'en': 'Field name',
      'ja': 'フィールド名',
      'zh': '字段名',
    };
    return _lang[locale.languageCode];
  }
  String get fieldNameHint {
    const Map _lang = {
      'en': 'Field name',
      'ja': 'フィールド名',
      'zh': '字段名',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypeLabel {
    const Map _lang = {
      'en': 'Field type',
      'ja': 'フィールド種類',
      'zh': '字段类型',
    };
    return _lang[locale.languageCode];
  }
  String get fieldTypeHint {
    const Map _lang = {
      'en': 'Field type',
      'ja': 'フィールド種類',
      'zh': '字段类型',
    };
    return _lang[locale.languageCode];
  }
  String get fieldMustLabel {
    const Map _lang = {
      'en': 'Must field',
      'ja': '必須フィールド',
      'zh': '必须字段',
    };
    return _lang[locale.languageCode];
  }
  String get fieldDecimalLabel {
    const Map _lang = {
      'en': 'Decimal',
      'ja': '小数',
      'zh': '小数',
    };
    return _lang[locale.languageCode];
  }
  String get fieldMultiLineLabel {
    const Map _lang = {
      'en': 'Multiple line',
      'ja': '複数行',
      'zh': '多行',
    };
    return _lang[locale.languageCode];
  }
  String get cancel {
    const Map _lang = {
      'en': 'Cancel',
      'ja': 'キャンセル',
      'zh': '取消',
    };
    return _lang[locale.languageCode];
  }
  String get ok {
    const Map _lang = {
      'en': 'OK',
      'ja': 'ＯＫ',
      'zh': '确定',
    };
    return _lang[locale.languageCode];
  }
  String get removeFieldMsg {
    const Map _lang = {
      'en': 'Remove this field',
      'ja': 'このフィールドを削除',
      'zh': '删除此字段',
    };
    return _lang[locale.languageCode];
  }
  String get removeFieldSnackMsg {
    const Map _lang = {
      'en': 'Field removed',
      'ja': 'フィールドを削除しました',
      'zh': '删除此字段一个字段',
    };
    return _lang[locale.languageCode];
  }
  String get dataTypeAlreadyExist {
    const Map _lang = {
      'en': 'Data name already exists',
      'ja': 'データ名が存在しています',
      'zh': '数据名已存在',
    };
    return _lang[locale.languageCode];
  }
  String get dataTypeAddSucceed {
    const Map _lang = {
      'en': 'New data type added successfully',
      'ja': '新データ種類を追加できました',
      'zh': '新数类型据添加成功',
    };
    return _lang[locale.languageCode];
  }

}
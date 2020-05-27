import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memory_recorder/view/floating_add_button.dart';
import 'field.dart';

class MRData {
  final CollectionReference _dataTypeCollection;
  final CollectionReference _dataCollection;
  final CollectionReference _tagCollection;

  static MRData _instance;
  static GlobalKey<FloatingAddButtonState> dataTypeChangeListenerKey;

  List<DocumentSnapshot> _dataTypes;

  // make this a singleton class
  MRData._privateConstructor(
    this._dataTypeCollection,
    this._dataCollection,
    this._tagCollection,
  );
  
  static MRData get instance {
    if (_instance != null) return _instance;

    _instance = MRData._privateConstructor(
      Firestore.instance.collection('DataType'),
      Firestore.instance.collection('Data'),
      Firestore.instance.collection('Tag'),
    );
    

    return _instance;
  }

  static List<DocumentSnapshot> get rawDataTypes {
    return instance._dataTypes;
  }

  static List<DocumentSnapshot> _sortDataTypes() {
    instance._dataTypes.sort((a, b) => a['_timestamp'].compareTo(b['_timestamp']));
    return instance._dataTypes;
  }

  static void _updateDataType({bool updateFromCache = false}) async {
    QuerySnapshot dataTypeQuerySnapshot;
    dataTypeQuerySnapshot = await instance._dataTypeCollection.getDocuments(
      source: updateFromCache ? Source.cache : Source.serverAndCache,
    );
    instance._dataTypes = dataTypeQuerySnapshot.documents;
    _sortDataTypes();

    if (MRData.dataTypeChangeListenerKey != null) {
      MRData.dataTypeChangeListenerKey.currentState.rebuild();
    }
  }

  /*  Get all data type snapshot */
  static Future<List<DocumentSnapshot>> get dataTypes async {
    if (instance._dataTypes != null) return instance._dataTypes;

    _updateDataType();
    return instance._dataTypes;
  }

  /*  Add a new data type */
  static Future<bool> newDataType(String name, List<Field> fields) async {
    QuerySnapshot query = await instance._dataTypeCollection.where('name', isEqualTo: name).getDocuments();
    if (query.documents.length > 0) {
      return false;
    }
    
    List<Map<String, dynamic>> fieldsList = fields.map((f) => {
        'name': f.name,
        'must': f.must,
        'multiline': f.multiline,
        'decimal': f.decimal,
        'type': f.type.name,
    }).toList();

    instance._dataTypeCollection.add({
      'name': name,
      'fields': fieldsList,
      '_timestamp' : DateTime.now(),
    });
    _updateDataType(updateFromCache: true);
    return true;
  }
  /*  Add a new data type */
  static Future<bool> newData(String name, Map fieldValues) async {

    instance._dataCollection.document(name).collection('Data').add(fieldValues);
    instance._dataTypeCollection.document(name).updateData(
      {
        '_timestamp': DateTime.now(),
      }
    );
    _updateDataType(updateFromCache: true);
    return true;
  }
  
  static Future<bool> newTag(String tagName) async {
    DocumentSnapshot tagSnapshot = await instance._tagCollection.document(tagName).get();
    if (tagSnapshot.exists) {
      return false;
    }

    return true;
  }

  // All of the rows are returned as a list of maps, where each map is 
  // a key-value list of columns.
  void dumpDb() async {
    print("Test firebase: #### DUMPT all data ####\n");
    _dataTypeCollection.getDocuments().then((querySnapshot) {
      print('DataTypes collection:\n');
      querySnapshot.documents.forEach((d) {
        List _fieldList = d['fields'];
        print('  Datatype name: ${d["name"]}');
        print('  Datatype fields: count: ${_fieldList.length}\n');
        _fieldList.asMap().forEach((i, f) {
          DocumentReference field = f;
          field.get().then((snapshot) {
            print('    Field($i) name: ${snapshot["name"]}');
          });
        });
      });
    });
  }



}
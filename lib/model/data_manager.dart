import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:logging/logging.dart';

import 'field.dart';

class MRData {
  final CollectionReference _dataTypeCollection;
  final CollectionReference _dataCollection;

  static MRData _instance;

  // make this a singleton class
  MRData._privateConstructor(this._dataTypeCollection, this._dataCollection);
  
  static MRData get instance {
    if (_instance != null) return _instance;

    _instance = MRData._privateConstructor(
      Firestore.instance.collection('DataType'),
      Firestore.instance.collection('Data'),
    );
    

    return _instance;
  }

  /*  Get all data type name */
  static Stream<QuerySnapshot> get dataTypeStream {
    return instance._dataTypeCollection.snapshots();
  }

  /*  Get all data type snapshot */
  static Future<List<DocumentSnapshot>> get dataTypes async {
    QuerySnapshot dataTypeQuerySnapshot = await instance._dataTypeCollection.getDocuments();

    return dataTypeQuerySnapshot.documents;
  }

  /*  Add a new data type */
  static Future<bool> newDataType(String name, List<Field> fields) async {
    DocumentReference dataTypeReference = instance._dataTypeCollection.document(name);
    DocumentSnapshot dataTypeSnapshot = await dataTypeReference.get();
    if (dataTypeSnapshot.exists) {
      return false;
    }

    List<Map<String, dynamic>> fieldsList = fields.map((f) => {
        'name': f.name,
        'must': f.must,
        'multiline': f.multiline,
        'decimal': f.decimal,
        'type': f.type.name,
    }).toList();

    dataTypeReference.setData({
      'name': name,
      'fields': fieldsList,
    });

    return true;
  }
  /*  Add a new data type */
  static Future<bool> newData(String name, Map fieldValues) async {

    instance._dataCollection.document(name).setData(fieldValues);
    
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
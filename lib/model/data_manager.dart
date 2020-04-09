import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:logging/logging.dart';

import 'field.dart';

class MRDataManager {
  final CollectionReference _dataTypeCollection;
  final CollectionReference _dataCollection;

  static MRDataManager _instance;

  // make this a singleton class
  MRDataManager._privateConstructor(this._dataTypeCollection, this._dataCollection);
  
  static MRDataManager get instance {
    if (_instance == null) {
      _instance = MRDataManager._privateConstructor(
        Firestore.instance.collection('DataType'),
        Firestore.instance.collection('Data'),
      );
    }

    return _instance;
  }



  /*  Add a new data type */
  Future<DataType> newDataType(String name, List<Field> fields) async {
    DocumentReference dataTypeReference = _dataTypeCollection.document(name);
    DocumentSnapshot dataTypeSnapshot = await dataTypeReference.get();
    if (dataTypeSnapshot.exists) {
      return null;
    }

    List<Map<String, dynamic>> fieldsList = fields.map((f) => {
        'name': f.name,
        'must': f.must,
        'multiline': f.multiline,
        'decimal': f.decimal,
    }).toList();

    dataTypeReference.setData({
      'name': name,
      'fields': fieldsList,
    });

    return DataType(name, fields);
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
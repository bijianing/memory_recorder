import 'package:flutter/material.dart';
import 'package:memory_recorder/model/model.dart';
import 'package:memory_recorder/view/controls.dart';

class _DataField {
  String name;
  FieldTypes type;
}

class NewDataTypePage extends StatefulWidget {
  NewDataTypePage({Key key}) : super(key: key);

  @override
  _NewDataTypePageState createState() => _NewDataTypePageState();
}

class _NewDataTypePageState extends State<NewDataTypePage> {
  List <_DataField> _fields = [];
  void _addFields() {
    _fields.add(value)
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New data type'),
      ),
      body: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Name',
              icon: Icon(Icons.perm_identity),
            ),
          ),
          SpaceBox.height(15),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SpaceBox(),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Data Fields:',
                  style: Theme.of(context).textTheme.title,),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    child: Text("Add field"),
                    color: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SpaceBox(),
              ),
            ],
          ),
          Divider(),
        ],
      )
    );
  }
}



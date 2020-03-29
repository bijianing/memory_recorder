import 'package:flutter/material.dart';
import 'package:memory_recorder/model/model.dart';
import 'package:memory_recorder/view/controls.dart';

import '../model/model.dart';
import '../model/model.dart';
import '../model/model.dart';
import 'localization.dart';
import '../model/model.dart';

class _DataField {
  String name;
  FieldTypes type;
  bool must;
  bool decimal;     // Number option
  bool mul_line;    // Text option
}


class _DataFieldWidget extends StatefulWidget {
  _DataFieldWidget(this._data, this._itemlist);

  _DataField _data;
  List <DropdownMenuItem<FieldTypes>> _itemlist;

  @override
  _DataFieldWidgetState createState() => _DataFieldWidgetState(_data, _itemlist);
}

class _DataFieldWidgetState extends State<_DataFieldWidget> {
  _DataFieldWidgetState(this._data, this._itemlist);

  _DataField _data;
  List <DropdownMenuItem<FieldTypes>> _itemlist;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SpaceBox(),
        ),
        Expanded(
          flex: 10,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: MRLocalizations.of(context).name,
              icon: Icon(Icons.perm_identity),
            ),
            onSaved: (String val) {
              _data.name = val;
            },
            validator: (value) {
              if (value.isEmpty) {
                return MRLocalizations.of(context).field_name_error_empty;
              }
              if (value.length < 2) {
                return MRLocalizations.of(context).field_name_error_short;
              }
              return null;
            },
          ),
        ),
        Expanded(
          flex: 10,
          child: DropdownButton<FieldTypes> (
            value: _data.type,
            items: _itemlist,
            hint: Text(MRLocalizations.of(context).field_type_hint),
            onChanged: (value) {
              setState(() {
                _data.type = value;
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: SpaceBox(),
        ),
      ],
    );
  }
}

class _FieldListWidget extends StatefulWidget {
  _FieldListWidget({Key key}) : super(key: key);

  @override
  _FieldListWidgetState createState() => _FieldListWidgetState();
}

class _FieldListWidgetState extends State<_FieldListWidget> {

  List <_DataField> _fields;
  List <DropdownMenuItem<FieldTypes>> _drop_items;

  @override
  void initState() {
    _fields = List();
    _drop_items = null;
    super.initState();
  }

  void _createDropItems(BuildContext context) {
    _drop_items = FieldTypes.values.map(
      (type) {
        return DropdownMenuItem(
          child: Text(
            MRDataManager.getFieldTypeName(context, type)
          ),
          value: type,
        );
      }
    ).toList();
  }

  void addField() {
    setState(() {
      _fields.add(_DataField());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_drop_items == null) { 
      _createDropItems(context);
    }
    return ListView(
      children: _fields.map(
        (f) {
          return _DataFieldWidget(f, _drop_items);
        }
      ).toList(),
    );
  }
}


class NewDataTypePage extends StatefulWidget {
  NewDataTypePage({Key key}) : super(key: key);

  @override
  _NewDataTypePageState createState() => _NewDataTypePageState();
}

class _NewDataTypePageState extends State<NewDataTypePage> {
  
  GlobalKey<_FieldListWidgetState> _keyFieldListState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          MRLocalizations.of(context).add_data_type,
        ),
      ),
      body: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: MRLocalizations.of(context).name,
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
                  child: Text(MRLocalizations.of(context).fields,
                  style: Theme.of(context).textTheme.title,),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    child: Text(
                      MRLocalizations.of(context).add_data_type,
                    ),
                    color: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () {
                      _keyFieldListState.currentState.addField();
                    },
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
          Expanded(
             child: _FieldListWidget(
              key: _keyFieldListState,
            ),
          ),
        ],
      )
    );
  }
}


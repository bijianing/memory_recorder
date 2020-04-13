import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memory_recorder/model/data_manager.dart';
import 'package:memory_recorder/model/field.dart';
import 'package:memory_recorder/view/controls.dart';
import 'localization.dart';
import 'package:intl/intl.dart';


class NewDataPage extends StatefulWidget {
  NewDataPage({Key key}) : super(key: key);

  @override
  _NewDataPageState createState() => _NewDataPageState(key);
}

class _NewDataPageState extends State<NewDataPage> {
  _NewDataPageState(this.key);
  final Key key;
  final formKey = GlobalKey<FormState>();
  DocumentSnapshot dataType;
  List <DocumentSnapshot> dataTypes;
  Map <String, dynamic> fieldValues = Map();

  dynamic getDataType() {
    if (dataTypes == null) {
      MRData.dataTypes.then((docs) {
        setState(() {
          dataTypes = docs;
        });
      });

      return DropdownButton(items: null, onChanged: null);
    }

    return DropdownButtonFormField(
      value: dataType,
      items: dataTypes.map(
        (doc) => DropdownMenuItem(
          child: Text(doc['name']),
          value: doc,
        )
      ).toList(),
      onChanged: (value) {
        setState(() {
          dataType = value;
        });
      },

      isDense: true,
      isExpanded: true,
    );
  }

  Widget generateTextField(Map<String, dynamic> field) {
    String name = field['name'];
    if (fieldValues[name] == null) {
      fieldValues[name] = '';
    }

    if (field['multiline']) {
      return TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: name,
            hintText: name,
          ),
          onSaved: (value) {
            fieldValues[name] = value;
          },
          maxLines: null,
          keyboardType: TextInputType.multiline,
          // textAlign: TextAlign.center,
          // onFieldSubmitted: (value) {
          //   if (value.length == 0) return;
          //   _keyFieldListState.currentState.addField();
          // },
          validator: (val) {
            if (field['must']) {
              if (val.isEmpty) {
                return MRLocalizations.of(context).fieldValidateErrorAbsence;
              }
            }

            return null;
          },
        );
    }
    return Row(children: <Widget>[
      Expanded(
        flex: 3,
        child: Text(name),
      ),
      Expanded(
        flex: 5,
        child: TextFormField(
          // decoration: InputDecoration(
          //   border: OutlineInputBorder(),
          //   labelText: field['name'],
          //   hintText: field['name'],
          // ),
          onSaved: (value) {
            fieldValues[name] = value;
          },
          // maxLines: null,
          // keyboardType: TextInputType.multiline,
          // textAlign: TextAlign.center,
          // onFieldSubmitted: (value) {
          //   if (value.length == 0) return;
          //   _keyFieldListState.currentState.addField();
          // },
          validator: (val) {
            if (field['must']) {
              if (val.isEmpty) {
                return MRLocalizations.of(context).fieldValidateErrorAbsence;
              }
            }

            return null;
          },
        )
      ),
    ]);
  }

  Widget generateNumberField(Map<String, dynamic> field) {
    String name = field['name'];
    if (fieldValues[name] == null) {
      fieldValues[name] = 0.0;
    }

    return Row(children: <Widget>[
      Expanded(
        flex: 3,
        child: Text(name),
      ),
      Expanded(
        flex: 5,
        child: TextFormField(
          onSaved: (value) {
            fieldValues[name] = double.parse(value);
          },
          validator: (val) {
            if (field['must']) {
              if (val.isEmpty) {
                return MRLocalizations.of(context).fieldValidateErrorAbsence;
              }
            }

            return null;
          },
          keyboardType: TextInputType.number,
        )
      ),
    ]);
  }


  Widget generateDateTimeField(Map<String, dynamic> field) {
    String name = field['name'];
    if (fieldValues[name] == null) {
      fieldValues[name] = DateTime.now();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
      Expanded(
        flex: 3,
        child: Text(name),
      ),
      Expanded(
        flex: 5,
        child: FlatButton(
          child: Text(DateFormat.yMMMd().format(fieldValues[name])),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: fieldValues[name],
              firstDate: DateTime(2015, 1),
              lastDate: DateTime(2100),
            );
            if (picked != null && picked != fieldValues[name]) {
              setState(() {
                fieldValues[name] = picked;
              });
            }
          },
          
        ),
      ),
    ]);
  }

  Widget getFields() {
    if (dataType == null) return Container();
    List <Widget> _list = [];
    List fields = dataType['fields'];
    Widget fieldWidget;

    print('fields: ${fields.hashCode}' );
    fields.forEach((field) {
      if (field['type'] == FieldType.TEXT.name) {
        fieldWidget = generateTextField(field);
      }
      if (field['type'] == FieldType.NUMBER.name) {
        fieldWidget = generateNumberField(field);
      }
      if (field['type'] == FieldType.DATETIME.name) {
        print('date field: ${field["name"]}');
        fieldWidget = generateDateTimeField(field);
      }
      if (field['type'] == FieldType.PLACE.name) {
        fieldWidget = generateTextField(field);
      }

      _list.add(fieldWidget);
    });

    _list.add(ButtonBar(
      children: <Widget>[
        RaisedButton(
//          elevation: 3,
          child: Text(MRLocalizations.of(context).cancel),
          onPressed: dataType != null ? _cancelButtonHandler : null,
        ),
        RaisedButton(
//          elevation: 3,
          child: Text(MRLocalizations.of(context).ok),
          onPressed: dataType != null ? _okButtonHandler : null,
        ),
      ],
    ));
    return ListView(children: _list,);
  }

  
  void _cancelButtonHandler() {
    Navigator.of(context).pop();
  }

  void _okButtonHandler() async {
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();
    MRData.newData(dataType['name'], fieldValues);
    Navigator.of(context).pop(MRLocalizations.of(context).dataAddSucceed);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        //      floatingActionButton: buildSpeedDial(),
        appBar: AppBar(
          title: Text(
            MRLocalizations.of(context).addData,
          ),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: <Widget> [

              // Data type selection
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(MRLocalizations.of(context).dataType)
                  ),
                  Expanded(
                    flex: 5,
                    child: getDataType(),
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5 ),
                  child: getFields(),
                )
              )
            ]
          )
        )
      )
    );
  }
}

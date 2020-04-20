import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memory_recorder/model/data_manager.dart';
import 'package:memory_recorder/model/field.dart';
import 'localization.dart';

class _FieldWidget extends StatefulWidget {
  _FieldWidget(this._data, this._itemlist);

  final Field _data;
  final List<DropdownMenuItem> _itemlist;

  @override
  _FieldWidgetState createState() => _FieldWidgetState(_data, _itemlist);
}

class _FieldWidgetState extends State<_FieldWidget> {
  _FieldWidgetState(this._data, this._itemlist);

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // _focusNode.addListener(() {
    //   print("Has focus: ${_focusNode.hasFocus}");
    // });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Field _data;
  List<DropdownMenuItem> _itemlist;
/* create widgets of a field */
  List<Widget> _createWidgets() {
    List<Widget> _list = List();

    // Field name text field
    _list.add(Row(children: <Widget>[
      Expanded(
          flex: 4, child: Text(MRLocalizations.of(context).fieldNameLabel)),
      Expanded(
        flex: 5,
        child: TextFormField(
          focusNode: _focusNode,
          autofocus: true,
          decoration: InputDecoration(
            // isDense: true,
            hintText: MRLocalizations.of(context).fieldNameHint,
            contentPadding: EdgeInsets.only(bottom: 2, top: 2),
          ),
          onChanged: (String val) {
            _data.name = val;
          },
          validator: (value) {
            if (value.isEmpty) {
              return MRLocalizations.of(context).fieldNameErrorEmpty;
            }
            if (value.length < 2) {
              return MRLocalizations.of(context).fieldNameErrorShort;
            }
            return null;
          },
        ),
      )
    ]));
    
    // Field type dropdown button
    _list.add(Row(children: <Widget>[
      Expanded(
          flex: 4, child: Text(MRLocalizations.of(context).fieldTypeLabel)),
      Expanded(
        flex: 5,
        child: DropdownButtonFormField<FieldType>(
          // decoration: InputDecoration(
          //   contentPadding: EdgeInsets.only(left: 0, bottom: 0, top: 0),
          //   border: InputBorder.none,
          // ),
          isDense: true,
          isExpanded: true,
          value: _data.type,
          items: _itemlist,
          hint: Text(MRLocalizations.of(context).fieldTypeHint),
          onChanged: (value) {
            _data.type = value;
            setState(() {
              _data.type = value;
            });
          },
        ),
      )
    ]));

    // Must checkbox
    _list.add(
      CheckboxListTile(
        title: Text(MRLocalizations.of(context).fieldMustLabel),
        value: _data.must,
        onChanged: (value) {
          setState(() {
            _data.must = value;
          }
        );
        if (_focusNode.hasFocus) _focusNode.unfocus();
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      dense: true,
    ));

    // Decimal checkbox
    if (_data.type == FieldType.NUMBER) {
      _list.add(CheckboxListTile(
        title: Text(MRLocalizations.of(context).fieldDecimalLabel),
        value: _data.decimal,
        onChanged: (value) {
          setState(() {
            _data.decimal = value;
          });
          if (_focusNode.hasFocus) _focusNode.unfocus();
        },
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
        dense: true,
      ));
    }

    // multiple line checkbox
    if (_data.type == FieldType.TEXT) {
      _list.add(CheckboxListTile(
        title: Text(MRLocalizations.of(context).fieldMultiLineLabel),
        value: _data.multiline,
        onChanged: (value) {
          setState(() {
            _data.multiline = value;
          });
          if (_focusNode.hasFocus) _focusNode.unfocus();
        },
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
        dense: true,
      ));
    }
    
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      elevation: 3,
//      color: Colors.green[500],
      margin: EdgeInsets.all(8),
      child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _createWidgets(),
          )),
    );
  }
}

class _FieldListWidget extends StatefulWidget {
  _FieldListWidget({Key key, this.parent}) : super(key: key);
  final NewDataTypePageState parent;
  @override
  _FieldListWidgetState createState() => _FieldListWidgetState(parent);
}

class _FieldListWidgetState extends State<_FieldListWidget> {
  _FieldListWidgetState(this.parent);

  final NewDataTypePageState parent;

  List<Field> _fields = List();
  List<DropdownMenuItem> _dropItems;

  void _createDropItems() {
    _dropItems = FieldType.values.map((type) {
      return DropdownMenuItem(
        child: Text(FieldType.toLocalizedName(context, type)),
        value: type,
      );
    }).toList();
  }

  void addField() {
    setState(() {
      _fields.add(Field());
    });
  }

  void addFieldIfNotExists() {
    if (_fields.length == 0) {
      addField();
    }
  }

  void _cancelButtonHandler() {
    Navigator.of(context).pop();
  }

  void _okButtonHandler() async {
    String name;
    if (!parent.formKey.currentState.validate()) {
      return;
    }
    parent.formKey.currentState.save();
    name = parent.tableNameTextEditController.text;
    bool ret = await MRData.newDataType(name, _fields);
    String userMessage;

    // data type exists, notify the user
    if (ret == null) {
      userMessage = MRLocalizations.of(context).dataTypeAlreadyExist;
    } else {
      userMessage = MRLocalizations.of(context).dataTypeAddSucceed;
      Navigator.of(context).pop();
    }

    Scaffold.of(context).showSnackBar(SnackBar(content: Text(userMessage)));
  }

  List<Widget> _createFieldListWidget() {
    List<Widget> _list = List();

    for (int i = 0; i < _fields.length; i++) {
      _list.add(Dismissible(
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        child: _FieldWidget(_fields[i], _dropItems),
        onDismissed: (direction) {
          setState(() {
            _fields.removeAt(i);
          });

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(MRLocalizations.of(context).removeFieldSnackMsg),
              action: SnackBarAction(label: 'OK', onPressed: () {
                Scaffold.of(context).removeCurrentSnackBar();
              })
            ),
          );
        },
        background: Container(
          alignment: Alignment(0, 0),
          color: Colors.red,
          child: Text(
            MRLocalizations.of(context).removeFieldMsg,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ));
//      _list.add(Divider());
    }

    _list.add(ButtonBar(
      children: <Widget>[
        RaisedButton(
//          elevation: 3,
          child: Text(MRLocalizations.of(context).cancel),
          onPressed: _fields.length > 0 ? this._cancelButtonHandler : null,
        ),
        RaisedButton(
//          elevation: 3,
          child: Text(MRLocalizations.of(context).ok),
          onPressed: _fields.length > 0 ? this._okButtonHandler : null,
        ),
      ],
    ));

    return _list;
  }

  @override
  Widget build(BuildContext context) {
    if (_dropItems == null) {
      _createDropItems();
    }
    return ListView(
      children: _createFieldListWidget(),
    );
  }
}

class NewDataTypePage extends StatefulWidget {
  @override
  NewDataTypePageState createState() => NewDataTypePageState();
}

class NewDataTypePageState extends State<NewDataTypePage> {

  final _keyFieldListState = GlobalKey<_FieldListWidgetState>();
  final formKey = GlobalKey<FormState>();
  final tableNameTextEditController = TextEditingController();

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // _focusNode.addListener(() {
    //   print("Has focus: ${_focusNode.hasFocus}");
    // });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }


  List <Widget> _bodyWidgets(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          focusNode: _focusNode,
          autofocus: true,
          decoration: InputDecoration(
//            border: OutlineInputBorder(),
//            labelText: MRLocalizations.of(context).tableNameLabel,
            hintText: MRLocalizations.of(context).tableNameHint,
          ),
          controller: tableNameTextEditController,
          textAlign: TextAlign.center,
          onFieldSubmitted: (value) {
            if (value.length == 0) return;
            _keyFieldListState.currentState.addField();
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  MRLocalizations.of(context).fields,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  child: Text(
                    MRLocalizations.of(context).add,
                  ),
                  //                    color: Colors.green[400],
                  elevation: 3,
                  // shape: StadiumBorder(
                  //   side: BorderSide(color: Colors.green),
                  // ),
                  onPressed: () {
                    if (_focusNode.hasFocus) _focusNode.unfocus();
                    _keyFieldListState.currentState.addField();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).buttonColor,
              ),
            )
          ),
          child: _FieldListWidget(
            key: _keyFieldListState,
            parent: this,
          ),
        )
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        //      floatingActionButton: buildSpeedDial(),
        appBar: AppBar(
          title: Text(
            MRLocalizations.of(context).addDataType,
          ),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: _bodyWidgets(context),
          )
        )
      )
    );
  }
}

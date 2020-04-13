import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memory_recorder/model/data_manager.dart';
import 'package:memory_recorder/model/field.dart';
import 'package:memory_recorder/view/controls.dart';
import 'localization.dart';

//import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class _FieldWidget extends StatefulWidget {
  _FieldWidget(this._data, this._itemlist);

  final Field _data;
  final List<DropdownMenuItem> _itemlist;

  @override
  _FieldWidgetState createState() => _FieldWidgetState(_data, _itemlist);
}

class _FieldWidgetState extends State<_FieldWidget> {
  _FieldWidgetState(this._data, this._itemlist);

  final double _spacdBetweenWidget = 0;
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
          initialValue: _data.name,
          decoration: InputDecoration(
            hintText: MRLocalizations.of(context).fieldNameHint,
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
//    _list.add(SpaceBox.height(_spacdBetweenWidget));

    // Field type dropdown button
    _list.add(Row(children: <Widget>[
      Expanded(
          flex: 4, child: Text(MRLocalizations.of(context).fieldTypeLabel)),
      Expanded(
        flex: 5,
        child: DropdownButtonFormField(
          isDense: true,
          isExpanded: true,
          value: _data.type,
          items: _itemlist,
          hint: Text(MRLocalizations.of(context).fieldTypeHint),
          onChanged: (value) {
            setState(() {
              _data.type = value;
            });
          },
        ),
      )
    ]));
//    _list.add(SpaceBox.height(_spacdBetweenWidget));

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
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      dense: true,
    ));
//    _list.add(SpaceBox.height(_spacdBetweenWidget));

    // Decimal checkbox
    if (_data.type == FieldType.NUMBER) {
      _list.add(CheckboxListTile(
        title: Text(MRLocalizations.of(context).fieldDecimalLabel),
        value: _data.decimal,
        onChanged: (value) {
          setState(() {
            _data.decimal = value;
          });
        },
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
        dense: true,
      ));
//      _list.add(SpaceBox.height(_spacdBetweenWidget));
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
        },
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
        dense: true,
      ));
//      _list.add(SpaceBox.height(_spacdBetweenWidget));
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
  final _NewDataTypePageState parent;
  @override
  _FieldListWidgetState createState() => _FieldListWidgetState(parent);
}

class _FieldListWidgetState extends State<_FieldListWidget> {
  _FieldListWidgetState(this.parent);

  final _NewDataTypePageState parent;

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
    name = parent.tableName;
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

          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(MRLocalizations.of(context).removeFieldSnackMsg)));
        },
        background: Container(
          alignment: Alignment(1, 0),
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
  NewDataTypePage({Key key}) : super(key: key);

  @override
  _NewDataTypePageState createState() => _NewDataTypePageState(key);
}

class _NewDataTypePageState extends State<NewDataTypePage> {
  _NewDataTypePageState(this.key);
  final Key key;
  /*
  ScrollController scrollController;
  bool dialVisible = true;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      marginBottom: 100,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.accessibility, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () => print('FIRST CHILD'),
          label: 'First Child',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.brush, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('SECOND CHILD'),
          label: 'Second Child',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.keyboard_voice, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => print('THIRD CHILD'),
          labelWidget: Container(
            color: Colors.blue,
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(6),
            child: Text('Custom Label Widget'),
          ),
        ),
      ],
    );
  }

  */

  final _keyFieldListState = GlobalKey<_FieldListWidgetState>();
  final formKey = GlobalKey<FormState>();
  String tableName;


  List <Widget> _bodyWidgets(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          decoration: InputDecoration(
//            border: OutlineInputBorder(),
//            labelText: MRLocalizations.of(context).tableNameLabel,
            hintText: MRLocalizations.of(context).tableNameHint,
          ),
          onSaved: (value) {
            tableName = value;
          },
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
        FocusScope.of(context).requestFocus(new FocusNode());
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

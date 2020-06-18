import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memory_recorder/model/data_manager.dart';
import 'package:memory_recorder/view/chip_select.dart';
import 'localization.dart';



class ItemModel {
  bool isExpanded;
  String header;
  Widget Function(BuildContext context) bodyBuilder;

  ItemModel({this.isExpanded: false, this.header, this.bodyBuilder});
}


class ViewDataPage extends StatefulWidget {
  final String defaultType;
  ViewDataPage({Key key, this.defaultType}) : super(key: key);

  @override
  _ViewDataPageState createState() => _ViewDataPageState(key, defaultType);
}

class _ViewDataPageState extends State<ViewDataPage> {
  final String defaultType;
  final Key key;
  final formKey = GlobalKey<FormState>();
  DocumentSnapshot dataType;
  List <DocumentSnapshot> dataTypes;
  Map <String, dynamic> fieldValues = Map();
  List<ItemModel> panelData;
  List<String> _dataTypes;

  _ViewDataPageState(this.key, this.defaultType);


  @override
  void initState() {
    super.initState();
    panelData = <ItemModel>[
      ItemModel(header: 'Select Data Type', bodyBuilder: dataTypeSelectorBuilder),
      ItemModel(header: 'Filters', bodyBuilder: filterBuilder),
      ItemModel(header: 'Disaplay Method', bodyBuilder: displayMethodBuilder),
    ];
  }


  Widget dataTypeSelectorBuilder(BuildContext context)
  {
    if (_dataTypes == null) {
      MRData.dataTypes.then((types) {
        setState(() {
          _dataTypes = types.map((e) => e['name'] as String).toList();
        });
      });
      return Text('...');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Date type'),
        ChipSelect(
        initChipLabels: _dataTypes,
        padding: 0.05,
        chipElevation: 3,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Theme.of(context).buttonColor),
        //   borderRadius: BorderRadius.circular(5),
        // ),
      ),
      Divider(),
      Text('Date field'),
      ],
    );

  }

  Widget filterBuilder(BuildContext context)
  {
    return Text('Filters');
  }

  
  Widget displayMethodBuilder(BuildContext context)
  {
    return Text('Display methods');
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
            MRLocalizations.of(context).addData,
          ),
        ),
        body: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: panelData.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionPanelList(
                  animationDuration: Duration(milliseconds: 600),
                  children: [
                    ExpansionPanel(
                      body: Container(
                        // color: Colors.purple,
                        padding: EdgeInsets.all(10),
                        child: panelData[index].bodyBuilder(context),
                      ),
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Container(
                          // color: Colors.purpleAccent,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            panelData[index].header,
                            style: TextStyle(
                              color: isExpanded ? Theme.of(context).primaryColor : Colors.black54,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                      isExpanded: panelData[index].isExpanded,
                      canTapOnHeader: true,
                    )
                  ],
                  expansionCallback: (int item, bool status) {
                    setState(() {
                      panelData[index].isExpanded =
                          !panelData[index].isExpanded;
                    });
                  },
                  expandedHeaderPadding: EdgeInsets.all(5),
                );
              },
            ),
          ),
        )
      )
    );
  }
}


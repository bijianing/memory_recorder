import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memory_recorder/model/data_manager.dart';
import 'package:memory_recorder/model/field.dart';
import 'localization.dart';
import 'package:intl/intl.dart';


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

  _ViewDataPageState(this.key, this.defaultType);

  List<ItemModel> prepareData = <ItemModel>[
    ItemModel(header: 'Milk', bodyModel: BodyModel(price: 20, quantity: 10)),
    ItemModel(header: 'Coconut', bodyModel: BodyModel(price: 35, quantity: 5)),
    ItemModel(header: 'Watch', bodyModel: BodyModel(price: 800, quantity: 15)),
    ItemModel(header: 'Cup', bodyModel: BodyModel(price: 80, quantity: 150))
  ];

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
              itemCount: prepareData.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionPanelList(
                  animationDuration: Duration(milliseconds: 600),
                  children: [
                    ExpansionPanel(
                      body: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'PRICE: ${prepareData[index].bodyModel.price}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'QUANTITY: ${prepareData[index].bodyModel.quantity}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            prepareData[index].header,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                      isExpanded: prepareData[index].isExpanded,
                      canTapOnHeader: true,
                    )
                  ],
                  expansionCallback: (int item, bool status) {
                    setState(() {
                      prepareData[index].isExpanded =
                          !prepareData[index].isExpanded;
                    });
                  },
                );
              },
            ),
          ),
        )
      )
    );
  }
}


class ItemModel {
  bool isExpanded;
  String header;
  BodyModel bodyModel;

  ItemModel({this.isExpanded: false, this.header, this.bodyModel});
}

class BodyModel {
  int price;
  int quantity;

  BodyModel({this.price, this.quantity});
}


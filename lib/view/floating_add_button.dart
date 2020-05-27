import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:memory_recorder/model/data_manager.dart';
import 'new_data.dart';

class FloatingAddButton extends StatefulWidget {
  FloatingAddButton({Key key}) : super(key: key);
  @override
  FloatingAddButtonState createState() => FloatingAddButtonState();
}

class FloatingAddButtonState extends State<FloatingAddButton> {
  final int maxButtons = 5;
  FloatingAddButtonState();

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

  void rebuild() {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    List <SpeedDialChild> speedDialChildren;
    if (MRData.rawDataTypes == null) {
      speedDialChildren = [];
      MRData.dataTypes.then((value) {
        rebuild();
      });
    } else {
      List<DocumentSnapshot> types = MRData.rawDataTypes;
      if (types.length > maxButtons) {
        types = types.getRange(0, maxButtons + 1).toList();
      }
      speedDialChildren = types.map((type) {
        return SpeedDialChild(
          child: Icon(Icons.date_range, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          label: type['name'],
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Theme.of(context).primaryColor,
          onTap: () async {
            final result = await  Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => NewDataPage(defaultType: type['name'])),
            );

            if (result != null) {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(result)));
            }
          },
        );
      }).toList();
      
    }

    return SpeedDial(
      marginBottom: 30,
      // animatedIcon: AnimatedIcons.event_add,
      // animatedIconTheme: IconThemeData(size: 18.0),
      child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: speedDialChildren,
    );
  }


}

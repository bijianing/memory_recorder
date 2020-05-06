import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



import 'view/new_data_type.dart';
import 'view/new_data.dart';
import 'view/view_data.dart';
import 'view/localization.dart';
import 'view/floating_add_button.dart';
import 'model/data_manager.dart';
import 'view/chip_select.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => MRLocalizations.of(context).title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        fontFamily: 'MPLUSRounded1c',
//        buttonColor: Colors.green[400],
        /*
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        )
        */
      ),
      localizationsDelegates: [
        const MRLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('zh', ''),
        const Locale('ja', ''),
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FloatingAddButtonState> _keyFloatingActionButton = GlobalKey();
  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      MRData.dataTypes;
      MRData.dataTypeChangeListenerKey = _keyFloatingActionButton;
    });
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          MRLocalizations.of(context).title,
        ),
      ),
      body: Builder(
      // Create an inner BuildContext so that the onPressed methods
      // can refer to the Scaffold with Scaffold.of().
      builder: (BuildContext context) {
        return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.view_comfy, size: 50),
            title: Text(MRLocalizations.of(context).addData),
            subtitle: Text(MRLocalizations.of(context).addDataDescription),
            onTap: () async {
                final result = await  Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => NewDataPage()),
                );

                if (result != null) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(result)));
                }
            },
          ),
          ListTile(
            leading: Icon(Icons.add_to_photos, size: 50),
            title: Text(MRLocalizations.of(context).addDataType),
            subtitle: Text(MRLocalizations.of(context).addDataTypeDescription),
            onTap: () async {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => NewDataTypePage()),
                );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, size: 50),
            title: Text(MRLocalizations.of(context).viewData),
            subtitle: Text(MRLocalizations.of(context).viewDataDescription),
            onTap: () async {
              await  Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => ViewDataPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, size: 50),
            title: Text('Test'),
            subtitle: Text('testing'),
            onTap: () async {
              await  Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => ChipSelectDemo()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline, size: 50),
            title: Text('dump firestore collections'),
            subtitle: Text('add new data'),
            onTap: () {
              // debug for firestore
              MRData.instance.dumpDb();
            },
          ),
        ],
      );
      }
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                MRLocalizations.of(context).title,
                style: Theme.of(context).primaryTextTheme.title,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text(
                MRLocalizations.of(context).addDataType,
              ),
              onTap: () {
//                Navigator.pop(context);
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => NewDataTypePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                MRLocalizations.of(context).setting,
              ),
              onTap: () {
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _BottomAppBar(
      //   [
      //     'travel: travel',
      //     'englist: english',
      //     'excises: exeeee'
      //     ]
      //   ),
      floatingActionButton: FloatingAddButton(key: _keyFloatingActionButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
/*
class _BottomAppBarButton extends StatelessWidget {
  const _BottomAppBarButton(this._text, this._table);

  final String _text;
  final String _table;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      
//        icon: Icon(Icons.add),
//        tooltip: _text,
        child: Text(_text,
          style: TextStyle(color: Colors.white)
        ),
//        shape: UnderlineInputBorder(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Theme.of(context).primaryColor,
//        color: Colors.grey,
        elevation: 12,
        onPressed: () {
          print('update $_table');
        });
  }
}

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar(
    this._btndata,
  );

  final List<String> _btndata;
  final double distance = 10.0;
  List<Widget> _createButtons() {
    List <_BottomAppBarButton> btns =
      _btndata.map(
        (dat) {
          List<String> splitData = dat.split(':');
          return _BottomAppBarButton(splitData[0], splitData[1]);
        }
      ).toList();
    List <Widget> ret = [];
    btns.forEach((b) {
      ret.add(b);
      ret.add(SpaceBox.width(distance));
    });
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(children: _createButtons()),
      color: Theme.of(context).primaryColor,
      notchMargin: 0,
    );
  }
}
*/


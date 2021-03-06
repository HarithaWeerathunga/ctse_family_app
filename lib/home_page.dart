import 'package:ctsefamilyapp/firestore.dart';
import 'package:ctsefamilyapp/fragments/family_member_fragment.dart';
import 'package:ctsefamilyapp/fragments/profile_fragment.dart';
import 'package:ctsefamilyapp/fragments/welcome_fragment.dart';
import 'package:flutter/material.dart';
import 'package:ctsefamilyapp/widgets/nav_drawer.dart';
import 'package:ctsefamilyapp/loginsignup/authentication.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth,this.store, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final BaseStore store;
  final VoidCallback onSignedOut;
  final String userId;

  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Profile", Icons.person),
    new DrawerItem("Family", Icons.favorite)
  ];

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new WelcomeFragment();
      case 1:
        return new ProfileFragment(
            userId: widget.userId, auth: widget.auth,store: widget.store, signOut: _signOut);
      case 2:
        return new FamilyMemberFragment();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];

    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("Ganesh Nayanajith"), accountEmail: null),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text('Family App'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: _signOut)
        ],
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}

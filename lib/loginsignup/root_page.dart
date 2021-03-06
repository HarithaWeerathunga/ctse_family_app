import 'package:ctsefamilyapp/firestore.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'package:ctsefamilyapp/loginsignup/login_sign_up_page.dart';
import 'package:ctsefamilyapp/home_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth,this.store});

  final BaseAuth auth;
  final BaseStore store;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  LOGGED_OUT,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.LOGGED_OUT;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      print('current user ' + user.uid);
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.LOGGED_OUT : AuthStatus.LOGGED_IN;
        print('authStatus ' + authStatus.toString());
        print('user?.uid ' + user?.uid.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return progressScreenWidget();
        break;
      case AuthStatus.LOGGED_OUT:
        return new LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new HomePage(
            userId: _userId,
            auth: widget.auth,
            store: widget.store,
            onSignedOut: _onSignedOut,
          );
        } else
          return progressScreenWidget();
        break;
      default:
        return progressScreenWidget();
    }
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.LOGGED_OUT;
      _userId = "";
    });
  }

  Widget progressScreenWidget() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

import 'package:demo_app/screens/list_screen.dart';
import 'package:demo_app/services/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'dart:async';

import 'common/alert_dialog.dart';
import 'common/offline_banner.dart';


// ignore: use_key_in_widget_constructors
class LoginScreen extends StatefulWidget {
  static const routeName = '/loginscreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _login = "";
  String _password = "";

  bool _obscureText = true;
  bool _enabledLoginButton = false;
  bool _disconnected = true;
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      final isEmailValid = _isEmailValid(_emailController.value.text);
      setState(() {
        _enabledLoginButton = (_password.isNotEmpty && isEmailValid && !_disconnected);
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isEmailValid(String value) {
    String pattern =
        r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 600.0,
              height: 800.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: OfflineBuilder(
                  connectivityBuilder: (
                      BuildContext context,
                      ConnectivityResult connectivity,
                      Widget child,
                      ) {
                    if (_disconnected = (connectivity == ConnectivityResult.none)) {
                      return Column(
                        children: [
                          const OfflineBanner(),
                          child,
                        ],
                      );
                    } else {
                      return child;
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text('LOGO', style: TextStyle(fontSize: 25),),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 28.0,
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          _login = value;
                        },
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                        style: const TextStyle(color: Colors.black),
                        onFieldSubmitted: (value) async {
                          _login = value;
                          await login(context);
                        },
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value != null) {
                            final isEmailValid = _isEmailValid(value);
                            if (!isEmailValid && value.isNotEmpty) {
                              return "Please enter a valid email.";
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                          onChanged: (value) {
                            final isEmailValid = _isEmailValid(_login);
                            setState(() {
                              _enabledLoginButton = (value.isNotEmpty && isEmailValid && !_disconnected);
                            });
                            _password = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: const TextStyle(fontSize: 15.0, color: Colors.grey),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ), onPressed: () {
                              _toggle();
                            },
                            ),
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          style: const TextStyle(color: Colors.black),
                          obscureText: _obscureText,
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) async {
                            _password = value;
                            await login(context);
                          }
                      ),
                      const SizedBox(
                        height: 7.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          color: _enabledLoginButton ? Colors.black : Colors.grey,
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                          elevation: 5.0,
                          child: RawMaterialButton(
                            onPressed: () async {
                              _enabledLoginButton ? await login(context) : null;
                            },
                            constraints: const BoxConstraints(minWidth: 200, minHeight: 42),
                            shape: const CircleBorder(),
                            child: const Text(
                              'Log In',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Center(child: Text("Or sign in with:", style: TextStyle(color: Colors.black, fontSize: 20),)),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage('assets/apple.png'),
                                )
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage('assets/google.png'),
                                )
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    var loggedIn = (_login == "test@test.com" && _password == "test");
    if (loggedIn) {
      NetworkManager().getAppList(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ListScreen(),
        ),
      );
    } else {
      showAlertDialog(context, "Login", "Unable to login.");
    }
  }
}
//TODO: validation   of _range1 and _range2, _0<range1<=_range2 and not empty and number
//TODO: add checkboxs for  _valueIsPos,_ansIsPos. Take their values as 0 and 1

// import 'package:abacus/screens/LoginScreen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:math';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:abacus/screens/ScoreScreen.dart';
import 'package:abacus/screens/SolveScreen.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class AdditionScreen extends StatefulWidget {
  final String user;

  AdditionScreen({this.user});

  @override
  _AdditionScreenState createState() => new _AdditionScreenState(user: user);
}

class _AdditionScreenState extends State<AdditionScreen> {
  TextEditingController _numberOfValues, _range1, _range2;
  bool alwaysPositive = false, useOnlyPositive = false;

  int _valueIsPos = 0, _ansIsPos = 1;
  final String user;
  _AdditionScreenState({
    Key key,
    @required this.user,
  });
  void initState() {
    super.initState();

    _numberOfValues = TextEditingController();
    _range1 = TextEditingController();
    _range2 = TextEditingController();
  }

  void dispose() {
    _numberOfValues.dispose();
    _range1.dispose();
    _range2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Addition & Subraction Setting"),
            ),
            body: new Container(
                padding: EdgeInsets.all(8.0),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        'Select the range of the digits',
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      new SizedBox(
                        height: 16,
                      ),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 120,
                              child: new TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                controller: _range1,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    labelText: "Range start",
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 120,
                              child: new TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                controller: _range2,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    labelText: "Range end",
                                    border: OutlineInputBorder()),
                              ),
                            ),
                          ]),
                      new SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: 250,
                        child: new TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CustomRangeTextInputFormatter(),
                          ],
                          controller: _numberOfValues,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              labelText: "Enter number of values",
                              hintText: "should be between 1-20",
                              border: OutlineInputBorder()),
                        ),
                      ),
                      new SizedBox(
                        height: 16,
                      ),

                      Container(
                        width: 300,
                        child: new CheckboxListTile(
                          title: const Text("Always Positive"),
                          secondary: const Icon(Icons.check),
                          value: alwaysPositive,
                          onChanged: (bool value) {
                            setState(() {
                              alwaysPositive = value ? true : false;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 300,
                        child: new CheckboxListTile(
                          title: const Text("Use only positive"),
                          secondary: const Icon(Icons.check),
                          value: useOnlyPositive,
                          onChanged: (bool value) {
                            setState(() {
                              useOnlyPositive = value ? true : false;
                            });
                          },
                        ),
                      ),
                      new RaisedButton(
                        onPressed: () => {
                          //print(alwaysPositive),
                          runApp(SolveApp(
                            user: user,
                            //numdig: _radioValue1,
                            //TODO: use alwaysPositive and useOnlyPositive
                            //They are bool
                            oper: 0,
                            noOfTimes: 1,
                            score: 0,
                            params: {
                              'numberOfValues': int.parse(_numberOfValues.text),
                              'range1': int.parse(_range1.text),
                              'range2': int.parse(_range2.text),
                              'valIsPos': _valueIsPos,
                              'ansIsPos': _ansIsPos,
                            },
                          )),
                        },
                        child: new Text(
                          'Start',
                          style: new TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        color: Theme.of(context).accentColor,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                      ),
                      // ])
                    ]))));
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '')
      return TextEditingValue();
    else if (int.parse(newValue.text) < 1)
      return TextEditingValue().copyWith(text: '1');

    return int.parse(newValue.text) > 20
        ? TextEditingValue().copyWith(text: '20')
        : newValue;
  }
}

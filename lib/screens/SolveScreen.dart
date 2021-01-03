import 'package:abacus/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:abacus/screens/ScoreScreen.dart';
import 'package:abacus/Variables.dart';

// ----------------------------------------------------------------------------------
// main logic
var maxMap = {
  '1': 9,
  '2': 99,
  '3': 999,
  '4': 9999,
  '5': 99999,
  '6': 999999,
  '7': 9999999,
};
var minMap = {
  '0': 0,
  '1': 0,
  '2': 10,
  '3': 100,
  '4': 1000,
  '5': 10000,
  '6': 100000,
  '7': 1000000
};
var rng = new Random();

List multiplyString(var params) {
  int _range1 = params['range1'], _range2 = params['range2'];

  int _lowerNumMin = minMap[_range1.toString()];
  int _upperNumMin = minMap[_range2.toString()];
  int _lowerNumMax = maxMap[_range1.toString()];
  int _upperNumMax = maxMap[_range2.toString()];
  //generic algo to generate random number between min and max.
  int num1 = rng.nextInt(_lowerNumMax - _lowerNumMin + 1) + _lowerNumMin;
  int num2 = rng.nextInt(_upperNumMax - _upperNumMin + 1) + _upperNumMin;
  int res = num1 * num2;
  return [res.toString(), num1.toString() + '*' + num2.toString()];
}

/*
_numberOfValues = number of numbers in a sum
_range1 = min number of digits in the sum
_range2 = max number of digits in the sum
_valueIsPos = each number will be positive if it is 1
_ansIsPos = intermediate and final result will be positive if 1
*/
List addString(var params) {
  int _numberOfValues = params['numberOfValues'],
      _range1 = params['range1'],
      _range2 = params['range2'],
      _valueIsPos = params['valIsPos'],
      _ansIsPos = params['ansIsPos'];
  int _lowerNum = minMap[_range1.toString()];
  int _upperNum = maxMap[_range2.toString()];

  int res = rng.nextInt(_upperNum - _lowerNum + 1) + _lowerNum;
  String question = res.toString();

  for (int i = 0; i < _numberOfValues - 1; i++) {
    int _num = rng.nextInt(_upperNum - _lowerNum + 1) + _lowerNum;
    int sign = rng.nextInt(2);
    // 0 for sub and 1 for add
    if (_valueIsPos == 0 && sign == 0) {
      //when subtraction is allowed
      if ((_ansIsPos == 1 && res - _num >= 0) || _ansIsPos == 0) {
        //when result is positive or negative result is allowed
        res = res - _num;
        question = question + Variables().minusCharacter + _num.toString();
      } else {
        //when result is getting negative but it shouldn't
        res = res + _num;
        question = question + '+' + _num.toString();
      }
    } else {
      res = res + _num;
      question = question + '+' + _num.toString();
    }
  }

  return [res.toString(), question];
}

final FlutterTts flutterTts = FlutterTts();

_speak(String text) async {
  // await flutterTts.setLanguage(language)
  // await flutterTts.setPitch(pitch)

  await flutterTts.speak(text);
  // textEditingController.text = '';
}

// ----------------------------------------------------------------------------------

class SolveApp extends StatelessWidget {
  int numdig, oper, noOfTimes, score;
  int currRes;
  final String user;
  TextEditingController answerController = TextEditingController();
  var params;
  SolveApp({
    Key key,
    @required this.user,
    this.numdig,
    this.oper,
    this.noOfTimes,
    this.score,
    this.params,
  }) : super(key: key);
  String sumtext = '';

  //function to do generate the sum
  String callOper() {
    List finalres;
    if (oper == 0) {
      finalres = addString(params);
    } else {
      finalres = multiplyString(params);
    }
    String result = finalres[0];
    String question_tts = finalres[1];
    currRes = int.parse(result);

    _speak(question_tts);
    return question_tts;
  }

  String btnText(int noOfTimes) {
    if (noOfTimes >= 4) return 'Finish';
    return 'Next';
  }

  Widget btnFunction(int noOfTimes, int result) {
    String answerString = answerController.text;
    // if (answerString == '') checkfornumber and give pop
    int answer = int.parse(answerString);
    if (answer == currRes) score++;
    if (noOfTimes >= 4) return (ScoreScreen(user: user, score: score));

    return (SolveApp(
      user: user,
      numdig: numdig,
      oper: oper,
      noOfTimes: noOfTimes + 1,
      score: score,
      params: params,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            body: new Container(
                padding: EdgeInsets.all(8.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      callOper(),
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      "Question No " + noOfTimes.toString(),
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      "Score is " + score.toString(),
                      style: new TextStyle(fontSize: 16.0),
                    ),

                    TextField(
                      controller: answerController,
                      decoration:
                          new InputDecoration(hintText: "Enter Your Answer"),
                    ),
                    SizedBox(height: 50),
                    RaisedButton(
                      onPressed: () => runApp(btnFunction(noOfTimes, score)),
                      child: Text(
                        'Check Answer',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),

                    RaisedButton(
                      onPressed: () => runApp(btnFunction(noOfTimes, score)),
                      child: Text(
                        btnText(noOfTimes),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),

                    // Container(
                    //   width: 120,
                    //   child: FlatButton(
                    //     child: Text("Logout"),
                    //     textColor: Colors.white,
                    //     padding: EdgeInsets.all(16),
                    //     onPressed: () async {
                    //       SharedPreferences prefs =
                    //           await SharedPreferences.getInstance();
                    //       prefs.clear();
                    //       FirebaseAuth.instance.signOut();
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => LoginScreen()));
                    //     },
                    //     color: Colors.blue,
                    //     shape: new RoundedRectangleBorder(
                    //         borderRadius: new BorderRadius.circular(5.0)),
                    //   ),
                    // )
                  ],
                ))));
  }
}
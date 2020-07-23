import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iquiz/QuestionModel.dart';
import 'package:iquiz/main.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'States.dart';

class Controller {
  List<Widget> finish() {
    List<Widget> list = [];
    list.add(
      SizedBox(
        height: 30,
      ),
    );
    list.add(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          color: Colors.deepOrange,
          boxShadow: [
            BoxShadow(color: Colors.deepOrange, spreadRadius: 0),
          ],
        ),
        height: 25,
        width: 200,
        child: Center(
          child: Text(
            'Your Answers',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
    String myinputs = States.inputs;
    list.add(
      SizedBox(
        height: 20,
      ),
    );
    for (var i = 0; i < myinputs.length; i++) {
      int k = i + 1;
      if (myinputs[i] == 'T') {
        list.add(
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: Colors.green,
              boxShadow: [
                BoxShadow(color: Colors.green, spreadRadius: 0),
              ],
            ),
            height: 25,
            width: 250,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Center(
              child: Text(
                'Question $k  :  True',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      } else {
        list.add(
          Container(
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: Colors.red,
              boxShadow: [
                BoxShadow(color: Colors.red, spreadRadius: 0),
              ],
            ),
            height: 25,
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Center(
              child: Text(
                'Question $k  :  False',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }
    }
    int m = evaluate().round();
    list.add(
      SizedBox(
        height: 30,
      ),
    );
    list.add(
      CircularPercentIndicator(
        radius: 160.0,
        lineWidth: 10.0,
        fillColor: Color(0x00000000),
        animation: true,
        circularStrokeCap: CircularStrokeCap.round,
        animationDuration: 3900,
        backgroundColor: Colors.red,
        progressColor: Colors.green,
        percent: m / 100.0,
        center: FutureBuilder(
          future: Future.delayed(Duration(seconds: 4)),
          builder: (c, s) => s.connectionState == ConnectionState.done
              ? Text("$m %",
                  style: TextStyle(color: Colors.green, fontSize: 40))
              : Text(
                  "Evaluating...",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
        ),
      ),
    );
    list.add(
      SizedBox(
        height: 30,
      ),
    );

    return list;
  }

  int getcurrentquestionno() {
    return States.CurrentQuestion;
  }

  double evaluate() {
    double result = 0;
    List<Question> list = States.list;
    String myansweres = States.inputs;
    for (int i = 0; i < list.length; i++) {
      if (myansweres[i] == list[i].getanswere()) {
        result += 100.0 / (list.length);
      }
    }
    return result;
  }

  String getquestion(int c) {
    return States.list[c].getquestion();
  }

  void increasequestionno() {
    States.CurrentQuestion++;
  }

  void saveanswere(String ans) {
    States.inputs = States.inputs + ans;
  }

  String youransweres() {
    return States.inputs;
  }

  bool set(String id, String name) {
    try {
      States.quizid = id;
      States.name = name;
      States.start_time = DateTime.now().millisecondsSinceEpoch.toString();
      States.CurrentQuestion = 0;
      States.inputs = '';
      States.list = [];

      fetch();
      return true;
    } on Exception catch (error) {
      return false;
    }
  }

  bool hasquestion() {
    if (States.CurrentQuestion < States.list.length) {
      return true;
    }
    return false;
  }

  void fetch() async {
    try {
      List<Question> li = [];
      FirebaseDatabase database = FirebaseDatabase.instance;
      database.setPersistenceEnabled(false);
      await database
          .reference()
          .child(States.quizid)
          .once()
          .then((DataSnapshot snap) {
        var keys = snap.value.keys;
        var data = snap.value;
        for (var key in keys) {
          Question q = Question(
            data[key][0],
            data[key][1],
          );
          print(q.getquestion());
          li.add(q);
        }
      });
      States.list = li;
    } on Exception catch (error) {
      throw new Exception(error.toString());
    }
  }
}

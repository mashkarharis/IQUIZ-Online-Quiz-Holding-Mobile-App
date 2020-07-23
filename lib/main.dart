import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iquiz/Controller.dart';
import 'package:iquiz/QuestionModel.dart';

import 'States.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => FirstScreen(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/second': (context) => SecondScreen(),
    },
  ));
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreen createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return start();
  }

  showAlertDialog(
      BuildContext context, String title, String text, String button) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("$button"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("$title"),
      content: Text("$text"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog1(
      BuildContext context, String title, String text, String button) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("$button"),
      onPressed: () {
        sleep(Duration(seconds: 1));
        if (States.list.length == 0) {
          Navigator.of(context).pop();
          showAlertDialog(context, "Error",
              "Check Connection and Make sure inputs are correct", "Retry");
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/second', (Route<dynamic> route) => false);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("$title"),
      content: Text("$text"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget start() {
    return SafeArea(
      child: Scaffold(
        body: View(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            'IQuiz',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget AppBarBottom() {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.black87,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                blurRadius: 1.0,
                color: Colors.red.shade900,
                spreadRadius: 4,
              ),
              BoxShadow(
                blurRadius: 1.0,
                color: Colors.green.shade900,
                spreadRadius: 2,
              )
            ],
            borderRadius: BorderRadius.vertical(
                bottom:
                    Radius.elliptical(MediaQuery.of(context).size.width, 50.0)),
          ),
        ),
      ),
    );
  }

  TextEditingController idController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  Widget View() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppBarBottom(),
        Expanded(
          flex: 15,
          child: Container(
            color: Colors.black87,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 120,
                    color: Colors.transparent,
                  ),
                  Container(
                    height: 50,
                    color: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'WELCOME TO IQUIZ',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    color: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: idController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 12),
                          hintText: 'QUIZ ID',
                          suffixIcon: Icon(Icons.ac_unit),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(20, -3, 20, 0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    color: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 12),
                          hintText: 'NAME',
                          suffixIcon: Icon(Icons.line_style),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(20, -3, 20, 0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    height: 30,
                    color: Colors.transparent,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        bool settingpaper;
                        setState(() {
                          settingpaper = Controller()
                              .set(idController.text, nameController.text);
                        });

                        if (settingpaper &
                            (idController.text != '') &
                            (nameController.text != '')) {
                          sleep(Duration(seconds: 1));
                          showAlertDialog1(
                              context, "IQUIZ", "Are You Ready ?", "Continue");
                        } else {
                          showAlertDialog(context, "Error",
                              "Check Connection and inputs", "Retry");
                        }
                      },
                      color: Colors.green,
                      child: Text('Start'),
                    ),
                  ),
                  Container(
                    height: 120,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreen createState() => _SecondScreen();
}

class _SecondScreen extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return start();
  }

  Widget start() {
    return SafeArea(
      child: Scaffold(
        body: View(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            'IQuiz',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget AppBarBottom(int $f) {
    return Expanded(
      flex: $f,
      child: Container(
        color: Colors.black87,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                blurRadius: 1.0,
                color: Colors.red.shade900,
                spreadRadius: 4,
              ),
              BoxShadow(
                blurRadius: 1.0,
                color: Colors.green.shade900,
                spreadRadius: 2,
              )
            ],
            borderRadius: BorderRadius.vertical(
                bottom:
                    Radius.elliptical(MediaQuery.of(context).size.width, 50.0)),
          ),
        ),
      ),
    );
  }

  Widget View() {
    int c = (Controller().getcurrentquestionno());
    print(c);
    bool hasquestion = Controller().hasquestion();
    if (hasquestion) {
      String question = Controller().getquestion(c);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppBarBottom(2),
          Expanded(
            flex: 14,
            child: Container(
              color: Colors.black87,
              child: Center(
                child: Text(
                  '$question',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  setState(() {
                    Controller().increasequestionno();
                    Controller().saveanswere('T');
                  });
                },
                color: Colors.green,
                child: Text('True'),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  setState(() {
                    Controller().increasequestionno();
                    Controller().saveanswere('F');
                  });
                },
                color: Colors.red,
                child: Text('False'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black87,
              child: Row(
                children: <Widget>[],
              ),
            ),
          )
        ],
      );
    } else {
      String youransweres = Controller().youransweres();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppBarBottom(1),
          Expanded(
            flex: 9,
            child: Container(
              color: Colors.black87,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: Controller().finish(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                },
                color: Colors.green,
                child: Text('Finish'),
              ),
            ),
          ),
        ],
      );
    }
  }
}

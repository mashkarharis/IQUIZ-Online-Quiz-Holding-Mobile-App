class Question {
  String Questiontext;
  String Answere;
  Question(String q, String a) {
    Questiontext = q;
    Answere = a;
  }

  String getquestion() {
    return Questiontext;
  }

  String getanswere() {
    return Answere;
  }
}

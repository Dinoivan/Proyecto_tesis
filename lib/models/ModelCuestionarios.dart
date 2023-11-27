class Option {
  final int id;
  final String optionText;
  final int order;

  Option(this.id, this.optionText, this.order);
}

class Question {
  final int id;
  final String questionText;
  final int order;
  final List<Option> options;

  Question(this.id, this.questionText, this.order, this.options);
}
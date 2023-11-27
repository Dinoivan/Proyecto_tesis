class CuestionarioModel{
  final String answerText;
  final int optionId;
  final int questionId;

  CuestionarioModel({
    required this.answerText,
    required this.optionId,
    required this.questionId,
  });

  Map<String,dynamic> toJson(){
    return {
      'answerText': answerText,
      'optionId':  optionId,
      'questionId': questionId
    };
  }
}

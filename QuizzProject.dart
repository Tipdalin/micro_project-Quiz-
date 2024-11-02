import 'dart:io';

class Quiz {
  final List<ParticipantResult> participants = [];
  final List<Question> questions = [];

  void addQuestion(Question question) {
    questions.add(question);
  }

  void addParticipant(ParticipantResult participant) {
    participants.add(participants as ParticipantResult);
  }

  void calculateScore(
      ParticipantResult participant, List<List<String>> answers) {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].isCorrect(answers[i])) {
        score++;
      }
    }
    participant.score = score;
    print(
        "\n${participant.firstName} ${participant.lastName}, your score is: $score/${questions.length}");
  }
}

class ParticipantResult {
//Constructor
  ParticipantResult({required this.firstName, required this.lastName});

  final String firstName;
  final String lastName;

  int _score = 0;

//getter
  int get score => _score;

  set score(int value) => _score = value;
}

abstract class Question {
  Question(this.title, this.options);

  final List<String> options;
  final String title;

  bool isCorrect(List<String> userAnswers);
}

class SingleChoice extends Question {
  SingleChoice(String title, List<String> options, this.correctAnswer)
      : super(title, options);

  final String correctAnswer;

  @override
  bool isCorrect(List<String> userAnswers) {
    // TODO: implement isCorrect
    return userAnswers.length == 1 && userAnswers[0] == correctAnswer;
  }
}

class MultipleChoice extends Question {
  MultipleChoice(String title, List<String> options, this.correctAnswers)
      : super(title, options);

  final List<String> correctAnswers;

  @override
  bool isCorrect(List<String> userAnswers) {
    // TODO: implement isCorrect
    return Set<String>.from(userAnswers).containsAll(correctAnswers) &&
        Set<String>.from(correctAnswers).containsAll(userAnswers);
  }
}

void main(List<String> args) {
  final quiz = Quiz();

  //Adding some question
  quiz.addQuestion(SingleChoice(
      "What is the capital city of Cambodia?",
      [
        "Kandal",
        "Battambang",
        "Phnom Penh",
        "Siem Reap",
      ],
      "Phnom Penh"));

  quiz.addQuestion(
      MultipleChoice("Which of these languages are spoken in Cambodia?", [
    "Khmer",
    "Chinese",
    "Thai",
    "English",
  ], [
    "Khmer",
    "English"
  ]));

  quiz.addQuestion(SingleChoice(
      " Who was the famous king that built Angkor Wat?",
      [
        "King Ang Duong",
        "King Jayavarman VII",
        "King Norodom Sihanouk",
        "King Suryavarman II",
      ],
      "King Suryavarman II"));

  quiz.addQuestion(
      MultipleChoice(" Which countries share a border with Cambodia?", [
    "Thailand",
    "Vietnam",
    "China",
    "Laos",
  ], [
    "Thailand",
    "Vietnam",
    "Laos"
  ]));

  quiz.addQuestion(SingleChoice(
      "What is the currency of Cambodia?",
      [
        "Dollar",
        "Riel",
        "Dong",
        "Baht",
      ],
      "Riel"));

  //Participant
  print("Enter your First name : ");
  String firstName = stdin.readLineSync()!;
  print("Enter your Last name : ");
  String lastName = stdin.readLineSync()!;
  final participant =
      ParticipantResult(firstName: firstName, lastName: lastName);

  //Question And Answer
  final List<List<String>> answers = [];
  for (Question question in quiz.questions) {
    print("\n${question.title}");
    for (int i = 0; i < question.options.length; i++) {
      print("${i + 1}: ${question.options[i]}");
    }
    if (question is SingleChoice) {
      print('Choose your answer: ');
      String answer = question.options[int.parse(stdin.readLineSync()!) - 1];
      answers.add([answer]);
    } else if (question is MultipleChoice) {
      print('Input your answers(Ex: 1,2):');
      List<String> userInput = stdin.readLineSync()!.split(',');
      List<String> answer = userInput
          .map((e) => question.options[int.parse(e.trim()) - 1])
          .toList();
      answers.add(answer);
    }
  }
  quiz.calculateScore(participant, answers);
}

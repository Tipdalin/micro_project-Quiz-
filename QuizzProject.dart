import 'dart:io';

class Quiz {
  final List<ParticipantResult> participants = [];
  final List<Question> questions = [];

  void addQuestion(Question question) {
    questions.add(question);
  }

  void addParticipant(ParticipantResult participant) {
    participants.add(participant);
  }

  void calculateScore(ParticipantResult participant, List<List<String>> answers) {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].isCorrect(answers[i])) {
        score++;
      }
    }
    participant.score = score;
    print("\n${participant.firstName} ${participant.lastName}, your score is: $score/${questions.length}");
  }
}

class ParticipantResult {
  ParticipantResult({required this.firstName, required this.lastName});

  final String firstName;
  final String lastName;
  int _score = 0;

  int get score => _score;
  set score(int value) => _score = value;
}

abstract class Question {
  Question(this.title, this.options);

  final String title;
  final List<String> options;

  bool isCorrect(List<String> userAnswers);
}

class SingleChoice extends Question {
  SingleChoice(String title, List<String> options, this.correctAnswer) : super(title, options);

  final String correctAnswer;

  @override
  bool isCorrect(List<String> userAnswers) {
    return userAnswers.length == 1 && userAnswers[0] == correctAnswer;
  }
}

class MultipleChoice extends Question {
  MultipleChoice(String title, List<String> options, this.correctAnswers) : super(title, options);

  final List<String> correctAnswers;

  @override
  bool isCorrect(List<String> userAnswers) {
    final userSet = Set<String>.from(userAnswers);
    final correctSet = Set<String>.from(correctAnswers);
    return userSet.length == correctSet.length && userSet.containsAll(correctSet);
  }
}

void main() {
  final quiz = Quiz();
  addSampleQuestions(quiz);

  bool moreParticipants = true;
  while (moreParticipants) {
    final participant = getParticipantInfo();
    final answers = collectAnswers(quiz.questions);
    quiz.calculateScore(participant, answers);
    quiz.addParticipant(participant);

    print("\nWould another participant like to take the quiz? (yes/no): ");
    String? response = stdin.readLineSync();
    moreParticipants = response?.toLowerCase() == 'yes';
  }

  print("\nQuiz has ended. Here are the scores of all participants:");
  for (var participant in quiz.participants) {
    print("${participant.firstName} ${participant.lastName}: ${participant.score}");
  }
}

void addSampleQuestions(Quiz quiz) {
  quiz.addQuestion(SingleChoice(
    "1. What is the capital city of Cambodia?",
    ["Kandal", "Battambang", "Phnom Penh", "Siem Reap"],
    "Phnom Penh",
  ));
  quiz.addQuestion(MultipleChoice(
    "2. Which of these languages are spoken in Cambodia?",
    ["Khmer", "Chinese", "Thai", "English"],
    ["Khmer", "English"],
  ));
  quiz.addQuestion(SingleChoice(
    "3. Who was the famous king that built Angkor Wat?",
    ["King Ang Duong", "King Jayavarman VII", "King Norodom Sihanouk", "King Suryavarman II"],
    "King Suryavarman II",
  ));
  quiz.addQuestion(MultipleChoice(
    "4. Which countries share a border with Cambodia?",
    ["Thailand", "Vietnam", "China", "Laos"],
    ["Thailand", "Vietnam", "Laos"],
  ));
  quiz.addQuestion(SingleChoice(
    "5. What is the currency of Cambodia?",
    ["Dollar", "Riel", "Dong", "Baht"],
    "Riel",
  ));
}

ParticipantResult getParticipantInfo() {
  print("Enter your First name: ");
  String firstName = stdin.readLineSync() ?? "Guest";
  print("Enter your Last name: ");
  String lastName = stdin.readLineSync() ?? "User";
  return ParticipantResult(firstName: firstName, lastName: lastName);
}

List<List<String>> collectAnswers(List<Question> questions) {
  final List<List<String>> answers = [];

  for (Question question in questions) {
    print("\n${question.title}");
    for (int i = 0; i < question.options.length; i++) {
      print("${i + 1}: ${question.options[i]}");
    }

    if (question is SingleChoice) {
      answers.add(getSingleChoiceAnswer(question));
    } else if (question is MultipleChoice) {
      answers.add(getMultipleChoiceAnswer(question));
    }
  }
  return answers;
}

List<String> getSingleChoiceAnswer(SingleChoice question) {
  while (true) {
    try {
      print("Choose your answer: ");
      int index = int.parse(stdin.readLineSync()!);
      if (index >= 1 && index <= question.options.length) {
        return [question.options[index - 1]];
      }
    } catch (_) {}
    print("Invalid input. Please enter a valid option number.");
  }
}

List<String> getMultipleChoiceAnswer(MultipleChoice question) {
  while (true) {
    try {
      print("Input your answers (e.g., 1,2): ");
      List<String> userInput = stdin.readLineSync()!.split(',');
      List<String> answer = userInput
          .map((e) => question.options[int.parse(e.trim()) - 1])
          .toList();
      return answer;
    } catch (_) {
      print("Invalid input. Please enter valid option numbers separated by commas.");
    }
  }
}

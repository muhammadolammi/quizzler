import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizzler/main.dart';
import 'package:quizzler/methods/question_brain.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  void showAnswer(int points, int totalpoints) {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              backgroundColor: Colors.transparent,
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                        color: Colors.blue,
                        height: 20,
                        child: const Text(
                          'You Scored',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.orange),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$points',
                            style: const TextStyle(
                                fontSize: 35, color: Colors.green),
                          ),
                          const Divider(
                            color: Colors.red,
                            thickness: 5,
                            indent: 30,
                            endIndent: 30,
                          ),
                          Text(
                            '$totalpoints',
                            style: const TextStyle(
                                fontSize: 35, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Start Again',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  Questionbrain questionbrain = Questionbrain();

  void mark(bool userPickedAnswer) {
    Questionbrain qbrain = Questionbrain();
    List<Icon> scoreKeeper = ref.read(scoreKeeperProvider.notifier).state;
    int questionNumber = ref.read(questionNumberProvider);
    bool answer = questionbrain.getAnswer(questionNumber);
    int points = ref.read(pointProvider);
    int totalpoints = qbrain.questionLenght() + 1;
    if (questionNumber < 11 && userPickedAnswer == answer) {
      ref.read(pointProvider.notifier).increasePoints();

      scoreKeeper.add(const Icon(
        Icons.check,
        color: Colors.green,
      ));
    } else if (questionNumber < 11 && userPickedAnswer != answer) {
      scoreKeeper.add(const Icon(
        Icons.cancel,
        color: Colors.red,
      ));
    } else {
      showAnswer(points, totalpoints);
      scoreKeeper.clear();
      ref.read(pointProvider.notifier).defaultPoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    int questionNumber = ref.watch(questionNumberProvider);
    List<Icon> scoreKeeper = ref.watch(scoreKeeperProvider);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    questionbrain.getQuestion(questionNumber).toString(),
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'True',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  onPressed: () {
                    mark(true);
                    ref.read(questionNumberProvider.notifier).nextQuestion();
                  },
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'False',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  onPressed: () {
                    mark(false);
                    ref.read(questionNumberProvider.notifier).nextQuestion();
                  },
                ),
              )),
          Row(
            children: scoreKeeper,
          ),
        ],
      ),
    );
  }
}

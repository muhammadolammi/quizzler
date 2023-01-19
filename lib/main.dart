import 'package:flutter/material.dart';
import 'package:quizzler/pages/quizpage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quizzler/methods/question_brain.dart';

final questionNumberProvider =
    StateNotifierProvider<QuestionNumber, int>(((ref) => QuestionNumber()));
final scoreKeeperProvider =
    StateNotifierProvider<ScoreKeeper, List<Icon>>(((ref) {
  return ScoreKeeper();
}));

final pointProvider =
    StateNotifierProvider<QuestionPoints, int>(((ref) => QuestionPoints()));

void main() => runApp(ProviderScope(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const QuizPage(),
      },
    )));

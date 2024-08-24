import 'package:flutter/material.dart';
import 'package:live_score_application/ui/screens/match_screen_list.dart';


class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MatchScreenList(),
    );
  }

}
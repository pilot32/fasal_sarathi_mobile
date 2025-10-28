import 'package:fasal_sarathi_mobile/screen.questions/soilquestion.dart';
import 'package:flutter/material.dart';

import 'WaterQuestions.dart';
import 'grassquestion.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Questions screen'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                // Navigator.push();
              },
              icon: Icon(Icons.skip_next),
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.water, color: Colors.green)),
              Tab(icon: Icon(Icons.grass, color: Colors.green)),
              Tab(icon: Image.asset("assets/icons/icons_question/soil.png",width: 28,height: 28,fit: BoxFit.contain,)),
            ],
          ),
        ),
        body: const TabBarView(children: [
          WaterQuestions(),

          GrassQuestion(),

          SoilQuestion()
        ]),
      ),
    );
  }
}

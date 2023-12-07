import 'package:workout_app/common_widget/round_button.dart';
import 'package:workout_app/view/meal_planner/meal_planner_view.dart';
import 'package:workout_app/view/workout_tracker/workout_tracker_view.dart';
import 'package:flutter/material.dart';

import '../sleep_tracker/sleep_tracker_view.dart';

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundButton(
                title: "Rastreador de Treino",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutTrackerView(),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            RoundButton(
                title: "Plano de Refeições",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MealPlannerView(),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            RoundButton(
                title: "Rastreador de Sono",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SleepTrackerView(),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

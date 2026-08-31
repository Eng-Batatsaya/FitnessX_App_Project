import 'package:flutter/material.dart';
import 'workout_step_item.dart';

class WorkoutStepsList extends StatelessWidget {
  const WorkoutStepsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        WorkoutStepItem(
          number: "01",
          title: "Spread Your Arms",
          description: "To make the gestures feel more relaxed, stretch your arms as you start this movement. No bending of hands.",
          showLine: true,
        ),
        WorkoutStepItem(
          number: "02",
          title: "Rest at The Toe",
          description: "The basis of this movement is jumping. Now, what needs to be considered is that you have to use the tips of your feet",
          showLine: true,
        ),
        WorkoutStepItem(
          number: "03",
          title: "Adjust Foot Movement",
          description: "Jumping Jack is not just an ordinary jump. But, you also have to pay close attention to leg movements.",
          showLine: true,
        ),
        WorkoutStepItem(
          number: "04",
          title: "Clapping Both Hands",
          description: "This cannot be taken lightly. You see, without realizing it, the clapping of your hands helps you to keep your rhythm while doing the Jumping Jack",
          showLine: false,
        ),
      ],
    );
  }
}

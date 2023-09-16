import 'package:flutter/material.dart';
import 'package:demo_status/models/story_model.dart';
import 'package:demo_status/widget/animated_bar_widget.dart';

class StoryStatusBarWidget extends StatelessWidget {
  const StoryStatusBarWidget({
    required this.stories,
    required this.animController,
    required this.currentIndex,
    super.key,
  });

  final List<Story> stories;
  final AnimationController animController;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: stories
          .asMap()
          .map((i, e) {
            return MapEntry(
              i,
              AnimatedBarWidget(
                animController: animController,
                position: i,
                currentIndex: currentIndex,
                key: null,
              ),
            );
          })
          .values
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';

class AnimatedBarWidget extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBarWidget({
    required this.animController,
    required this.position,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                AnimatedBarContainer(
                    width: double.infinity,
                    color: position < currentIndex
                        ? Colors.white
                        : Colors.white.withOpacity(0.5)),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return AnimatedBarContainer(
                              width:
                                  constraints.maxWidth * animController.value,
                              color: Colors.white);
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AnimatedBarContainer extends StatelessWidget {
  const AnimatedBarContainer({
    super.key,
    required this.width,
    required this.color,
  });

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}

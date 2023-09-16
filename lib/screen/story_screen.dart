import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_status/models/story_model.dart';
import 'package:demo_status/widget/story_status_bar_widget.dart';
import 'package:demo_status/widget/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryScreen extends StatefulWidget {
  final List<Story> stories;

  const StoryScreen({super.key, required this.stories});

  @override
  StoryScreenState createState() => StoryScreenState();
}

class StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController pageController;
  late AnimationController animationController;
  late VideoPlayerController? videoController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    animationController = AnimationController(vsync: this);

    final Story firstStory = widget.stories.first;
    loadStory(story: firstStory, animateToPage: false);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.stop();
        animationController.reset();
        setState(() {
          if (currentIndex + 1 < widget.stories.length) {
            currentIndex += 1;
            loadStory(story: widget.stories[currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            currentIndex = 0;
            loadStory(story: widget.stories[currentIndex]);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    animationController.dispose();
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Story story = widget.stories[currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => onTapDown(details, story),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, i) {
                final Story story = widget.stories[i];
                switch (story.media) {
                  case MediaType.image:
                    return CachedNetworkImage(
                      imageUrl: story.url,
                      fit: BoxFit.cover,
                    );
                  case MediaType.video:
                    if (videoController != null &&
                        videoController!.value.isInitialized) {
                      return FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: videoController?.value.size.width,
                          height: videoController?.value.size.height,
                          child: VideoPlayer(videoController!),
                        ),
                      );
                    }
                }
                return const SizedBox.shrink();
              },
            ),
            Positioned(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: <Widget>[
                  StoryStatusBarWidget(
                    stories: widget.stories,
                    animController: animationController,
                    currentIndex: currentIndex,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.5,
                      vertical: 10.0,
                    ),
                    child: UserInfoWidget(story),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (currentIndex - 1 >= 0) {
          currentIndex -= 1;
          loadStory(story: widget.stories[currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (currentIndex + 1 < widget.stories.length) {
          currentIndex += 1;
          loadStory(story: widget.stories[currentIndex]);
        } else {
          // Out of bounds - loop story
          // You can also Navigator.of(context).pop() here
          currentIndex = 0;
          loadStory(story: widget.stories[currentIndex]);
        }
      });
    } else {
      if (story.media == MediaType.video) {
        if (videoController!.value.isPlaying) {
          videoController!.pause();
          animationController.stop();
        } else {
          videoController!.play();
          animationController.forward();
        }
      }
    }
  }

  void loadStory({required Story story, bool animateToPage = true}) {
    animationController.stop();
    animationController.reset();
    switch (story.media) {
      case MediaType.image:
        animationController.duration = story.duration;
        animationController.forward();
        break;
      case MediaType.video:
        videoController = null;
        videoController?.dispose();
        videoController = VideoPlayerController.network(story.url)
          ..initialize().then((_) {
            setState(() {});
            if (videoController!.value.isInitialized) {
              animationController.duration = videoController!.value.duration;
              videoController!.play();
              animationController.forward();
            }
          });
        break;
    }
    if (animateToPage) {
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

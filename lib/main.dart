import 'package:demo_status/screen/story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_status/helper/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Story Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StoryScreen(stories: staticStories),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_status/helper/utils.dart';
import 'package:demo_status/models/story_model.dart';
import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  final Story story;

  const UserInfoWidget(this.story, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey[300],
          backgroundImage: CachedNetworkImageProvider(
            story.user.profileImageUrl,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            story.user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        InkWell(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.save_rounded,
              size: 30.0,
              color: Colors.white,
            ),
          ),
          onTap: () {
            downloadFiles(story.url, context);
          },
        ),
      ],
    );
  }
}

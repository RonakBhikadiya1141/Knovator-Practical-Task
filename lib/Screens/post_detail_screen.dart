import 'package:flutter/material.dart';

import '../Models/get_all_post_model.dart';

class PostDetailScreen extends StatefulWidget {
  GetAllPostModel? post;
  PostDetailScreen({super.key, this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1.5),
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
          child: Column(children: [
            Row(
              children: [
                Flexible(
                    child: Text(
                  widget.post?.title ?? '',
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.visible,
                ))
              ],
            ),
            Row(
              children: [
                Flexible(
                    child: Text(
                  widget.post?.body ?? '',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300),
                  overflow: TextOverflow.visible,
                ))
              ],
            )
          ]),
        )
      ]),
    );
  }
}

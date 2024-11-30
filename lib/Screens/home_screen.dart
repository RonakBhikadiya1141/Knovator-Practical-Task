// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:demo/Const/app_string.dart';
import 'package:demo/Screens/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Bloc/GetAllPost_Bloc/get_all_post_cubit.dart';
import '../Bloc/GetAllPost_Bloc/get_all_post_state.dart';
import '../Models/get_all_post_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GetAllPostModel> postData = [];
  @override
  initState() {
    init();

    super.initState();
  }

  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = prefs.getString('postData');

    if (data != null) {
      postData = getallPostFromjsonMethod(jsonDecode(data));
      setState(() {});
    }
    // ignore: use_build_context_synchronously
    await BlocProvider.of<GetAllPostCubit>(context).getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppString.posts)),
        body: BlocConsumer<GetAllPostCubit, GetAllPostState>(
            listener: (context, state) async {
          if (state is GetAllPostErrorState) {
            SnackBar snackBar = const SnackBar(
              content: Text(AppString.someThingWentWrong),
            );
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

          if (state is GetAllPostLoadedState) {
            if (postData.isEmpty) {
              postData = state.getAllPostModel;
            }
            for (var item in state.getAllPostModel) {
              bool exists =
                  postData.any((existingItem) => existingItem.id == item.id);

              if (!exists) {
                postData.add(item); // Add only new data
              }
            }
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            prefs.setString('postData', jsonEncode(postData));
          }
        }, builder: (context, state) {
          return postData.isNotEmpty
              ? ListView.builder(
                  itemCount: postData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        if (postData[index].isRead == false) {
                          setState(() {
                            postData[index].isRead = true;
                            postData[index].time = 0;
                          });
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          prefs.setString('postData', jsonEncode(postData));
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostDetailScreen(post: postData[index]),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: postData[index].isRead == false
                                ? Colors.yellow[200]
                                : Colors.transparent,
                            border: Border.all(width: 1.5),
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TimerComponent(
                                postData: postData[index],
                                onTimeUpdated: _updatePostTime,
                                mainPost:
                                    postData, // Update time in the parent list
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: Text(
                                postData[index].title ?? '',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: Text(
                                postData[index].body ?? '',
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ))
                            ],
                          )
                        ]),
                      ),
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state is GetAllPostLoadingState
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          )
                        : const Center(
                            child: Text(
                            AppString.noPostFound,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ))
                  ],
                );
        }),
      ),
    );
  }

  void _updatePostTime(int id, int remainingTime) {
    setState(() {
      final post = postData.firstWhere((post) => post.id == id);
      post.time = remainingTime;
    });
  }
}

class TimerComponent extends StatefulWidget {
  final GetAllPostModel postData;
  final Function(int id, int remainingTime) onTimeUpdated;
  final List<GetAllPostModel> mainPost;

  // ignore: use_key_in_widget_constructors
  const TimerComponent(
      {required this.postData,
      required this.onTimeUpdated,
      this.mainPost = const []});

  @override
  // ignore: library_private_types_in_public_api
  _TimerComponentState createState() => _TimerComponentState();
}

class _TimerComponentState extends State<TimerComponent> {
  Timer? _timer;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Ensure no duplicate timers
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isVisible) {
        if (widget.postData.isRead == true) {
          _timer?.cancel();
        } else if ((widget.postData.time ?? 0) <= 0) {
          _timer?.cancel();
          widget.mainPost.forEach((element) async {
            if (element.id == widget.postData.id) {
              element.time = widget.postData.time;
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              prefs.setString('postData', jsonEncode(widget.mainPost));
            }
          });
        } else {
          widget.postData.time = (widget.postData.time ?? 0) - 1;
          widget.onTimeUpdated(
              widget.postData.id ?? 0, widget.postData.time ?? 0);
          widget.mainPost.forEach((element) async {
            if (element.id == widget.postData.id) {
              element.time = widget.postData.time;
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              prefs.setString('postData', jsonEncode(widget.mainPost));
            }
          });
        }
      }
    });
  }

  void _pauseTimer() {
    _isVisible = false;
    _timer?.cancel(); // Stop the timer when not visible
  }

  void _resumeTimer() {
    if (!_isVisible) {
      _isVisible = true;
      _startTimer(); // Restart the timer when visible
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up timer when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.postData.id.toString()),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 0) {
          _pauseTimer();
        } else {
          _resumeTimer();
        }
      },
      child: Column(
        children: [
          Text(_timerText),
        ],
      ),
    );
  }

  String get _timerText {
    Duration duration = Duration(seconds: widget.postData.time ?? 0);
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}

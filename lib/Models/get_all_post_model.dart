// ignore_for_file: prefer_collection_literals

import 'dart:async';
import 'dart:math';

List<GetAllPostModel> getallPostFromjsonMethod(dynamic str) =>
    List<GetAllPostModel>.from(str.map((x) => GetAllPostModel.fromJson(x)));

class GetAllPostModel {
  int? userId;
  int? id;
  String? title;
  String? body;
  int? time;
  bool? isRead;

  GetAllPostModel(
      {this.userId, this.id, this.title, this.body, this.time, this.isRead});

  GetAllPostModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
    time = json["time"] ?? _generateRandomInt(10, 99);
    isRead = json['isRead'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['isRead'] = isRead;
    data['time'] = time;
    return data;
  }

  static int _generateRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1); // Includes max in range
  }
}

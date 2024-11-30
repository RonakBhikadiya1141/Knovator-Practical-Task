import 'dart:convert';

import '../ApiServices/apiservices.dart';
import '../Const/app_string.dart';
import '../Models/get_all_post_model.dart';

class Repository {
  ApiServices apiServices = ApiServices();

  getAllPost() async {
    final response = await apiServices.getApiCall(
      "https://jsonplaceholder.typicode.com/posts",
    );
    var jsonString = json.decode(response!.body);
    print(jsonString);
    switch (response.statusCode) {
      case 200:
        return getallPostFromjsonMethod(jsonString);

      default:
        return AppString.error;
    }
  }
}

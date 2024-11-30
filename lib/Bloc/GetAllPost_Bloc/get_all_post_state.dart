import '../../Models/get_all_post_model.dart';

abstract class GetAllPostState {}

class GetAllPostInitialState extends GetAllPostState {}

class GetAllPostLoadingState extends GetAllPostState {}

class GetAllPostLoadedState extends GetAllPostState {
  final List<GetAllPostModel> getAllPostModel;
  GetAllPostLoadedState(this.getAllPostModel);
}

class GetAllPostErrorState extends GetAllPostState {
  final String error;
  GetAllPostErrorState(this.error);
}

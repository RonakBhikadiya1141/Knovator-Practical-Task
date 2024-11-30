import 'package:demo/Const/app_string.dart';

import '../../Repository/repository.dart';
import 'get_all_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllPostCubit extends Cubit<GetAllPostState> {
  // ignore: empty_constructor_bodies
  GetAllPostCubit() : super(GetAllPostInitialState()) {}
  Future<void> getAllPost() async {
    dynamic getAllPostModel;
    try {
      emit(GetAllPostLoadingState());
      getAllPostModel = await Repository().getAllPost();
      if (getAllPostModel != AppString.error) {
        emit(GetAllPostLoadedState(getAllPostModel));
      } else {
        emit(GetAllPostErrorState(AppString.someThingWentWrong));
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      emit(GetAllPostErrorState(AppString.someThingWentWrong));
    }
  }
}

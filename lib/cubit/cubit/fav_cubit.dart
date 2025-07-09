import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_api_app/cubit/cubit/fav_state.dart';
import 'package:product_api_app/models/lap_models.dart';

class FavCubit extends Cubit<FavState> {
  final List<LapModel> _favorites = [];

  FavCubit() : super(FavInitial());

  void toggleFavorite(LapModel product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    emit(
      FavSuccess(List.from(_favorites)),
    ); // تحديث الحالة مع نسخة جديدة من القائمة
  }

  List<LapModel> get favorites => _favorites;
}

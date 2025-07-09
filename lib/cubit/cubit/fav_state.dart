import 'package:product_api_app/models/lap_models.dart';

abstract class FavState {}

class FavInitial extends FavState {}

class FavLoading extends FavState {}

class FavSuccess extends FavState {
  final List<LapModel> favorites;

  FavSuccess(this.favorites);
}

class FavError extends FavState {
  final String message;

  FavError(this.message);
}

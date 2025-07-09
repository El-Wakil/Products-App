import 'package:product_api_app/models/lap_models.dart';

sealed class LapState {
  const LapState();
}

final class LapInitial extends LapState {
  const LapInitial();
}

final class LapLoading extends LapState {
  const LapLoading();
}

final class LapSuccess extends LapState {
  final List<LapModel> lapData;
  const LapSuccess({required this.lapData});
}

final class LapFailure extends LapState {
  final String error;
  const LapFailure(this.error);
}

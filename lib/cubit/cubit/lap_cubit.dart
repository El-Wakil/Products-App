import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_api_app/data/lap_data.dart';
import 'lap_state.dart';

class LapCubit extends Cubit<LapState> {
  LapCubit(LapData lapData) : super(LapInitial());

  final LapData dataService = LapData();

  void getdatacubit() async {
    emit(LapLoading());
    try {
      final data = await dataService.getLapData();
      emit(LapSuccess(lapData: data));
    } catch (e) {
      emit(LapFailure(e.toString()));
    }
  }
}

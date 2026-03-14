import 'package:injectable/injectable.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repo.dart';

@injectable
class GetDirectionsUseCase {
  final OrderDetailsRepo _orderDetailsRepo;

  GetDirectionsUseCase(this._orderDetailsRepo);

  List<Position> convertToPositions(List<List<double>> coordinates) {
    return coordinates.map((point) => Position(point[0], point[1])).toList();
  }

  Future<Result<List<Position>>> call({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    final result = await _orderDetailsRepo.getDirections(
      startLat,
      startLng,
      endLat,
      endLng,
    );
    switch (result) {
      case Success<List<List<double>>>():
        return Success(convertToPositions(result.data));
      case Failure<List<List<double>>>():
        return Failure(result.errorMessage);
    }
  }
}

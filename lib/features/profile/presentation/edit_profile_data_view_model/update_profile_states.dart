import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';

class UpdateProfileStates extends Equatable {
  final BaseState<DriverEntity>? ubdateDriverData;
  const UpdateProfileStates({this.ubdateDriverData});
  @override
  List<Object?> get props => [ubdateDriverData];

  UpdateProfileStates copyWith({BaseState<DriverEntity>? ubdateDriverData}) {
    return UpdateProfileStates(
      ubdateDriverData: ubdateDriverData ?? this.ubdateDriverData,
    );
  }
}

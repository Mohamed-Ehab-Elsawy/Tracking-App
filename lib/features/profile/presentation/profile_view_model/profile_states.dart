import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';

class ProfileStates extends Equatable {
  final BaseState<DriverEntity>? driverData;
  const ProfileStates({this.driverData});
  @override
  List<Object?> get props => [driverData];

  ProfileStates copyWith({BaseState<DriverEntity>? driverData}) {
    return ProfileStates(driverData: driverData ?? this.driverData);
  }
}

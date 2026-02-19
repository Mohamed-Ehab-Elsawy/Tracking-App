import 'package:equatable/equatable.dart';

class OrderDetailsEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetOrderNamesByIdsEvents extends OrderDetailsEvents {
  final List<String> ids;

  GetOrderNamesByIdsEvents({required this.ids});
  @override
  List<Object?> get props => [ids];
}

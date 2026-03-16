import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';

@injectable
class SaveNotificationToFireBaseUseCase {
  final OrderDetailsRepository _repo;

  SaveNotificationToFireBaseUseCase(this._repo);

  Future<Result<void>> invoke({
    required NotificationDto notification,
    required String userId,
  }) => _repo.saveNotification(notification: notification, userId: userId);
}

import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';

@injectable
class SendNotificationUseCase {
  final OrderDetailsRepository _orderDetailsRepo;

  const SendNotificationUseCase(this._orderDetailsRepo);

  Future<Result<void>> call({
    required SendNotificationRequest notificationDto,
    required String authorization,
  }) => _orderDetailsRepo.sendNotification(
    notificationDto: notificationDto,
    authorization: authorization,
  );
}

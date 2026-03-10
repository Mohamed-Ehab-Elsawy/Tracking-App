import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/domain/repo/home_repo.dart';

import '../entities/user_entity.dart';

@injectable
class GetUserDataUseCase {
  final HomeRepo _orderDetailsRepo;

  GetUserDataUseCase(this._orderDetailsRepo);

  Future<Result<UserEntity>> call(String userId) =>
      _orderDetailsRepo.getUserDetails(userId: userId);
}

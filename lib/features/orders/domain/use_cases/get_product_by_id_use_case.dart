import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/domain/entity/product_entity.dart';
import 'package:tracking_app/features/orders/domain/repository/order_repo.dart';

@injectable
class GetProductByIdUseCase {
  final OrderRepo orderRepo;

  GetProductByIdUseCase(this.orderRepo);
  Future<Result<ProductEntity>> call(String productId) =>
      orderRepo.getProductDetails(productId);
}

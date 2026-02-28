import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/domain/entity/product_entity.dart';
import 'package:tracking_app/features/orders/domain/repository/order_repo.dart';
import 'package:tracking_app/features/orders/domain/use_cases/get_product_by_id_use_case.dart';
import 'get_orders_history_test.mocks.dart';

@GenerateMocks([OrderRepo])
void main() {
  late MockOrderRepo mockOrderRepo;
  late GetProductByIdUseCase useCase;
  late Exception failure;

  setUp(() {
    mockOrderRepo = MockOrderRepo();
    useCase = GetProductByIdUseCase(mockOrderRepo);
    provideDummy<Result<ProductEntity>>(Success(ProductEntity(id: "1")));
    failure = Exception("errors.unexpected");
  });

  const productId = "123";

  final productEntity = ProductEntity(id: "123");

  group('GetProductByIdUseCase', () {
    test(
      'should return ProductEntity when repository call is successful',
      () async {
        when(
          mockOrderRepo.getProductDetails(productId),
        ).thenAnswer((_) async => Success<ProductEntity>(productEntity));
        final result = await useCase.call(productId);
        expect(result, isA<Success<ProductEntity>>());
        verify(useCase.call(productId)).called(1);
      },
    );

    test('should return Failure when repository call fails', () async {
      when(
        mockOrderRepo.getProductDetails(productId),
      ).thenAnswer((_) async => Failure<ProductEntity>(failure.toString()));

      final result = await useCase(productId) as Failure<ProductEntity>;
      expect(result.errorMessage, equals(failure.toString()));
      verify(useCase.call(productId)).called(1);
    });
  });
}

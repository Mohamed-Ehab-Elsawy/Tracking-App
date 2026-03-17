import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/data_source/firebase_data_source.dart';
import 'package:tracking_app/features/home/data/data_source/home_data_source.dart';
import 'package:tracking_app/features/home/data/models/home_response_dto.dart';
import 'package:tracking_app/features/home/data/models/orders_dto.dart';
import 'package:tracking_app/features/home/data/repo/home_repo_impl.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';

import 'home_repo_impl_test.mocks.dart';

@GenerateMocks([HomeDataSource, FirebaseFirestore, FirebaseOrderDataSource])
void main() {
  late MockHomeDataSource dataSource;
  late HomeRepoImpl homeRepoImpl;
  late HomeResponseDto homeResponseDto;
  late MockFirebaseFirestore firebaseFirestore;
  late MockFirebaseOrderDataSource firebaseOrderDataSource;

  setUp(() {
    dataSource = MockHomeDataSource();
    firebaseFirestore = MockFirebaseFirestore();
    firebaseOrderDataSource = MockFirebaseOrderDataSource();
    homeRepoImpl = HomeRepoImpl(
      dataSource,
      firebaseFirestore,
      firebaseOrderDataSource,
    );

    homeResponseDto = HomeResponseDto(
      orders: [
        OrdersDto(id: '1', state: 'pending'),
        OrdersDto(id: '2', state: 'pending'),
      ],
    );

    provideDummy<Result<HomeResponseDto>>(Success(homeResponseDto));
  });

  group('home repo impl test cases', () {
    test(
      'when calling get orders from api should return list of orders ',
      () async {
        //arrange
        when(
          dataSource.getOrders(1, 10),
        ).thenAnswer((_) async => Success(homeResponseDto));

        //act
        final result = await homeRepoImpl.getOrders(1, 10);

        //assert
        expect(result, isA<Success<List<HomeOrderEntity>>>());

        final successResult = result as Success<List<HomeOrderEntity>>;
        expect(successResult.data.length, homeResponseDto.orders?.length);

        verify(dataSource.getOrders(1, 10)).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
    test('when calling get orders from api should return error', () async {
      //arrange

      when(
        dataSource.getOrders(1, 10),
      ).thenAnswer((_) async => Failure('error'));

      //act
      final result = await homeRepoImpl.getOrders(1, 10);

      //assert
      expect(result, isA<Failure<List<HomeOrderEntity>>>());

      verify(dataSource.getOrders(1, 10)).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}

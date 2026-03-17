import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/env/env.dart';
import 'package:tracking_app/core/api/models/responses/directions_model.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/data/data_sources/fire_base_order_details_data_source.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';
import 'package:tracking_app/features/order_details/data/repository/order_details_repository_impl.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

class MockDataSource extends Mock implements FirebaseOrderDetailsDataSource {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockDataSource dataSource;
  late MockApiClient apiClient;
  late OrderDetailsRepositoryImpl repository;

  setUp(() async {
    dataSource = MockDataSource();
    apiClient = MockApiClient();

    repository = OrderDetailsRepositoryImpl(dataSource, apiClient);

    AppLocalStorage.prefsForTest = await _mockPrefs();

    final secureStorage = _MockSecureStorage();

    when(
      () => secureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => secureStorage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => 'secure123');

    AppLocalStorage.secureStorageForTest = secureStorage;
  });

  setUpAll(() {
    registerFallbackValue(OrderStatus.accepted);
  });

  final activeOrder = ActiveOrderDto.fromJson({"id": "1"});

  final directionsResponse = DirectionsResponse(
    code: "Ok",
    routes: [
      MapboxRoute(
        distance: 10,
        duration: 5,
        geometry: Geometry(
          coordinates: [
            [30.0, 31.0],
            [30.1, 31.1],
          ],
          type: "LineString",
        ),
      ),
    ],
  );

  final notificationRequest = SendNotificationRequest(
    "token",
    "title",
    "body",
    {"data": "data"},
  );

  final notificationDto = NotificationDto(
    title: "title",
    body: "body",
    status: "status",
  );

  group("updateOrderStatus", () {
    test(
      "should call datasource with correct params and return result",
      () async {
        await AppLocalStorage.set(AppConstants.orderId, "order123");

        when(
          () => dataSource.updateOrderStatus(any(), any()),
        ).thenAnswer((_) async => Success(activeOrder));

        final result = await repository.updateOrderStatus(OrderStatus.picked);

        verify(
          () => dataSource.updateOrderStatus("order123", OrderStatus.picked),
        ).called(1);

        expect(result, isA<Success>());
      },
    );
  });

  group("getCurrentOrderDetails", () {
    test("should get secured id and call datasource", () async {
      await AppLocalStorage.setSecuredString(
        key: AppConstants.orderId,
        value: "secure123",
      );

      when(
        () => dataSource.getCurrentOrderDetails(any()),
      ).thenAnswer((_) async => Success(activeOrder));

      final result = await repository.getCurrentOrderDetails();

      verify(() => dataSource.getCurrentOrderDetails("secure123")).called(1);

      expect(result, isA<Success>());
    });
  });

  group("getDirections", () {
    test("should return coordinates on success", () async {
      when(
        () => apiClient.getRoute(any(), any(), any(), any()),
      ).thenAnswer((_) async => directionsResponse);

      final result = await repository.getDirections(31.0, 30.0, 32.0, 31.0);

      verify(
        () => apiClient.getRoute(
          AppConstants.driving,
          "30.0,31.0;31.0,32.0",
          AppConstants.geometries,
          Env.mapAccessToken,
        ),
      ).called(1);

      expect(result, isA<Success>());

      final success = result as Success<List<List<double>>>;
      expect(success.data.length, 2);
    });

    test("should return failure when api throws", () async {
      when(() => apiClient.getRoute(any(), any(), any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.getDirections(0, 0, 0, 0);

      expect(result, isA<Failure>());
    });
  });

  group("sendNotification", () {
    test("should forward call to datasource", () async {
      when(
        () => dataSource.sendNotification(
          sendNotificationRequest: notificationRequest,
          authorization: "Bearer token",
        ),
      ).thenAnswer((_) async => Success<void>(null));

      final result = await repository.sendNotification(
        notificationDto: notificationRequest,
        authorization: "Bearer token",
      );

      verify(
        () => dataSource.sendNotification(
          sendNotificationRequest: notificationRequest,
          authorization: "Bearer token",
        ),
      ).called(1);

      expect(result, isA<Success<void>>());
    });
  });

  group("saveNotification", () {
    test("should forward call to datasource", () async {
      when(
        () => dataSource.saveNotification(
          notification: notificationDto,
          userId: "user123",
        ),
      ).thenAnswer((_) async => Success(null));

      final result = await repository.saveNotification(
        notification: notificationDto,
        userId: "user123",
      );

      verify(
        () => dataSource.saveNotification(
          notification: notificationDto,
          userId: "user123",
        ),
      ).called(1);

      expect(result, isA<Success>());
    });
  });
}

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

Future<SharedPreferences> _mockPrefs() async {
  SharedPreferences.setMockInitialValues({});
  return await SharedPreferences.getInstance();
}

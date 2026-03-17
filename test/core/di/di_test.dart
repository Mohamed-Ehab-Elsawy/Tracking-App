import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tracking_app/core/di/di.config.dart';
import 'package:tracking_app/core/di/di.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final memory = <String, String>{};

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          switch (call.method) {
            case 'read':
              final key = (call.arguments as Map)['key'] as String?;
              return key == null ? null : memory[key];
            case 'write':
              final args = call.arguments as Map;
              final key = args['key'] as String?;
              final value = args['value'] as String?;
              if (key != null) {
                if (value == null) {
                  memory.remove(key);
                } else {
                  memory[key] = value;
                }
              }
              return true;
            case 'delete':
              final key = (call.arguments as Map)['key'] as String?;
              if (key != null) memory.remove(key);
              return true;
            case 'readAll':
              return Map<String, String>.from(memory);
            case 'deleteAll':
              memory.clear();
              return true;
            default:
              return null;
          }
        });
  });

  tearDown(() async => await GetIt.I.reset());

  group('configureDependencies()', () {
    test('completes without throwing and initializes DI', () async {
      // Act
      await configureDependencies();

      // Assert
      expect(GetIt.I.allReady(), completes);
    });

    test(
      'can use the generated init() directly with environment="test"',
      () async {
        await GetIt.I.reset();

        GetIt.I.init(environment: 'test');
      },
    );
  });
}

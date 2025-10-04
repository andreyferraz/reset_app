import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Method Channel Integration Tests', () {
    const MethodChannel channel = MethodChannel('com.example.reset_app/settings');
    final List<MethodCall> log = [];

    setUp(() {
      log.clear();
      
      // Mock do canal de método
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        
        switch (methodCall.method) {
          case 'deleteAllFiles':
            // Simula resposta de sucesso
            return {
              'status': 'success',
              'deletedCount': 1234,
              'failedCount': 5,
              'durationMs': 45200,
              'message': 'Operação concluída: 1234 arquivos deletados, 5 falharam'
            };
          
          case 'openManageStorageSettings':
            return 'Abrir configurações de gerenciamento de armazenamento';
          
          case 'openSettings':
            return {
              'status': 'success',
              'message': 'Configurações abertas',
              'apiLevel': 33
            };
          
          default:
            throw PlatformException(
              code: 'UNIMPLEMENTED',
              message: 'Method ${methodCall.method} not implemented',
            );
        }
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('deleteAllFiles method should be called', () async {
      final result = await channel.invokeMethod('deleteAllFiles');
      
      expect(log, hasLength(1));
      expect(log.first.method, 'deleteAllFiles');
      expect(result, isA<Map>());
    });

    test('deleteAllFiles should return success with statistics', () async {
      final result = await channel.invokeMethod('deleteAllFiles') as Map;
      
      expect(result['status'], 'success');
      expect(result['deletedCount'], isA<int>());
      expect(result['failedCount'], isA<int>());
      expect(result['durationMs'], isA<int>());
      expect(result['message'], isA<String>());
    });

    test('deleteAllFiles should return correct statistics', () async {
      final result = await channel.invokeMethod('deleteAllFiles') as Map;
      
      expect(result['deletedCount'], 1234);
      expect(result['failedCount'], 5);
      expect(result['durationMs'], 45200);
    });

    test('openManageStorageSettings method should be called', () async {
      final result = await channel.invokeMethod('openManageStorageSettings');
      
      expect(log, hasLength(1));
      expect(log.first.method, 'openManageStorageSettings');
      expect(result, isA<String>());
    });

    test('openSettings method should be called', () async {
      final result = await channel.invokeMethod('openSettings') as Map;
      
      expect(log, hasLength(1));
      expect(log.first.method, 'openSettings');
      expect(result['status'], 'success');
      expect(result['apiLevel'], isA<int>());
    });

    test('unimplemented method should throw PlatformException', () async {
      expect(
        () => channel.invokeMethod('unknownMethod'),
        throwsA(isA<PlatformException>()),
      );
    });

    test('channel name should be correct', () {
      expect(channel.name, 'com.example.reset_app/settings');
    });
  });

  group('Permission Tests', () {
    test('should handle permission denied error', () async {
      const MethodChannel channel = MethodChannel('com.example.reset_app/settings');
      
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'deleteAllFiles') {
          throw PlatformException(
            code: 'PERMISSION_DENIED',
            message: 'Permissão necessária não concedida',
            details: {
              'needsManageStorage': true,
              'apiLevel': 33
            },
          );
        }
        return null;
      });

      expect(
        () => channel.invokeMethod('deleteAllFiles'),
        throwsA(
          isA<PlatformException>()
              .having((e) => e.code, 'code', 'PERMISSION_DENIED')
              .having((e) => e.message, 'message', contains('Permissão')),
        ),
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
  });

  group('Error Handling Tests', () {
    test('should handle general errors', () async {
      const MethodChannel channel = MethodChannel('com.example.reset_app/settings');
      
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'deleteAllFiles') {
          throw PlatformException(
            code: 'ERROR',
            message: 'Erro ao deletar arquivos',
          );
        }
        return null;
      });

      expect(
        () => channel.invokeMethod('deleteAllFiles'),
        throwsA(
          isA<PlatformException>()
              .having((e) => e.code, 'code', 'ERROR'),
        ),
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
  });
}

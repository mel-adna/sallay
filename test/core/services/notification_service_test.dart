import 'package:flutter_test/flutter_test.dart';
import 'package:sallay/core/services/notification_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  group('NotificationService', () {
    late NotificationService service;

    setUp(() {
      service = NotificationService();
      // Inject mock if we refactor service to allow injection
    });

    test('can be instantiated', () {
      expect(service, isNotNull);
    });
  });
}

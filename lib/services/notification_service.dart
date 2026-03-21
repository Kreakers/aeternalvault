import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // v4: özel ses dosyası (aeterna_alert.wav) ile kanal — ses garantili çalışır.
  static final _channel = AndroidNotificationDetails(
    'aeterna_reminders_v4',
    'Hatırlatıcılar',
    channelDescription: 'Aeterna Vault kişi hatırlatıcıları',
    importance: Importance.max,
    priority: Priority.max,
    icon: '@mipmap/ic_launcher',
    sound: const RawResourceAndroidNotificationSound('aeterna_alert'),
    playSound: true,
    enableVibration: true,
    vibrationPattern: Int64List.fromList([0, 500, 200, 500, 200, 800]),
    ticker: 'Aeterna Vault Hatırlatıcı',
    channelShowBadge: true,
  );

  static const _iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  Future<void> init() async {
    if (_initialized) return;
    try {
      tz.initializeTimeZones();
      try {
        final tzInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
      } catch (_) {
        tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
      }

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

      await _plugin.initialize(settings);
      _initialized = true;
      debugPrint('✅ NotificationService initialized');
    } catch (e) {
      debugPrint('❌ NotificationService init failed: $e');
    }
  }

  /// Android izinlerini iste — Activity hazır olduktan SONRA çağrılmalı
  Future<void> requestPermissions() async {
    if (!_initialized) await init();
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();
    debugPrint('✅ Bildirim izinleri istendi');
  }

  /// Anında bildirim göster (test ve onay amaçlı)
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(android: _channel, iOS: _iosDetails),
    );
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (!_initialized) await init();

    final now = DateTime.now();
    if (scheduledDate.isBefore(now.subtract(const Duration(minutes: 1)))) return;

    final effectiveDate = scheduledDate.isBefore(now)
        ? now.add(const Duration(seconds: 5))
        : scheduledDate;

    final tzDate = tz.TZDateTime.from(effectiveDate, tz.local);
    final details = NotificationDetails(android: _channel, iOS: _iosDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint('✅ Bildirim zamanlandı (exact): $tzDate');
  }

  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}

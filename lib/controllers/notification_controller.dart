import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxString selectedFilter = 'All'.obs;
  final RxList<Map<String, dynamic>> notifications =
      <Map<String, dynamic>>[].obs;

  final List<String> filters = ['All', 'Results', 'Reminders', 'Achiev.'];

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  void _loadNotifications() {
    notifications.assignAll([
      {
        'id': '1',
        'type': 'result',
        'icon': 'trending_up',
        'iconColor': 0xFF22C55E,
        'title': 'Interview Result Ready',
        'body': 'You scored 87/100 in your technical simulation. Feedback is now available.',
        'time': '3m ago',
        'isRead': false,
        'isToday': true,
        'isSwipeable': false,
      },
      {
        'id': '2',
        'type': 'reminder',
        'icon': 'local_fire_department',
        'iconColor': 0xFFF97316,
        'title': '5 Day Streak! 🔥',
        'body': 'Consistent progress! Keep it up to unlock the "Master Comm" badge this week.',
        'time': '1h ago',
        'isRead': false,
        'isToday': true,
        'isSwipeable': false,
      },
      {
        'id': '3',
        'type': 'achievement',
        'icon': 'emoji_events',
        'iconColor': 0xFFF59E0B,
        'title': 'New Achievement Unlocked! 🏆',
        'body': '"Polished Speaker" earned for maintaining zero filler words in 3 consecutive sessions.',
        'time': '3h ago',
        'isRead': false,
        'isToday': true,
        'isSwipeable': false,
      },
      {
        'id': '4',
        'type': 'reminder',
        'icon': 'schedule',
        'iconColor': 0xFF3B82F6,
        'title': 'Ready for a Practice?',
        'body': 'It\'s your scheduled time for "Behavioral Fundamentals". Ready to start?',
        'time': '24h ago',
        'isRead': true,
        'isToday': false,
        'isSwipeable': false,
      },
      {
        'id': '5',
        'type': 'tip',
        'icon': 'lightbulb',
        'iconColor': 0xFF8B5CF6,
        'title': 'Personalized AI Tip',
        'body': 'Try using the "STAR" method for your next situational response to boost clarity.',
        'time': '1d ago',
        'isRead': true,
        'isToday': false,
        'isSwipeable': true,
      },
    ]);
  }

  List<Map<String, dynamic>> get filtered {
    if (selectedFilter.value == 'All') return notifications.toList();
    final map = {
      'Results': 'result',
      'Reminders': 'reminder',
      'Achiev.': 'achievement',
    };
    final type = map[selectedFilter.value] ?? '';
    return notifications.where((n) => n['type'] == type).toList();
  }

  List<Map<String, dynamic>> get todayNotifications =>
      filtered.where((n) => n['isToday'] == true).toList();

  List<Map<String, dynamic>> get yesterdayNotifications =>
      filtered.where((n) => n['isToday'] == false).toList();

  int get unreadCount => notifications.where((n) => !n['isRead']).length;

  void selectFilter(String filter) => selectedFilter.value = filter;

  void markAllRead() {
    for (final n in notifications) {
      n['isRead'] = true;
    }
    notifications.refresh();
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n['id'] == id);
  }

  void markRead(String id) {
    final idx = notifications.indexWhere((n) => n['id'] == id);
    if (idx != -1) {
      notifications[idx]['isRead'] = true;
      notifications.refresh();
    }
  }
}

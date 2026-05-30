import 'package:get/get.dart';

class HistoryController extends GetxController {
  final RxString selectedFilter = 'All'.obs;
  final RxInt totalSessions = 12.obs;
  final RxInt avgScore = 74.obs;
  final RxInt bestScore = 92.obs;

  final List<String> filters = ['All', 'Flutter Dev', 'Backend'];

  final RxList<Map<String, dynamic>> sessions = <Map<String, dynamic>>[
    {
      'id': '1',
      'tag': 'Flutter Dev',
      'tagColor': 0xFF1E3A5F,
      'tagTextColor': 0xFF60A5FA,
      'title': 'Senior Engineer Mock',
      'date': 'Yesterday',
      'time': '14:20',
      'mode': 'Standard',
      'duration': '10 min',
      'score': 88,
      'technical': 92,
      'behavioral': 85,
      'culture': 78,
    },
    {
      'id': '2',
      'tag': 'Backend',
      'tagColor': 0xFF2D1B69,
      'tagTextColor': 0xFFA78BFA,
      'title': 'Node.js Specialist',
      'date': 'Oct 24',
      'time': '09:15',
      'mode': 'Stress Test',
      'duration': '15 min',
      'score': 64,
      'technical': 58,
      'behavioral': 70,
      'culture': 65,
    },
    {
      'id': '3',
      'tag': 'Fullstack',
      'tagColor': 0xFF134E4A,
      'tagTextColor': 0xFF34D399,
      'title': 'Growth Startup Round',
      'date': 'Oct 20',
      'time': '18:30',
      'mode': 'Standard',
      'duration': '20 min',
      'score': 92,
      'technical': 95,
      'behavioral': 90,
      'culture': 91,
    },
  ].obs;

  List<Map<String, dynamic>> get filteredSessions {
    if (selectedFilter.value == 'All') return sessions.toList();
    return sessions
        .where((s) => s['tag'] == selectedFilter.value)
        .toList();
  }

  void selectFilter(String filter) => selectedFilter.value = filter;

  int getScoreColor(int score) {
    if (score >= 80) return 0xFF22C55E;
    if (score >= 60) return 0xFF3B82F6;
    return 0xFFEF4444;
  }

  void onSessionTap(Map<String, dynamic> session) {
    Get.snackbar(
      session['title'],
      'Score: ${session['score']} — ${session['mode']} · ${session['duration']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onRetrySession(Map<String, dynamic> session) {
    Get.snackbar(
      'Retry',
      'Retrying ${session['title']}...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

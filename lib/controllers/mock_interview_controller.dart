import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MockInterviewController extends GetxController {
  // ─── Setup State ─────────────────────────────────────────────
  final RxString selectedRole = 'Flutter Dev'.obs;
  final RxString selectedLevel = 'Beginner'.obs;
  final RxString selectedDuration = '10m'.obs;
  final RxList<String> selectedQuestionTypes = <String>['Technical'].obs;

  final List<String> roles = ['Flutter Dev', 'Backend', 'Frontend', 'Full Stack', 'iOS Dev'];
  final List<String> levels = ['Beginner', 'Intermed.', 'Expert'];
  final List<String> durations = ['5m', '10m', '20m'];
  final List<Map<String, dynamic>> questionTypes = [
    {'label': 'Technical', 'icon': Icons.code_rounded},
    {'label': 'Behavioral', 'icon': Icons.psychology_outlined},
    {'label': 'HR Focus', 'icon': Icons.handshake_outlined},
    {'label': 'Situational', 'icon': Icons.lightbulb_outline_rounded},
  ];

  void selectRole(String role) => selectedRole.value = role;
  void selectLevel(String level) => selectedLevel.value = level;
  void selectDuration(String dur) => selectedDuration.value = dur;
  void toggleQuestionType(String type) {
    if (selectedQuestionTypes.contains(type)) {
      if (selectedQuestionTypes.length > 1) selectedQuestionTypes.remove(type);
    } else {
      selectedQuestionTypes.add(type);
    }
  }

  void onStartInterview() => Get.toNamed('/live-session');

  // ─── Live Session State ───────────────────────────────────────
  final RxBool isRecording = false.obs;
  final RxBool isLive = false.obs;
  final RxInt currentQuestion = 4.obs;
  final RxInt totalQuestions = 12.obs;
  final RxString elapsedTime = '08:37'.obs;
  final RxString currentQuestionText =
      '"Explain the difference between StatelessWidget and StatefulWidget in Flutter, and when would you choose one over the other?"'
          .obs;
  final RxList<double> waveformBars = <double>[].obs;

  Timer? _sessionTimer;
  Timer? _waveformTimer;
  int _seconds = 517;

  void startSession() {
    isLive.value = true;
    isRecording.value = true;
    _generateWaveform();
    _startTimer();
  }

  void _startTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      final m = (_seconds ~/ 60).toString().padLeft(2, '0');
      final s = (_seconds % 60).toString().padLeft(2, '0');
      elapsedTime.value = '$m:$s';
    });
  }

  void _generateWaveform() {
    final random = DateTime.now().millisecondsSinceEpoch;
    waveformBars.value = List.generate(30, (i) {
      final seed = (random + i * 137) % 100;
      return 0.2 + (seed / 100) * 0.8;
    });
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      if (isRecording.value) {
        final now = DateTime.now().millisecondsSinceEpoch;
        waveformBars.value = List.generate(30, (i) {
          final seed = (now + i * 137) % 100;
          return 0.2 + (seed / 100) * 0.8;
        });
      }
    });
  }

  void toggleRecording() => isRecording.toggle();

  void onEndSession() {
    _sessionTimer?.cancel();
    _waveformTimer?.cancel();
    Get.toNamed('/session-result');
  }

  // ─── Session Result State ─────────────────────────────────────
  final RxInt sessionScore = 87.obs;
  final RxInt sessionDuration = 26.obs;
  final RxInt questionsAnswered = 12.obs;
  final RxInt sessionMaxScore = 100.obs;
  final RxString sessionRankMessage = "You're in the top 5% of candidates for this role.".obs;

  final List<Map<String, dynamic>> strengths = [
    {'text': 'Excellent articulation of technical debt trade-offs.'},
    {'text': 'Strong leadership presence during conflict scenarios.'},
  ];

  final List<Map<String, dynamic>> weakAreas = [
    {'text': 'STAR method formatting could be tighter on question 4.'},
    {'text': 'Your tone is highly professional but could benefit from more specific KPIs.'},
    {'text': 'Tendency to over-explain metrics details.'},
  ];

  final List<Map<String, dynamic>> aiRecommendations = [
    {
      'title': 'Stakeholder Communication',
      'desc': 'Focus on concise stakeholder communication modules next.',
      'tag': 'SUGGEST PRACTICE',
      'tagColor': 0xFF1E3A5F,
      'tagTextColor': 0xFF60A5FA,
    },
    {
      'title': 'Executive Presence & Metrics',
      'desc': 'Work on quantifying leadership impact with specific metrics.',
      'tag': 'SUGGEST PRACTICE',
      'tagColor': 0xFF2D1B69,
      'tagTextColor': 0xFFA78BFA,
    },
  ];

  void onReviewAnswers() => Get.toNamed('/answer-review');
  void onTryAgain() => Get.toNamed('/mock-interview');
  void onShareResult() {
    Get.snackbar('Share', 'Sharing result...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  // ─── Company Prep State ───────────────────────────────────────
  final RxString selectedCompany = 'Google'.obs;

  final List<Map<String, dynamic>> companies = [
    {'name': 'Google', 'difficulty': 'HARD', 'diffColor': 0xFFEF4444, 'icon': '🔍'},
    {'name': 'Amazon', 'difficulty': 'EXTREME', 'diffColor': 0xFFEF4444, 'icon': '📦'},
    {'name': 'Meta', 'difficulty': 'HARD', 'diffColor': 0xFFEF4444, 'icon': '∞'},
    {'name': 'Apple', 'difficulty': 'EXTREME', 'diffColor': 0xFFEF4444, 'icon': '🍎'},
    {'name': 'Microsoft', 'difficulty': 'MEDIUM', 'diffColor': 0xFFF59E0B, 'icon': '⊞'},
    {'name': 'Arbisoft', 'difficulty': 'MEDIUM', 'diffColor': 0xFFF59E0B, 'icon': '🏢'},
  ];

  final List<String> interviewRounds = [
    'Technical Screening',
    'System Design',
    'Behavioral (Googleyness)',
  ];

  final List<String> companyInsights = [
    'Algorithmic focus: Heavily emphasizes runtime complexity and space optimization.',
    'The "Googleyness" bar: Cultural fit is as critical as technical ability; focus on collaborative problem-solving.',
    'Scale Matters: For 1.5+ roles, system design questions always involve planetary-scale distribution.',
    'Silent Evaluator: Interviewers often look for edge-case identification before writing a single line of code.',
  ];

  void selectCompany(String name) => selectedCompany.value = name;
  void onStartCompanyPrep() {
    Get.snackbar('Company Prep', 'Starting ${selectedCompany.value} prep...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  // ─── Resume Prep State ─────────────────────────────────────────
  final RxBool hasUploadedResume = false.obs;
  final RxBool isUploading = false.obs;
  final RxString uploadedFileName = ''.obs;
  final RxString uploadFileSize = ''.obs;

  final List<String> detectedSkills = ['Flutter', 'Dart', 'Firebase'];
  final RxString resumePreviewQuestion =
      '"Can you explain the difference between a StatelessWidget and a StatefulWidget in Flutter, and when you would prefer one over the other?"'
          .obs;
  final RxString resumeDifficulty = 'Intermediate'.obs;
  final RxString resumeSessionLength = '15 Minutes'.obs;

  Future<void> onBrowseFile() async {
    isUploading.value = true;
    await Future.delayed(const Duration(milliseconds: 1400));
    uploadedFileName.value = 'Software_Engineer_CV.pdf';
    uploadFileSize.value = '2.5 MB';
    hasUploadedResume.value = true;
    isUploading.value = false;
  }

  void onStartResumeSession() {
    Get.snackbar('Resume Prep', 'Starting resume-based interview...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  // ─── Answer Review State ──────────────────────────────────────
  final RxInt reviewScore = 84.obs;
  final RxInt currentReviewQuestion = 4.obs;
  final RxInt totalReviewQuestions = 18.obs;
  final RxString reviewQuestion = '"How do you handle disagreement within a team?"'.obs;

  final List<Map<String, dynamic>> aiAnalysisMetrics = [
    {'label': 'Accuracy', 'value': 92, 'color': 0xFF22C55E},
    {'label': 'Depth', 'value': 78, 'color': 0xFF3B82F6},
    {'label': 'Clarity', 'value': 85, 'color': 0xFF06B6D4},
  ];

  final RxString userAnswer =
      '"I believe disagreement is natural. When it happens, I try to stay calm and listen to the other person\'s perspective. I\'d set up a 1-on-1 meeting so we can discuss the root of the problem without the rest of the team feeling awkward. I emphasize common goals rather than personal differences."'
          .obs;

  final List<String> didWellPoints = [
    'Demonstrated strong emotional intelligence.',
    'Action-oriented approach with 1-on-1s.',
  ];

  final List<String> improvePoints = [
    'Use a specific example (STAR method).',
    'Mention how the resolution benefited the project.',
  ];

  final RxString modelAnswer =
      '"In my previous role at X, I encountered a disagreement regarding the architectural direction of our API. Instead of pushing my view, I facilitated a \'pros and cons\' session. By objectively analyzing the data together, we reached a consensus that improved performance by 20% while keeping team morale high..."'
          .obs;

  void onPreviousQuestion() {
    if (currentReviewQuestion.value > 1) currentReviewQuestion.value--;
  }

  void onNextQuestion() {
    if (currentReviewQuestion.value < totalReviewQuestions.value) {
      currentReviewQuestion.value++;
    }
  }

  void onReadFullAnalysis() {
    Get.snackbar('Full Analysis', 'Opening detailed analysis...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: const Color(0xFFFFFFFF));
  }

  @override
  void onClose() {
    _sessionTimer?.cancel();
    _waveformTimer?.cancel();
    super.onClose();
  }
}

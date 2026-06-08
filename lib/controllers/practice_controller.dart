//
// import 'package:get/get.dart';
// import 'package:intervu_ai/controllers/mock_interview_controller.dart';
//
// class PracticeController extends GetxController {
//   final RxString dailyChallengeTitle = 'Backend Dev — Hard Mode'.obs;
//   final RxString dailyChallengeCountdown = '08:42:10'.obs;
//   final RxBool aiRecommendationEnabled = false.obs;
//
//   final RxList<Map<String, dynamic>> roleCards = <Map<String, dynamic>>[
//     {'role': 'Flutter', 'badge': '98% BEST', 'isBest': true},
//     {'role': 'Backend', 'badge': '85% BEST', 'isBest': true},
//     {'role': 'Frontend', 'badge': 'NEW', 'isBest': false},
//     {'role': 'iOS Dev', 'badge': 'NEW', 'isBest': false},
//     {'role': 'Full Stack', 'badge': 'HOT', 'isBest': true},
//   ].obs;
//
//   void _ensureController() {
//     if (!Get.isRegistered<MockInterviewController>()) {
//       Get.put(MockInterviewController());
//     }
//   }
//
//   void onStartDailyChallenge() {
//     _ensureController();
//     Get.toNamed('/mock-interview');
//   }
//
//   void onMockInterviewTap() {
//     _ensureController();
//     Get.toNamed('/mock-interview');
//   }
//
//   void onResumePrepTap() {
//     _ensureController();
//     Get.toNamed('/resume-prep');
//   }
//
//   void onCompanyModeTap() {
//     _ensureController();
//     Get.toNamed('/company-prep');
//   }
//
//   void onQuickQuizTap() {
//     _ensureController();
//     Get.toNamed('/mock-interview');
//   }
//
//   void onBehavioralTap() {
//     _ensureController();
//     Get.toNamed('/mock-interview');
//   }
//
//   void onRoleTap(String role) {
//     _ensureController();
//     final ctrl = Get.find<MockInterviewController>();
//     ctrl.selectRole(role);
//     Get.toNamed('/mock-interview');
//   }
//
//   void onExploreRecommendation() {
//     _ensureController();
//     Get.toNamed('/mock-interview');
//   }
//
//   void toggleAiRecommendation(bool val) {
//     aiRecommendationEnabled.value = val;
//   }
// }


import 'package:get/get.dart';
import 'package:intervu_ai/controllers/mock_interview_controller.dart';

class PracticeController extends GetxController {
  final RxString dailyChallengeTitle = 'Backend Dev — Hard Mode'.obs;
  final RxString dailyChallengeCountdown = '08:42:10'.obs;
  final RxBool aiRecommendationEnabled = false.obs;

  final RxList<Map<String, dynamic>> roleCards = <Map<String, dynamic>>[
    {'role': 'Flutter', 'badge': '98% BEST', 'isBest': true},
    {'role': 'Backend', 'badge': '85% BEST', 'isBest': true},
    {'role': 'Frontend', 'badge': 'NEW', 'isBest': false},
    {'role': 'iOS Dev', 'badge': 'NEW', 'isBest': false},
    {'role': 'Full Stack', 'badge': 'HOT', 'isBest': true},
  ].obs;

  void _ensureController() {
    if (!Get.isRegistered<MockInterviewController>()) {
      Get.put(MockInterviewController());
    }
  }

  void onStartDailyChallenge() {
    _ensureController();
    Get.toNamed('/mock-interview');
  }

  void onMockInterviewTap() {
    _ensureController();
    Get.toNamed('/mock-interview');
  }

  void onResumePrepTap() {
    _ensureController();
    Get.toNamed('/resume-prep');
  }

  void onCompanyModeTap() {
    _ensureController();
    Get.toNamed('/company-prep');
  }

  void onQuickQuizTap() {
    _ensureController();
    Get.toNamed('/mock-interview');
  }

  void onBehavioralTap() {
    _ensureController();
    Get.toNamed('/mock-interview');
  }

  void onRoleTap(String role) {
    _ensureController();
    final ctrl = Get.find<MockInterviewController>();
    ctrl.selectRole(role);
    Get.toNamed('/mock-interview');
  }

  void onExploreRecommendation() {
    _ensureController();
    Get.toNamed('/mock-interview');
  }

  void toggleAiRecommendation(bool val) {
    aiRecommendationEnabled.value = val;
  }
}

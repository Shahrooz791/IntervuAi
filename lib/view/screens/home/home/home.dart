// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intervu_ai/controllers/home_controller.dart';
// import 'package:intervu_ai/core/constants/app_colors.dart';
// import 'package:intervu_ai/core/utils/size_utils.dart';
// import 'package:intervu_ai/view/screens/home/home/components/paractice_grid.dart';
// import 'package:intervu_ai/view/screens/home/home/components/recent_session_list.dart';
// import 'package:intervu_ai/view/widgets/app_text.dart';
// import 'components/greeting_card.dart';
// import 'components/stats_row.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   late AnimationController _entryController;
//   late List<Animation<Offset>> _itemSlides;
//   late List<Animation<double>> _itemOpacities;
//
//   final _ctrl = Get.find<HomeController>();
//
//   static const int _itemCount = 5;
//
//   @override
//   void initState() {
//     super.initState();
//     _initAnimations();
//     _startEntry();
//   }
//
//   void _initAnimations() {
//     _entryController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1400),
//     );
//
//     _itemSlides = List.generate(_itemCount, (i) {
//       final start = i * 0.12;
//       final end = (start + 0.45).clamp(0.0, 1.0);
//       return Tween<Offset>(
//         begin: const Offset(0, 0.5),
//         end: Offset.zero,
//       ).animate(CurvedAnimation(
//         parent: _entryController,
//         curve: Interval(start, end, curve: Curves.easeOut),
//       ));
//     });
//
//     _itemOpacities = List.generate(_itemCount, (i) {
//       final start = i * 0.12;
//       final end = (start + 0.4).clamp(0.0, 1.0);
//       return Tween<double>(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(
//           parent: _entryController,
//           curve: Interval(start, end, curve: Curves.easeIn),
//         ),
//       );
//     });
//   }
//
//   Future<void> _startEntry() async {
//     await Future.delayed(const Duration(milliseconds: 100));
//     _entryController.forward();
//   }
//
//   @override
//   void dispose() {
//     _entryController.dispose();
//     super.dispose();
//   }
//
//   Widget _animatedItem(int index, Widget child) {
//     return AnimatedBuilder(
//       animation: _entryController,
//       builder: (_, __) => FadeTransition(
//         opacity: _itemOpacities[index],
//         child: SlideTransition(position: _itemSlides[index], child: child),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.darkBg,
//       body: Stack(
//         children: [
//           _buildBackground(),
//           SafeArea(
//             child: Column(
//               children: [
//                 _buildTopBar(),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: EdgeInsets.symmetric(horizontal: 16.h),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Gap.v(12),
//                         _animatedItem(
//                             0,
//                             Obx(() => GreetingCard(
//                               greeting: _ctrl.greeting,
//                               userName: _ctrl.userName.value,
//                               streak: _ctrl.streak.value,
//                             ))),
//                         Gap.v(16),
//                         _animatedItem(
//                             1,
//                             Obx(() => StatsRow(
//                               sessions: _ctrl.sessions.value,
//                               avgScore: _ctrl.avgScore.value,
//                               streak: _ctrl.streak.value,
//                             ))),
//                         Gap.v(24),
//                         _animatedItem(
//                             2,
//                             _SectionHeader(
//                               title: 'Start Practicing',
//                               onSeeAll: _ctrl.onSeeAllTap,
//                             )),
//                         Gap.v(12),
//                         _animatedItem(
//                           3,
//                           PracticeGrid(
//                             onMockInterview: _ctrl.onMockInterviewTap,
//                             onResumeUpload: _ctrl.onResumeUploadTap,
//                             onCompanyPrep: _ctrl.onCompanyPrepTap,
//                             onQuickQuiz: _ctrl.onQuickQuizTap,
//                           ),
//                         ),
//                         Gap.v(24),
//                         _animatedItem(
//                           4,
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               AppText(
//                                 text: 'Recent Sessions',
//                                 fontSize: 18.fSize,
//                                 fontWeight: FontWeight.w700,
//                                 color: AppColors.textPrimary,
//                               ),
//                               Gap.v(12),
//                               Obx(() => RecentSessionsList(
//                                 sessions: _ctrl.recentSessions,
//                                 onSessionTap: _ctrl.onSessionTap,
//                               )),
//                             ],
//                           ),
//                         ),
//                         Gap.v(32),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBackground() {
//     return Stack(
//       children: [
//         Container(color: AppColors.darkBg),
//         Positioned(
//           top: -100.v,
//           right: -80.h,
//           child: Container(
//             width: 300.h,
//             height: 300.h,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: RadialGradient(
//                 colors: [
//                   AppColors.primaryBlue.withOpacity(0.08),
//                   AppColors.primaryBlue.withOpacity(0.0),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTopBar() {
//     return AnimatedBuilder(
//       animation: _entryController,
//       builder: (_, __) => FadeTransition(
//         opacity: _itemOpacities[0],
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
//           child: Row(
//             children: [
//               Obx(() => _UserAvatar(initials: _ctrl.userInitials.value)),
//               Gap.h(10),
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'Intervu',
//                       style: TextStyle(
//                         fontSize: 18.fSize,
//                         fontWeight: FontWeight.w700,
//                         fontFamily: 'Urbanist',
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'AI',
//                       style: TextStyle(
//                         fontSize: 18.fSize,
//                         fontWeight: FontWeight.w800,
//                         fontFamily: 'Urbanist',
//                         foreground: Paint()
//                           ..shader = const LinearGradient(
//                             colors: [
//                               AppColors.primaryBlue,
//                               AppColors.primaryCyan,
//                             ],
//                           ).createShader(
//                               Rect.fromLTWH(0, 0, 40.h, 24.h)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: _ctrl.onNotificationTap,
//                 child: Container(
//                   width: 40.h,
//                   height: 40.h,
//                   decoration: BoxDecoration(
//                     borderRadius: 12.r,
//                     color: AppColors.darkCard,
//                     border: Border.all(color: AppColors.darkCardBorder),
//                   ),
//                   child: Icon(
//                     Icons.notifications_none_rounded,
//                     color: AppColors.primaryCyan,
//                     size: 20.h,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _UserAvatar extends StatelessWidget {
//   final String initials;
//   const _UserAvatar({required this.initials});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 38.h,
//       height: 38.h,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: AppColors.primaryGradient,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryBlue.withOpacity(0.35),
//             blurRadius: 10.h,
//           ),
//         ],
//       ),
//       child: Center(
//         child: AppText(
//           text: initials,
//           fontSize: 13.fSize,
//           fontWeight: FontWeight.w700,
//           color: AppColors.white,
//         ),
//       ),
//     );
//   }
// }
//
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final VoidCallback onSeeAll;
//   const _SectionHeader({required this.title, required this.onSeeAll});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         AppText(
//           text: title,
//           fontSize: 18.fSize,
//           fontWeight: FontWeight.w700,
//           color: AppColors.textPrimary,
//         ),
//         GestureDetector(
//           onTap: onSeeAll,
//           child: AppText(
//             text: 'See All',
//             fontSize: 14.fSize,
//             fontWeight: FontWeight.w600,
//             color: AppColors.primaryBlue,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/home_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/routes.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/screens/home/home/components/paractice_grid.dart';
import 'package:intervu_ai/view/screens/home/home/components/recent_session_list.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';
import 'components/greeting_card.dart';
import 'components/stats_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late List<Animation<Offset>> _itemSlides;
  late List<Animation<double>> _itemOpacities;

  final _ctrl = Get.find<HomeController>();

  static const int _itemCount = 5;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startEntry();
  }

  void _initAnimations() {
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _itemSlides = List.generate(_itemCount, (i) {
      final start = i * 0.12;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _entryController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ));
    });

    _itemOpacities = List.generate(_itemCount, (i) {
      final start = i * 0.12;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: Interval(start, end, curve: Curves.easeIn),
        ),
      );
    });
  }

  Future<void> _startEntry() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  Widget _animatedItem(int index, Widget child) {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (_, __) => FadeTransition(
        opacity: _itemOpacities[index],
        child: SlideTransition(position: _itemSlides[index], child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap.v(12),
                        _animatedItem(
                            0,
                            Obx(() => GreetingCard(
                              greeting: _ctrl.greeting,
                              userName: _ctrl.userName.value,
                              streak: _ctrl.streak.value,
                            ))),
                        Gap.v(16),
                        _animatedItem(
                            1,
                            Obx(() => StatsRow(
                              sessions: _ctrl.sessions.value,
                              avgScore: _ctrl.avgScore.value,
                              streak: _ctrl.streak.value,
                            ))),
                        Gap.v(24),
                        _animatedItem(
                            2,
                            _SectionHeader(
                              title: 'Start Practicing',
                              onSeeAll: _ctrl.onSeeAllTap,
                            )),
                        Gap.v(12),
                        _animatedItem(
                          3,
                          PracticeGrid(
                            onMockInterview: _ctrl.onMockInterviewTap,
                            onResumeUpload: _ctrl.onResumeUploadTap,
                            onCompanyPrep: _ctrl.onCompanyPrepTap,
                            onQuickQuiz: _ctrl.onQuickQuizTap,
                          ),
                        ),
                        Gap.v(24),
                        _animatedItem(
                          4,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'Recent Sessions',
                                fontSize: 18.fSize,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              Gap.v(12),
                              Obx(() => RecentSessionsList(
                                sessions: _ctrl.recentSessions.toList(),
                                onSessionTap: _ctrl.onSessionTap,
                              )),
                            ],
                          ),
                        ),
                        Gap.v(32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(color: AppColors.darkBg),
        Positioned(
          top: -100.v,
          right: -80.h,
          child: Container(
            width: 300.h,
            height: 300.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryBlue.withOpacity(0.08),
                  AppColors.primaryBlue.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return AnimatedBuilder(
      animation: _entryController,
      builder: (_, __) => FadeTransition(
        opacity: _itemOpacities[0],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
          child: Row(
            children: [
              Obx(() => _UserAvatar(initials: _ctrl.userInitials.value)),
              Gap.h(10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Intervu',
                      style: TextStyle(
                        fontSize: 18.fSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: 'AI',
                      style: TextStyle(
                        fontSize: 18.fSize,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [
                              AppColors.primaryBlue,
                              AppColors.primaryCyan,
                            ],
                          ).createShader(
                              Rect.fromLTWH(0, 0, 40, 24)),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.notifications),
                child: Container(
                  width: 40.h,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: 12.r,
                    color: AppColors.darkCard,
                    border: Border.all(color: AppColors.darkCardBorder),
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.primaryCyan,
                    size: 20.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String initials;
  const _UserAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.h,
      height: 38.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.35),
            blurRadius: 10.h,
          ),
        ],
      ),
      child: Center(
        child: AppText(
          text: initials,
          fontSize: 13.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: title,
          fontSize: 18.fSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: AppText(
            text: 'See All',
            fontSize: 14.fSize,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }
}

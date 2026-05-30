import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intervu_ai/controllers/notification_controller.dart';
import 'package:intervu_ai/core/constants/app_colors.dart';
import 'package:intervu_ai/core/utils/size_utils.dart';
import 'package:intervu_ai/view/widgets/app_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _ctrl = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                _buildFilterChips(),
                Gap.v(8),
                Expanded(
                  child: Obx(() {
                    final today = _ctrl.todayNotifications;
                    final yesterday = _ctrl.yesterdayNotifications;
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      children: [
                        if (_ctrl.unreadCount > 0) ...[
                          _UnreadBanner(count: _ctrl.unreadCount),
                          Gap.v(12),
                        ],
                        if (today.isNotEmpty) ...[
                          _GroupLabel(label: 'TODAY'),
                          Gap.v(8),
                          ...today.map((n) => _NotifTile(
                            data: n,
                            onDelete: () =>
                                _ctrl.deleteNotification(n['id']),
                            onTap: () => _ctrl.markRead(n['id']),
                          )),
                        ],
                        if (yesterday.isNotEmpty) ...[
                          Gap.v(16),
                          _GroupLabel(label: 'YESTERDAY'),
                          Gap.v(8),
                          ...yesterday.map((n) => _NotifTile(
                            data: n,
                            onDelete: () =>
                                _ctrl.deleteNotification(n['id']),
                            onTap: () => _ctrl.markRead(n['id']),
                          )),
                        ],
                        Gap.v(32),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38.h,
              height: 38.h,
              decoration: BoxDecoration(
                borderRadius: 10.r,
                color: AppColors.darkCard,
                border: Border.all(color: AppColors.darkCardBorder),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 16.h,
              ),
            ),
          ),
          Gap.h(12),
          Expanded(
            child: AppText(
              text: 'Notifications',
              fontSize: 20.fSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              maxLines: 1,
            ),
          ),
          Gap.h(8),
          GestureDetector(
            onTap: _ctrl.markAllRead,
            child: AppText(
              text: 'Mark all read',
              fontSize: 13.fSize,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      final selected = _ctrl.selectedFilter.value;
      return SizedBox(
        height: 40.v,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          itemCount: _ctrl.filters.length,
          separatorBuilder: (_, __) => Gap.h(8),
          itemBuilder: (_, i) {
            final f = _ctrl.filters[i];
            final isActive = selected == f;
            return GestureDetector(
              onTap: () => _ctrl.selectFilter(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
                decoration: BoxDecoration(
                  borderRadius: 100.r,
                  color: isActive
                      ? AppColors.primaryBlue
                      : AppColors.darkCard,
                  border: Border.all(
                    color: isActive
                        ? AppColors.primaryBlue
                        : AppColors.darkCardBorder,
                  ),
                ),
                child: AppText(
                  text: f,
                  fontSize: 13.fSize,
                  fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.white
                      : AppColors.textSecondary,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _UnreadBanner extends StatelessWidget {
  final int count;
  const _UnreadBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.v),
      decoration: BoxDecoration(
        borderRadius: 10.r,
        color: AppColors.primaryBlue.withOpacity(0.12),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, color: AppColors.primaryCyan, size: 8.h),
          Gap.h(8),
          Expanded(
            child: AppText(
              text: '$count unread notifications',
              fontSize: 13.fSize,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryCyan,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;
  const _GroupLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: label,
      fontSize: 11.fSize,
      fontWeight: FontWeight.w700,
      color: AppColors.textMuted,
    );
  }
}

class _NotifTile extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _NotifTile({
    required this.data,
    required this.onDelete,
    required this.onTap,
  });

  @override
  State<_NotifTile> createState() => _NotifTileState();
}

class _NotifTileState extends State<_NotifTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.03,
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  IconData _iconFromString(String name) {
    const map = {
      'trending_up': Icons.trending_up_rounded,
      'local_fire_department': Icons.local_fire_department_rounded,
      'emoji_events': Icons.emoji_events_rounded,
      'schedule': Icons.schedule_rounded,
      'lightbulb': Icons.lightbulb_rounded,
    };
    return map[name] ?? Icons.notifications_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final bool isRead = widget.data['isRead'] as bool;
    final bool isSwipeable = widget.data['isSwipeable'] as bool;
    final Color iconColor = Color(widget.data['iconColor'] as int);

    Widget tile = GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) => _pressCtrl.reverse(),
      onTapCancel: () => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _pressCtrl,
        builder: (_, child) => Transform.scale(
          scale: 1.0 - _pressCtrl.value,
          child: child,
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.v),
          padding: EdgeInsets.all(14.h),
          decoration: BoxDecoration(
            borderRadius: 16.r,
            color: isRead ? AppColors.darkCard : AppColors.notifUnread,
            border: Border.all(
              color: isRead
                  ? AppColors.darkCardBorder
                  : AppColors.primaryBlue.withOpacity(0.25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.h,
                height: 42.h,
                decoration: BoxDecoration(
                  borderRadius: 12.r,
                  color: iconColor.withOpacity(0.15),
                ),
                child: Icon(
                  _iconFromString(widget.data['icon'] as String),
                  color: iconColor,
                  size: 20.h,
                ),
              ),
              Gap.h(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText(
                            text: widget.data['title'] as String,
                            fontSize: 14.fSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            maxLines: 1,
                          ),
                        ),
                        Gap.h(8),
                        AppText(
                          text: widget.data['time'] as String,
                          fontSize: 11.fSize,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                    Gap.v(4),
                    AppText(
                      text: widget.data['body'] as String,
                      fontSize: 12.fSize,
                      color: AppColors.textSecondary,
                      maxLines: 2,
                      height: 1.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!isSwipeable) return tile;

    return Dismissible(
      key: Key(widget.data['id'] as String),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: 10.v),
        decoration: BoxDecoration(
          borderRadius: 16.r,
          color: AppColors.notifDelete,
          border: Border.all(color: AppColors.notifDeleteBorder),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.h),
        child: Icon(Icons.delete_outline_rounded,
            color: AppColors.errorRed, size: 22.h),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: tile,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/features/notification/domain/entities/notification_entity.dart';
import 'package:mingda_app/features/notification/presentation/blocs/notification_bloc.dart';
import 'package:mingda_app/features/notification/presentation/blocs/notification_event.dart';
import 'package:mingda_app/features/notification/presentation/blocs/notification_state.dart';
import 'package:mingda_app/features/notification/presentation/widgets/notification_detail_sheet.dart';
import 'package:mingda_app/features/notification/presentation/widgets/notification_empty_state.dart';
import 'package:mingda_app/features/notification/presentation/widgets/notification_item_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        int unreadCount = 0;
        List<NotificationEntity> allList = [];
        List<NotificationEntity> announcementList = [];
        List<NotificationEntity> activityList = [];

        if (state is NotificationLoadedState) {
          unreadCount = state.unreadCount;
          allList = state.allNotifications;
          announcementList = state.announcementNotifications;
          activityList = state.activityNotifications;
        }

        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0.5,
            shadowColor: AppColors.shadowAppBar,
            leading: IconButton(
              key: const Key('notification_back_button'),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              context.tr.notificationsTitle,
              style: AppTextStyles.inter16MediumPrimary,
            ),
            actions: [
              if (unreadCount > 0)
                Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: InkWell(
                    key: const Key('mark_all_read_button'),
                    borderRadius: BorderRadius.circular(20.w),
                    onTap: () {
                      context
                          .read<NotificationBloc>()
                          .add(const MarkAllNotificationsAsReadEvent());
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF0F766E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.w,
                          ),
                          duration: const Duration(seconds: 2),
                          content: Row(
                            children: [
                              const Icon(
                                Icons.done_all_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  context.tr.allNotificationsMarkedRead,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12.5.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        borderRadius: BorderRadius.circular(20.w),
                        border: Border.all(
                          color: const Color(0xFFCCFBF1),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.done_all_rounded,
                            size: 15.w,
                            color: AppColors.filterTealAccent,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            context.tr.markAllRead,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.filterTealAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(54.w),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.w),
                child: Container(
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  padding: EdgeInsets.all(3.w),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
                    indicator: BoxDecoration(
                      color: AppColors.filterTealAccent,
                      borderRadius: BorderRadius.circular(8.w),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.filterTealAccent.withValues(alpha: 0.18),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF64748B),
                    labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: [
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            allList.isEmpty
                                ? context.tr.tabAllNotifications
                                : '${context.tr.tabAllNotifications} (${allList.length})',
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ),
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            announcementList.isEmpty
                                ? context.tr.tabAnnouncements
                                : '${context.tr.tabAnnouncements} (${announcementList.length})',
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ),
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            activityList.isEmpty
                                ? context.tr.tabActivities
                                : '${context.tr.tabActivities} (${activityList.length})',
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: state is NotificationLoadingState
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.filterTealAccent,
                  ),
                )
              : state is NotificationErrorState
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 40.w,
                            color: AppColors.red,
                          ),
                          SizedBox(height: 12.w),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 12.w),
                          ElevatedButton(
                            onPressed: () => context
                                .read<NotificationBloc>()
                                .add(const FetchNotificationsEvent()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.filterTealAccent,
                            ),
                            child: Text(
                              context.tr.retry,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildNotificationList(context, allList),
                        _buildNotificationList(
                          context,
                          announcementList,
                          emptyTitle: context.tr.noAnnouncementsYet,
                          emptyDesc: context.tr.noAnnouncementsDesc,
                        ),
                        _buildNotificationList(
                          context,
                          activityList,
                          emptyTitle: context.tr.noActivitiesYet,
                          emptyDesc: context.tr.noActivitiesDesc,
                        ),
                      ],
                    ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 6.w),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF475569),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          const Expanded(
            child: Divider(
              color: Color(0xFFE2E8F0),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    List<NotificationEntity> notifications, {
    String? emptyTitle,
    String? emptyDesc,
  }) {
    if (notifications.isEmpty) {
      return NotificationEmptyState(
        title: emptyTitle ?? context.tr.noNotificationsYet,
        description: emptyDesc ?? context.tr.noNotificationsDesc,
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayItems = <NotificationEntity>[];
    final yesterdayItems = <NotificationEntity>[];
    final earlierItems = <NotificationEntity>[];

    for (final item in notifications) {
      final itemDate = DateTime(
        item.createdAt.year,
        item.createdAt.month,
        item.createdAt.day,
      );
      if (itemDate.isAtSameMomentAs(today)) {
        todayItems.add(item);
      } else if (itemDate.isAtSameMomentAs(yesterday)) {
        yesterdayItems.add(item);
      } else {
        earlierItems.add(item);
      }
    }

    final sections = <_NotificationSection>[];
    if (todayItems.isNotEmpty) {
      sections.add(_NotificationSection(title: context.tr.today, items: todayItems));
    }
    if (yesterdayItems.isNotEmpty) {
      sections.add(_NotificationSection(title: context.tr.yesterday, items: yesterdayItems));
    }
    if (earlierItems.isNotEmpty) {
      sections.add(_NotificationSection(title: context.tr.earlier, items: earlierItems));
    }

    return RefreshIndicator(
      color: AppColors.filterTealAccent,
      onRefresh: () async {
        context
            .read<NotificationBloc>()
            .add(const FetchNotificationsEvent(isRefresh: true));
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 6.w),
        itemCount: sections.length,
        itemBuilder: (context, sectionIndex) {
          final section = sections[sectionIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(section.title, section.items.length),
              ...section.items.map(
                (item) => NotificationItemCard(
                  notification: item,
                  onTap: () {
                    if (!item.isRead) {
                      context
                          .read<NotificationBloc>()
                          .add(MarkNotificationAsReadEvent(item.id));
                    }
                    NotificationDetailSheet.show(context, item);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NotificationSection {
  final String title;
  final List<NotificationEntity> items;

  const _NotificationSection({
    required this.title,
    required this.items,
  });
}

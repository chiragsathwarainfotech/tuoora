import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdateData {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String time;
  final String description;
  final String category;
  final String? badgeText;
  final Color? badgeColor;
  final Color? badgeBg;
  final String? imageUrl;
  final String section;

  _UpdateData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.time,
    required this.description,
    required this.category,
    this.badgeText,
    this.badgeColor,
    this.badgeBg,
    this.imageUrl,
    required this.section,
  });
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  String selectedFilter = 'All';

  final List<_UpdateData> allUpdates = [
    _UpdateData(
      icon: Icons.account_balance_wallet_outlined,
      iconColor: const Color(0xFF92400E),
      iconBg: const Color(0xFFFFEADC),
      title: 'Fee Reminder',
      time: '10:45 AM',
      description:
          'Second quarter tuition fee payment is due by next Friday. Please review your statement in the Fees section.',
      category: 'Fees',
      badgeText: 'Immediate Action Required',
      badgeColor: const Color(0xFF7F1D1D),
      badgeBg: const Color(0xFFFEF2F2),
      section: 'Today',
    ),
    _UpdateData(
      icon: Icons.edit_note_rounded,
      iconColor: const Color(0xFF1E40AF),
      iconBg: const Color(0xFFDBEAFE),
      title: 'Homework Alert',
      time: '08:20 AM',
      description:
          'Advanced Calculus: Assignment #4 has been posted. Submission deadline: Oct 24th.',
      category: 'Academic',
      badgeText: 'Math Dept.',
      badgeColor: const Color(0xFF1E3A8A),
      badgeBg: const Color(0xFFEFF6FF),
      section: 'Today',
    ),
    _UpdateData(
      icon: Icons.calendar_today_outlined,
      iconColor: const Color(0xFF475569),
      iconBg: const Color(0xFFF1F5F9),
      title: 'Attendance Update',
      time: 'Yesterday',
      description:
          "Weekly attendance report: 98.5%. You've maintained a perfect record for the Physics module this month.",
      category: 'Academic',
      section: 'Earlier',
    ),
    _UpdateData(
      icon: Icons.campaign_outlined,
      iconColor: const Color(0xFF0369A1),
      iconBg: const Color(0xFFE0F2FE),
      title: 'Science Fair 2024',
      time: 'Oct 19',
      description:
          "The annual 'Aeon Innovate' science fair registration is now open for all senior students.",
      category: 'Events',
      imageUrl: 'assets/science_fair.png',
      section: 'Earlier',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<_UpdateData> filteredUpdates = selectedFilter == 'All'
        ? allUpdates
        : allUpdates.where((u) => u.category == selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A8A)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Updates',
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.v32,
            _buildFilterTabs(),
            AppSpacing.v32,
            if (filteredUpdates.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s48),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.filter_list_off_rounded,
                          size: 64, color: Colors.grey.shade300),
                      AppSpacing.v16,
                      Text('No updates in this category',
                          style: AppTextStyles.lexend(
                              fontSize: 14, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ),
            if (filteredUpdates.any((u) => u.section == 'Today')) ...[
              _buildSectionHeader('Today'),
              AppSpacing.v16,
              ...filteredUpdates
                  .where((u) => u.section == 'Today')
                  .map((u) => _buildUpdateCard(u)),
            ],
            if (filteredUpdates.any((u) => u.section == 'Earlier')) ...[
              AppSpacing.v40,
              _buildSectionHeader('Earlier'),
              AppSpacing.v16,
              ...filteredUpdates
                  .where((u) => u.section == 'Earlier')
                  .map((u) => _buildUpdateCard(u)),
            ],
            AppSpacing.v40,
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Fees', 'Academic', 'Events'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: AppSpacing.x24,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.s12),
            child: InkWell(
              onTap: () => setState(() => selectedFilter = filter),
              borderRadius: BorderRadius.circular(AppSpacing.s16),
              child: Container(
                padding: AppSpacing.x24.add(AppSpacing.y12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF003781)
                      : const Color(0xFFEFF3F8),
                  borderRadius: BorderRadius.circular(AppSpacing.s16),
                ),
                child: Text(
                  filter,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: AppSpacing.x28,
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
            ),
          ),
          AppSpacing.h16,
          const Expanded(
            child: Divider(color: Color(0xFFE2E8F0), thickness: AppSpacing.s2),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateCard(_UpdateData data) {
    return Container(
      margin: const EdgeInsets.only(left: 28, right: 28, bottom: 16),
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: AppSpacing.s10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: AppSpacing.all12,
                decoration: BoxDecoration(
                  color: data.iconBg,
                  borderRadius: BorderRadius.circular(AppSpacing.s16),
                ),
                child: Icon(data.icon, color: data.iconColor, size: AppSpacing.s24),
              ),
              AppSpacing.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.title,
                          style: AppTextStyles.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          data.time,
                          style: AppTextStyles.lexend(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.v8,
                    Text(
                      data.description,
                      style: AppTextStyles.lexend(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF475569),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (data.badgeText != null) ...[
            AppSpacing.v20,
            Container(
              padding: AppSpacing.x16.add(AppSpacing.y8),
              decoration: BoxDecoration(
                color: data.badgeBg,
                borderRadius: BorderRadius.circular(AppSpacing.s12),
              ),
              child: Text(
                data.badgeText!,
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: data.badgeColor,
                ),
              ),
            ),
          ],
          if (data.imageUrl != null) ...[
            AppSpacing.v20,
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.s16),
              child: Image.network(
                'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&q=80&w=800',
                width: double.infinity,
                height: AppSpacing.s180,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

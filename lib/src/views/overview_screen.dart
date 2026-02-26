import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bsms/exports.dart';

class OverviewScreen extends StatelessWidget {
  static const routeName = '/overview';
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Exit App?'),
              content: const Text(
                'Are you sure you want to exit the application?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
        if (shouldPop == true) {
          SystemNavigator.pop();
        }
      },
      child: MainScaffold(
        title: context.getTranslated('overview'),
        selectedIndex: 0,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final isDesktop = constraints.maxWidth > 800;
            final paddingAmt = isMobile ? 16.0 : 24.0;

            return Container(
              color: AppColors.scaffoldBg,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(paddingAmt),
                      child: _buildHeader(context, isMobile),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: paddingAmt),
                      child: _buildMetricsRow(context, isMobile),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(paddingAmt),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: _buildUpcomingAppointments(
                                    context,
                                    isMobile,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 2,
                                  child: _buildTopServices(isMobile),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildUpcomingAppointments(context, isMobile),
                                SizedBox(height: paddingAmt),
                                _buildTopServices(isMobile),
                              ],
                            ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            context.getTranslated('welcome_back'),
            style: const TextStyle(fontSize: 14, color: AppColors.grey),
          ),
        ),
        const SizedBox(width: 16),
        _buildNewApptButton(context, isMobile),
      ],
    );
  }

  Widget _buildNewApptButton(BuildContext context, bool isMobile) {
    return SizedBox(
      height: 34,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, color: AppColors.white, size: 15),
        label: Text(
          context.getTranslated('new_appointment'),
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
      ),
    );
  }

  Widget _buildMetricsRow(BuildContext context, bool isMobile) {
    if (isMobile) {
      // Return a 2x2 grid for metric cards on mobile
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.attach_money_rounded,
                  iconBgColor: AppColors.success.withAlpha(26),
                  iconColor: AppColors.success,
                  trend: '+12.5%',
                  trendColor: AppColors.success,
                  value: '\$12,450',
                  title: 'Revenue',
                  isMobile: isMobile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.calendar_today_rounded,
                  iconBgColor: AppColors.warningBg,
                  iconColor: AppColors.warningIcon,
                  trend: '+8.2%',
                  trendColor: AppColors.success,
                  value: '48',
                  title: 'Appts',
                  isMobile: isMobile,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.person_add_alt_1_rounded,
                  iconBgColor: AppColors.primaryLight.withAlpha(50),
                  iconColor: AppColors.primary,
                  trend: '+15.3%',
                  trendColor: AppColors.success,
                  value: '12',
                  title: 'New Clients',
                  isMobile: isMobile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.content_cut_rounded,
                  iconBgColor: AppColors.primaryMuted.withAlpha(50),
                  iconColor: AppColors.primaryMuted,
                  trend: '+5.7%',
                  trendColor: AppColors.success,
                  value: '64',
                  title: 'Svcs Done',
                  isMobile: isMobile,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMetricCard(
            icon: Icons.attach_money_rounded,
            iconBgColor: AppColors.success.withAlpha(26),
            iconColor: AppColors.success,
            trend: '+12.5%',
            trendColor: AppColors.success,
            value: '\$12,450',
            title: 'Total Revenue',
            width: 240,
            isMobile: isMobile,
          ),
          const SizedBox(width: 16),
          _buildMetricCard(
            icon: Icons.calendar_today_rounded,
            iconBgColor: AppColors.warningBg,
            iconColor: AppColors.warningIcon,
            trend: '+8.2%',
            trendColor: AppColors.success,
            value: '48',
            title: 'Appointments',
            width: 240,
            isMobile: isMobile,
          ),
          const SizedBox(width: 16),
          _buildMetricCard(
            icon: Icons.person_add_alt_1_rounded,
            iconBgColor: AppColors.primaryLight.withAlpha(50),
            iconColor: AppColors.primary,
            trend: '+15.3%',
            trendColor: AppColors.success,
            value: '12',
            title: 'New Clients',
            width: 240,
            isMobile: isMobile,
          ),
          const SizedBox(width: 16),
          _buildMetricCard(
            icon: Icons.content_cut_rounded,
            iconBgColor: AppColors.primaryMuted.withAlpha(50),
            iconColor: AppColors.primaryMuted,
            trend: '+5.7%',
            trendColor: AppColors.success,
            value: '64',
            title: 'Services Done',
            width: 240,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String trend,
    required Color trendColor,
    required String value,
    required String title,
    double? width,
    required bool isMobile,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: isMobile ? 36 : 44,
                height: isMobile ? 36 : 44,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: isMobile ? 20 : 24),
              ),
              Text(
                trend,
                style: TextStyle(
                  color: trendColor,
                  fontWeight: FontWeight.w700,
                  fontSize: isMobile ? 12 : 13,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 22 : 26,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointments(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.getTranslated('upcoming_appointments'),
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 13 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 16 : 20),
          _buildAppointmentItem(
            initials: 'EW',
            avatarColor: AppColors.primaryLight,
            clientName: 'Emma Wilson',
            service: 'Hair Coloring',
            time: '10:00 AM',
            employee: 'Sarah Johnson',
            status: 'confirmed',
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 10 : 12),
          _buildAppointmentItem(
            initials: 'OB',
            avatarColor: AppColors.primaryMuted,
            clientName: 'Olivia Brown',
            service: 'Manicure & Pedicure',
            time: '11:30 AM',
            employee: 'Maria Garcia',
            status: 'confirmed',
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 10 : 12),
          _buildAppointmentItem(
            initials: 'SD',
            avatarColor: AppColors.warningIcon,
            clientName: 'Sophia Davis',
            service: 'Facial Treatment',
            time: '1:00 PM',
            employee: 'Lisa Chen',
            status: 'pending',
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 10 : 12),
          _buildAppointmentItem(
            initials: 'AM',
            avatarColor: AppColors.primaryLight,
            clientName: 'Ava Martinez',
            service: 'Hair Cut & Style',
            time: '2:30 PM',
            employee: 'Jane Smith',
            status: 'confirmed',
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem({
    required String initials,
    required Color avatarColor,
    required String clientName,
    required String service,
    required String time,
    required String employee,
    required String status,
    required bool isMobile,
  }) {
    final bool isConfirmed = status == 'confirmed';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 16 : 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: isMobile ? 20 : 24,
            backgroundColor: avatarColor,
            child: Text(
              initials,
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clientName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 14 : 15,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  service,
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: isMobile ? 6 : 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: isMobile ? 12 : 13,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              // Optionally hide employee name on very small screens,
              // but we'll try to let it wrap or scale down.
              Text(
                employee.split(' ').first, // Just first name to save space
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: isMobile ? 11 : 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(width: isMobile ? 8 : 16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12,
              vertical: isMobile ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: isConfirmed
                  ? AppColors.success.withAlpha(26)
                  : AppColors.warningBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isConfirmed ? AppColors.success : AppColors.warningIcon,
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 10 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopServices(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Services',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          _buildTopServiceItem(
            name: 'Hair Coloring',
            bookings: '28 bookings',
            revenue: '\$3,920',
            isUp: true,
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 10 : 12),
          _buildTopServiceItem(
            name: 'Manicure & Ped.', // Shortened text for mobile
            bookings: '24 bookings',
            revenue: '\$2,880',
            isUp: true,
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 10 : 12),
          _buildTopServiceItem(
            name: 'Facial Treatment',
            bookings: '18 bookings',
            revenue: '\$2,340',
            isUp: false,
            isMobile: isMobile,
          ),
          SizedBox(height: isMobile ? 10 : 12),
          _buildTopServiceItem(
            name: 'Hair Cut & Style',
            bookings: '15 bookings',
            revenue: '\$1,950',
            isUp: true,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildTopServiceItem({
    required String name,
    required String bookings,
    required String revenue,
    required bool isUp,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 16 : 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 14 : 15,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  bookings,
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                isUp
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: isUp ? AppColors.success : AppColors.error,
                size: isMobile ? 14 : 16,
              ),
              const SizedBox(height: 4),
              Text(
                revenue,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 14 : 15,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

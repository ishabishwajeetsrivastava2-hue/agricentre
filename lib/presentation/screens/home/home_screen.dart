import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userRole = AppConstants.farmerRole;
  String _userName = 'AgriCentre User';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final preferences = await SharedPreferences.getInstance();

    final savedRole = preferences.getString(
      AppConstants.userRoleKey,
    );

    final savedName = preferences.getString(
      AppConstants.userNameKey,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _userRole = savedRole ?? AppConstants.farmerRole;
      _userName = savedName ?? 'AgriCentre User';
      _isLoading = false;
    });
  }

  void _openRoute(String route) {
    Navigator.pushNamed(
      context,
      route,
    );
  }

  Future<void> _logout() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(
      AppConstants.isLoggedInKey,
    );

    await preferences.remove(
      AppConstants.userRoleKey,
    );

    await preferences.remove(
      AppConstants.userNameKey,
    );

    await preferences.remove(
      AppConstants.userEmailKey,
    );

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.login,
      (route) => false,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _logout();
              },
              child: const Text(AppStrings.logout),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryGreen,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              _openRoute(AppRouter.settings);
            },
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: _showLogoutDialog,
            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: _loadUserData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),

              const SizedBox(height: 24),

              _buildRoleBadge(),

              const SizedBox(height: 26),

              Text(
                _getDashboardTitle(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _getDashboardSubtitle(),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 18),

              _buildDashboard(),

              const SizedBox(height: 28),

              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 14),

              _buildQuickAccess(),

              const SizedBox(height: 28),

              _buildRecentActivity(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getRoleIcon(),
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.welcome,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _userRole,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F7E8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getRoleIcon(),
            size: 18,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 8),
          Text(
            '$_userRole Dashboard',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    switch (_userRole) {
      case AppConstants.transporterRole:
        return _buildTransporterDashboard();

      case AppConstants.buyerRole:
        return _buildBuyerDashboard();

      case AppConstants.farmerRole:
      default:
        return _buildFarmerDashboard();
    }
  }

  Widget _buildFarmerDashboard() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDashboardCard(
          title: 'My Farms',
          value: '3',
          subtitle: 'Registered farms',
          icon: Icons.agriculture_rounded,
          onTap: () {
            _openRoute(AppRouter.farm);
          },
        ),
        _buildDashboardCard(
          title: 'Quality Checks',
          value: '12',
          subtitle: 'Completed checks',
          icon: Icons.verified_outlined,
          onTap: () {
            _openRoute(AppRouter.quality);
          },
        ),
        _buildDashboardCard(
          title: 'Transportation',
          value: '2',
          subtitle: 'Active shipments',
          icon: Icons.local_shipping_outlined,
          onTap: () {
            _openRoute(AppRouter.transport);
          },
        ),
        _buildDashboardCard(
          title: 'Alerts',
          value: '0',
          subtitle: 'Active alerts',
          icon: Icons.notifications_none_rounded,
          onTap: () {
            _openRoute(AppRouter.monitoring);
          },
        ),
      ],
    );
  }

  Widget _buildTransporterDashboard() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDashboardCard(
          title: 'Active Transport',
          value: '2',
          subtitle: 'Shipments running',
          icon: Icons.local_shipping_rounded,
          onTap: () {
            _openRoute(AppRouter.transport);
          },
        ),
        _buildDashboardCard(
          title: 'Live Monitoring',
          value: 'ON',
          subtitle: 'Real-time sensors',
          icon: Icons.sensors_rounded,
          onTap: () {
            _openRoute(AppRouter.monitoring);
          },
        ),
        _buildDashboardCard(
          title: 'Sensor Status',
          value: 'OK',
          subtitle: 'IoT sensors',
          icon: Icons.memory_rounded,
          onTap: () {
            _openRoute(AppRouter.monitoring);
          },
        ),
        _buildDashboardCard(
          title: 'Alerts',
          value: '0',
          subtitle: 'Active warnings',
          icon: Icons.warning_amber_rounded,
          onTap: () {
            _openRoute(AppRouter.monitoring);
          },
        ),
      ],
    );
  }

  Widget _buildBuyerDashboard() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildDashboardCard(
          title: 'Produce Quality',
          value: '92%',
          subtitle: 'Average quality',
          icon: Icons.verified_rounded,
          onTap: () {
            _openRoute(AppRouter.quality);
          },
        ),
        _buildDashboardCard(
          title: 'Shipments',
          value: '3',
          subtitle: 'Being monitored',
          icon: Icons.local_shipping_outlined,
          onTap: () {
            _openRoute(AppRouter.transport);
          },
        ),
        _buildDashboardCard(
          title: 'Reports',
          value: '8',
          subtitle: 'Quality reports',
          icon: Icons.description_outlined,
          onTap: () {
            _openRoute(AppRouter.reports);
          },
        ),
        _buildDashboardCard(
          title: 'Payments',
          value: '₹498',
          subtitle: 'Recent services',
          icon: Icons.account_balance_wallet_outlined,
          onTap: () {
            _openRoute(AppRouter.payment);
          },
        ),
      ],
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F7E8),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primaryGreen,
                      size: 21,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),

              const Spacer(),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccess() {
    final items = _getQuickAccessItems();

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.95,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) {
        return _buildQuickAccessCard(
          title: item['title'] as String,
          icon: item['icon'] as IconData,
          route: item['route'] as String,
        );
      }).toList(),
    );
  }

  Widget _buildQuickAccessCard({
    required String title,
    required IconData icon,
    required String route,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _openRoute(route);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F7E8),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryGreen,
                  size: 23,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getQuickAccessItems() {
    switch (_userRole) {
      case AppConstants.transporterRole:
        return [
          {
            'title': 'Transport',
            'icon': Icons.local_shipping_outlined,
            'route': AppRouter.transport,
          },
          {
            'title': 'Monitoring',
            'icon': Icons.monitor_heart_outlined,
            'route': AppRouter.monitoring,
          },
          {
            'title': 'Quality',
            'icon': Icons.verified_outlined,
            'route': AppRouter.quality,
          },
          {
            'title': 'Reports',
            'icon': Icons.description_outlined,
            'route': AppRouter.reports,
          },
          {
            'title': 'Payment',
            'icon': Icons.payment_outlined,
            'route': AppRouter.payment,
          },
          {
            'title': 'Settings',
            'icon': Icons.settings_outlined,
            'route': AppRouter.settings,
          },
        ];

      case AppConstants.buyerRole:
        return [
          {
            'title': 'Quality',
            'icon': Icons.verified_outlined,
            'route': AppRouter.quality,
          },
          {
            'title': 'Shipments',
            'icon': Icons.local_shipping_outlined,
            'route': AppRouter.transport,
          },
          {
            'title': 'Monitoring',
            'icon': Icons.monitor_heart_outlined,
            'route': AppRouter.monitoring,
          },
          {
            'title': 'Reports',
            'icon': Icons.description_outlined,
            'route': AppRouter.reports,
          },
          {
            'title': 'Payment',
            'icon': Icons.payment_outlined,
            'route': AppRouter.payment,
          },
          {
            'title': 'Settings',
            'icon': Icons.settings_outlined,
            'route': AppRouter.settings,
          },
        ];

      case AppConstants.farmerRole:
      default:
        return [
          {
            'title': 'My Farms',
            'icon': Icons.agriculture_rounded,
            'route': AppRouter.farm,
          },
          {
            'title': 'Quality Check',
            'icon': Icons.verified_outlined,
            'route': AppRouter.quality,
          },
          {
            'title': 'Transportation',
            'icon': Icons.local_shipping_outlined,
            'route': AppRouter.transport,
          },
          {
            'title': 'Monitoring',
            'icon': Icons.monitor_heart_outlined,
            'route': AppRouter.monitoring,
          },
          {
            'title': 'Reports',
            'icon': Icons.description_outlined,
            'route': AppRouter.reports,
          },
          {
            'title': 'Payment',
            'icon': Icons.payment_outlined,
            'route': AppRouter.payment,
          },
        ];
    }
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            _buildActivityItem(
              icon: Icons.sensors_rounded,
              title: 'IoT monitoring system',
              subtitle: 'Ready for real-time monitoring',
            ),

            const Divider(height: 24),

            _buildActivityItem(
              icon: Icons.verified_outlined,
              title: 'Quality checking',
              subtitle: 'Produce inspection available',
            ),

            const Divider(height: 24),

            _buildActivityItem(
              icon: Icons.local_shipping_outlined,
              title: 'Transportation monitoring',
              subtitle: 'Track temperature, humidity and shock',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE2F7E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryGreen,
            size: 21,
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        switch (index) {
          case 1:
            _openRoute(AppRouter.farm);
            break;

          case 2:
            _openRoute(AppRouter.monitoring);
            break;

          case 3:
            _openRoute(AppRouter.settings);
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home_rounded,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.agriculture_outlined,
          ),
          selectedIcon: Icon(
            Icons.agriculture_rounded,
          ),
          label: 'Farms',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.monitor_heart_outlined,
          ),
          selectedIcon: Icon(
            Icons.monitor_heart_rounded,
          ),
          label: 'Monitor',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.settings_outlined,
          ),
          selectedIcon: Icon(
            Icons.settings_rounded,
          ),
          label: 'Settings',
        ),
      ],
    );
  }

  String _getDashboardTitle() {
    switch (_userRole) {
      case AppConstants.transporterRole:
        return 'Transport Dashboard';

      case AppConstants.buyerRole:
        return 'Buyer Dashboard';

      case AppConstants.farmerRole:
      default:
        return 'Farm Dashboard';
    }
  }

  String _getDashboardSubtitle() {
    switch (_userRole) {
      case AppConstants.transporterRole:
        return 'Monitor your shipments and transportation conditions.';

      case AppConstants.buyerRole:
        return 'Track produce quality and shipment information.';

      case AppConstants.farmerRole:
      default:
        return 'Manage your farms, produce and agricultural activities.';
    }
  }

  IconData _getRoleIcon() {
    switch (_userRole) {
      case AppConstants.transporterRole:
        return Icons.local_shipping_rounded;

      case AppConstants.buyerRole:
        return Icons.storefront_rounded;

      case AppConstants.farmerRole:
      default:
        return Icons.agriculture_rounded;
    }
  }
}
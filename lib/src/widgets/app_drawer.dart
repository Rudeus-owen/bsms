import 'package:bsms/src/views/service_list_screen.dart';
import 'package:bsms/src/views/service_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static final List<_DrawerItem> _items = [
    _DrawerItem(icon: Icons.dashboard_outlined, label: 'overview'),
    _DrawerItem(icon: Icons.receipt_long_outlined, label: 'services_record'),
    _DrawerItem(icon: Icons.people_outlined, label: 'employees'),
    _DrawerItem(icon: Icons.shopping_bag_outlined, label: 'beauty_products'),
    _DrawerItem(icon: Icons.local_shipping_outlined, label: 'suppliers'),
    _DrawerItem(icon: Icons.group_outlined, label: 'customer_management'),
    _DrawerItem(icon: Icons.person_outlined, label: 'clients'),
    _DrawerItem(icon: Icons.content_cut_outlined, label: 'services'),
    _DrawerItem(
      icon: Icons.account_balance_wallet_outlined,
      label: 'expense_income',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'B',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Beauty Salon',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'Management',
                        style: TextStyle(fontSize: 12, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isSelected = selectedIndex == index;
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withAlpha(20)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? AppColors.primary : AppColors.grey,
                      size: 22,
                    ),
                    title: Text(
                      context.getTranslated(item.label),
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.black,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      final nav = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      onItemSelected(index);
                      nav.pop(); // close drawer
                      // Navigate based on index
                      String? routeName;
                      switch (index) {
                        case 0:
                          routeName = OverviewScreen.routeName;
                          break;
                        case 1:
                          routeName = ServiceRecordScreen.routeName;
                          break;
                        case 2:
                          routeName = EmployeeScreen.routeName;
                          break;
                        case 5:
                          routeName = CustomerScreen.routeName;
                          break;
                        case 7:
                          routeName = ServiceListScreen.routeName;
                          break;
                      }

                      if (routeName != null) {
                        if (index == 0) {
                          nav.pushNamedAndRemoveUntil(
                            routeName,
                            (route) => false,
                          );
                        } else {
                          nav.pushNamedAndRemoveUntil(
                            routeName,
                            ModalRoute.withName(OverviewScreen.routeName),
                          );
                        }
                      } else {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              '${context.getTranslated(_items[index].label)}${context.getTranslated('coming_soon')}',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Logout
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 4,
              ),
              leading: const Icon(
                Icons.logout,
                color: Colors.redAccent,
                size: 22,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              onTap: () async {
                await ApiAuth.logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    SignInPage.routeName,
                    (route) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;
  _DrawerItem({required this.icon, required this.label});
}

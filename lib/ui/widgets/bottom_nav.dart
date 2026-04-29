// ويدجت الـ Bottom Navigation Bar - شريط التنقل في أسفل الشاشة
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex; // رقم التاب الحالي المفتوح
  final Function(int) onTap; // دالة بتتنادى لما المستخدم يضغط على تاب

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, -4), // الظل فوق الشريط (مش تحته)
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex, // التاب المفتوح حالياً
        onTap: onTap, // لما يضغط على تاب
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary, // لون التاب المختار (أخضر)
        unselectedItemColor: AppColors.grey, // لون التابات التانية (رمادي)
        type: BottomNavigationBarType.fixed, // عشان كل التابات تبقى ظاهرة
        elevation: 0, // من غير ظل إضافي (الظل بتاعنا فوق)
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          // تاب الرئيسية (index 0)
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // أيقونة مملوءة لما يكون مفتوح
            label: 'الرئيسية',
          ),
          // تاب إضافة تبرع (index 1)
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'تبرّع',
          ),
          // تاب تبرعاتي (index 2)
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'تبرعاتي',
          ),
          // تاب تسجيل الخروج (index 3)
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_outlined),
            activeIcon: Icon(Icons.logout),
            label: 'خروج',
          ),
        ],
      ),
    );
  }
}

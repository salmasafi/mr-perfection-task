// شاشة تسجيل الدخول - أول شاشة بيشوفها المستخدم لو مش مسجل
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/app_snackbar.dart';
import '../products_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers عشان نقدر نقرأ قيم الحقول
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // مفتاح الـ Form للتحقق
  bool _isLoading = false; // عشان نعرض loading لما بنتسجل

  // دالة تسجيل الدخول
  Future<void> _login() async {
    setState(() => _isLoading = true); // نبدأ التحميل
    try {
      // بنشيل المسافات الزيادة من الإيميل (بعض الكيبوردات بتضيفها)
      final cleanEmail =
          _emailController.text.replaceAll(RegExp(r'\s+'), '').trim();

      // بنطلب من سوبابيز تسجيل الدخول
      await Supabase.instance.client.auth.signInWithPassword(
        email: cleanEmail,
        password: _passwordController.text.trim(),
      );

      // لو نجح نروح الشاشة الرئيسية
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductsScreen()),
        );
      }
    } on AuthException catch (e) {
      // خطأ من سوبابيز (إيميل غلط، كلمة مرور غلطة...)
      if (mounted) AppSnackbar.showError(context, e.message);
    } catch (e) {
      // خطأ غير متوقع (مشكلة في الإنترنت مثلاً)
      if (mounted) AppSnackbar.showError(context, 'حدث خطأ غير متوقع');
    } finally {
      // دايماً بنوقف التحميل سواء نجح أو فشل
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // لازم نتخلص من الـ controllers عشان منحصلش memory leak
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // بيخلي الشاشة قابلة للـ scroll لو الكيبورد اتفتح
          padding: EdgeInsets.all(Responsive.width(context, 24)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: Responsive.height(context, 40)),

                // أيقونة التطبيق
                Icon(
                  Icons.volunteer_activism,
                  size: Responsive.width(context, 80),
                  color: AppColors.primary,
                ),
                SizedBox(height: Responsive.height(context, 24)),

                // عنوان الترحيب
                Text(
                  'مرحباً بك مجدداً',
                  style: AppTextStyles.titleLarge(context).copyWith(
                    fontSize: Responsive.height(context, 28),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Responsive.height(context, 8)),

                // نص توضيحي
                Text(
                  'سجل دخولك للاستمرار في التبرع والطلب',
                  style: AppTextStyles.bodySmall(context),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Responsive.height(context, 48)),

                // حقل الإيميل
                CustomTextField(
                  hint: 'البريد الإلكتروني',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress, // كيبورد الإيميل
                  icon: Icons.email_outlined,
                ),
                SizedBox(height: Responsive.height(context, 20)),

                // حقل كلمة المرور
                CustomTextField(
                  hint: 'كلمة المرور',
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  obscureText: true, // بيخفي النص
                ),
                SizedBox(height: Responsive.height(context, 32)),

                // زر تسجيل الدخول أو دايرة التحميل
                if (_isLoading)
                  const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary)) // دايرة تحميل
                else
                  CustomButton(
                    text: 'تسجيل الدخول',
                    onPressed: _login,
                  ),

                SizedBox(height: Responsive.height(context, 24)),

                // رابط إنشاء حساب جديد
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟',
                      style: AppTextStyles.bodySmall(context),
                    ),
                    TextButton(
                      onPressed: () {
                        // بنروح لشاشة التسجيل
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: Text(
                        'أنشئ حساب جديد',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

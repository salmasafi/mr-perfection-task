// شاشة إنشاء حساب جديد - المستخدم بيدخل بياناته هنا عشان يسجل
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/app_snackbar.dart';
import '../products_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // controller لكل حقل عشان نقدر نقرأ قيمته
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // مفتاح الـ Form
  bool _isLoading = false; // عشان نعرض loading لما بنسجل

  // دالة إنشاء الحساب
  Future<void> _register() async {
    setState(() => _isLoading = true); // نبدأ التحميل
    try {
      // بنشيل المسافات الزيادة من الإيميل
      final cleanEmail =
          _emailController.text.replaceAll(RegExp(r'\s+'), '').trim();

      // الخطوة 1: بنسجل المستخدم في سوبابيز Auth
      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: cleanEmail,
        password: _passwordController.text.trim(),
        data: {
          'full_name': _nameController.text.trim(), // بنبعت الاسم مع التسجيل
        },
      );

      final user = res.user; // بنجيب بيانات المستخدم الجديد
      if (user != null) {
        // الخطوة 2: بنحدث الـ profile بالبيانات الإضافية (هاتف وعنوان)
        await Supabase.instance.client.from('profiles').upsert({
          'id': user.id, // الـ ID بتاع المستخدم
          'full_name': _nameController.text.trim(),
          'phone_number': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
        });

        // لو كل حاجة تمام نروح الشاشة الرئيسية
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ProductsScreen()),
            (route) => false, // بنمسح كل الشاشات السابقة من الـ stack
          );
        }
      }
    } on AuthException catch (e) {
      // خطأ من سوبابيز (إيميل موجود قبل كده مثلاً)
      if (mounted) AppSnackbar.showError(context, e.message);
    } catch (e) {
      // خطأ غير متوقع
      if (mounted) AppSnackbar.showError(context, 'حدث خطأ غير متوقع');
    } finally {
      // دايماً بنوقف التحميل
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // بنتخلص من كل الـ controllers
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // زر الرجوع بلون النص
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Responsive.width(context, 24)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // عنوان الشاشة
                Text(
                  'حساب جديد',
                  style: AppTextStyles.titleLarge(context).copyWith(
                    fontSize: Responsive.height(context, 28),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Responsive.height(context, 8)),

                // نص توضيحي
                Text(
                  'أدخل بياناتك لإنشاء حسابك الجديد',
                  style: AppTextStyles.bodySmall(context),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Responsive.height(context, 40)),

                // حقل الاسم الكامل
                CustomTextField(
                  hint: 'الاسم الكامل',
                  controller: _nameController,
                  icon: Icons.person_outline,
                ),
                SizedBox(height: Responsive.height(context, 20)),

                // حقل الإيميل
                CustomTextField(
                  hint: 'البريد الإلكتروني',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: Responsive.height(context, 20)),

                // حقل رقم الهاتف
                CustomTextField(
                  hint: 'رقم الهاتف',
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone, // كيبورد الأرقام
                ),
                SizedBox(height: Responsive.height(context, 20)),

                // حقل العنوان
                CustomTextField(
                  hint: 'العنوان',
                  controller: _addressController,
                  icon: Icons.location_on_outlined,
                ),
                SizedBox(height: Responsive.height(context, 20)),

                // حقل كلمة المرور
                CustomTextField(
                  hint: 'كلمة المرور',
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  obscureText: true, // بيخفي النص
                ),
                SizedBox(height: Responsive.height(context, 40)),

                // زر إنشاء الحساب أو دايرة التحميل
                if (_isLoading)
                  const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary))
                else
                  CustomButton(
                    text: 'إنشاء الحساب',
                    onPressed: _register,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

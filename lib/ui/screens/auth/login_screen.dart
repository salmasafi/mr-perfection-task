import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../products_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final cleanEmail = _emailController.text.replaceAll(RegExp(r'\s+'), '').trim();

      await Supabase.instance.client.auth.signInWithPassword(
        email: cleanEmail,
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductsScreen()),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ غير متوقع'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Responsive.width(context, 24)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: Responsive.height(context, 40)),
                Icon(
                  Icons.volunteer_activism,
                  size: Responsive.width(context, 80),
                  color: AppColors.primary,
                ),
                SizedBox(height: Responsive.height(context, 24)),
                Text(
                  'مرحباً بك مجدداً',
                  style: AppTextStyles.titleLarge(context).copyWith(
                    fontSize: Responsive.height(context, 28),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Responsive.height(context, 8)),
                Text(
                  'سجل دخولك للاستمرار في التبرع والطلب',
                  style: AppTextStyles.bodySmall(context),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Responsive.height(context, 48)),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontFamily: 'Cairo'),
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.width(context, 12)),
                    ),
                    filled: true,
                    fillColor: AppColors.card,
                  ),
                ),
                SizedBox(height: Responsive.height(context, 20)),
                
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(fontFamily: 'Cairo'),
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.width(context, 12)),
                    ),
                    filled: true,
                    fillColor: AppColors.card,
                  ),
                ),
                SizedBox(height: Responsive.height(context, 32)),
                
                if (_isLoading)
                  const Center(child: CircularProgressIndicator(color: AppColors.primary))
                else
                  CustomButton(
                    text: 'تسجيل الدخول',
                    onPressed: _login,
                  ),
                
                SizedBox(height: Responsive.height(context, 24)),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟',
                      style: AppTextStyles.bodySmall(context),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
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

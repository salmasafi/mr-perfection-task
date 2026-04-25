import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../widgets/custom_button.dart';
import '../products_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() => _isLoading = true);
    try {
      // إزالة أي مسافات مخفية قد تضاف بالخطأ من لوحة المفاتيح
      final cleanEmail = _emailController.text.replaceAll(RegExp(r'\s+'), '').trim();

      // 1. Sign up user
      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: cleanEmail,
        password: _passwordController.text.trim(),
        data: {
          'full_name': _nameController.text.trim(),
        },
      );

      final user = res.user;
      if (user != null) {
        // 2. Update profiles with additional info
        await Supabase.instance.client.from('profiles').upsert({
          'id': user.id,
          'full_name': _nameController.text.trim(),
          'phone_number': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
        });

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ProductsScreen()),
            (route) => false,
          );
        }
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
                Text(
                  'حساب جديد',
                  style: AppTextStyles.titleLarge(context).copyWith(
                    fontSize: Responsive.height(context, 28),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Responsive.height(context, 8)),
                Text(
                  'أدخل بياناتك لإنشاء حسابك الجديد',
                  style: AppTextStyles.bodySmall(context),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Responsive.height(context, 40)),
                
                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: 'الاسم الكامل',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: Responsive.height(context, 20)),
                
                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: Responsive.height(context, 20)),
                
                // Phone Field
                _buildTextField(
                  controller: _phoneController,
                  label: 'رقم الهاتف',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: Responsive.height(context, 20)),
                
                // Address Field
                _buildTextField(
                  controller: _addressController,
                  label: 'العنوان',
                  icon: Icons.location_on_outlined,
                ),
                SizedBox(height: Responsive.height(context, 20)),

                // Password Field
                _buildTextField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                SizedBox(height: Responsive.height(context, 40)),
                
                if (_isLoading)
                  const Center(child: CircularProgressIndicator(color: AppColors.primary))
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(fontFamily: 'Cairo'),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Responsive.width(context, 12)),
        ),
        filled: true,
        fillColor: AppColors.card,
      ),
    );
  }
}

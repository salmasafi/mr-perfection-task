// شاشة إضافة تبرع جديد - المستخدم بيدخل بيانات التبرع هنا
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/motivational_banner.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_snackbar.dart';
import '../../logic/api/api_service.dart';

class AddProductScreen extends StatefulWidget {
  // callback بيتنادى لما التبرع يتنشر بنجاح عشان نرجع للرئيسية
  final VoidCallback? onDonationPublished;

  const AddProductScreen({super.key, this.onDonationPublished});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // controllers لحقول الإدخال
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isLoading = false; // عشان نعرض loading لما بننشر

  @override
  void dispose() {
    // بنتخلص من الـ controllers عشان منحصلش memory leak
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // دالة نشر التبرع
  Future<void> _publishDonation() async {
    // بنتأكد إن الاسم مش فاضي
    if (_titleController.text.isEmpty) {
      AppSnackbar.showError(context, 'يرجى إدخال اسم التبرع');
      return; // بنوقف هنا ومنكملش
    }

    setState(() => _isLoading = true); // نبدأ التحميل

    // بنبعت البيانات للـ API
    final success = await ApiService().createDonation(
      title: _titleController.text,
      description: _descriptionController.text,
      imageUrl: _imageUrlController.text.trim(), // بنشيل المسافات من الرابط
    );

    if (!mounted) return; // لو الشاشة اتقفلت منكملش
    setState(() => _isLoading = false); // نوقف التحميل

    if (success) {
      // نجح! بنعرض ديالوج النجاح
      AppDialog.show(
        context: context,
        title: 'تم نشر التبرع! 💚',
        content: 'شكراً لكرمك!\nتم نشر تبرعك الآن بنجاح وسيظهر للجميع.',
        onConfirm: () {
          Navigator.pop(context); // بنقفل الديالوج
          widget.onDonationPublished?.call(); // بنرجع للرئيسية ونحدث المنتجات
        },
      );
    } else {
      // فشل - بنعرض رسالة خطأ
      AppSnackbar.showError(
          context, 'حدث خطأ أثناء نشر التبرع. يرجى المحاولة لاحقاً.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'إضافة تبرع',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.text,
            fontSize: Responsive.height(context, 20),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.width(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بانر تحفيزي في الأعلى
            const MotivationalBanner(
              text: 'تبرعك يصنع الفرق في حياة شخص آخر',
            ),
            SizedBox(height: Responsive.height(context, 24)),

            // حقل اسم التبرع
            CustomTextField(
              hint: 'اسم التبرع',
              controller: _titleController,
            ),
            SizedBox(height: Responsive.height(context, 16)),

            // حقل وصف التبرع - متعدد الأسطر
            CustomTextField(
              hint: 'وصف التبرع',
              controller: _descriptionController,
              maxLines: 4, // 4 أسطر عشان يقدر يكتب وصف كافي
            ),
            SizedBox(height: Responsive.height(context, 16)),

            // حقل رابط الصورة
            CustomTextField(
              hint: 'رابط الصورة',
              controller: _imageUrlController,
              icon: Icons.link, // أيقونة رابط
            ),
            SizedBox(height: Responsive.height(context, 32)),

            // زر النشر أو دايرة التحميل
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : CustomButton(
                    text: 'نشر التبرع',
                    icon: Icons.volunteer_activism, // أيقونة قلب
                    onPressed: _publishDonation,
                  ),
          ],
        ),
      ),
    );
  }
}

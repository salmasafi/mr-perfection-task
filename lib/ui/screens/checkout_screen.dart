// شاشة تأكيد الطلب - المستخدم بيدخل بيانات التوصيل هنا عشان يطلب التبرع
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/models/product_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_snackbar.dart';
import '../../logic/api/api_service.dart';

class CheckoutScreen extends StatefulWidget {
  final ProductModel product; // التبرع اللي المستخدم عايز ياخده

  const CheckoutScreen({super.key, required this.product});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // controllers لحقول بيانات التوصيل
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isLoading = false; // عشان نعرض loading لما بنبعت الطلب

  @override
  void dispose() {
    // بنتخلص من كل الـ controllers
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // دالة إرسال الطلب
  Future<void> _submitRequest() async {
    // بنتأكد إن الحقول الإجبارية مش فاضية
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      AppSnackbar.showError(context, 'يرجى ملء جميع الحقول المطلوبة');
      return; // بنوقف هنا
    }

    setState(() => _isLoading = true); // نبدأ التحميل

    // بنبعت الطلب للـ API
    final success = await ApiService().createDonationRequest(
      productId: widget.product.id, // رقم التبرع
      fullName: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      message: _messageController.text, // الرسالة اختيارية
    );

    if (!mounted) return; // لو الشاشة اتقفلت منكملش
    setState(() => _isLoading = false); // نوقف التحميل

    if (success) {
      // نجح! بنعرض ديالوج النجاح
      AppDialog.show(
        context: context,
        title: 'تم تأكيد الطلب! 🎉',
        content: 'سيتم التواصل معك لتنسيق التسليم.\nشكراً لثقتك!',
        onConfirm: () {
          Navigator.pop(context); // بنقفل الديالوج
          Navigator.pop(context); // بنرجع لشاشة التفاصيل
        },
      );
    } else {
      // فشل - بنعرض رسالة خطأ
      AppSnackbar.showError(
          context, 'حدث خطأ أثناء الطلب. يرجى المحاولة لاحقاً.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context), // زر الرجوع
        ),
        title: Text(
          'تأكيد طلب التبرع',
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
            // ========== ملخص التبرع المطلوب ==========
            Container(
              padding: EdgeInsets.all(Responsive.width(context, 16)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius:
                    BorderRadius.circular(Responsive.width(context, 16)),
                boxShadow: [
                  BoxShadow(color: AppColors.shadow, spreadRadius: 0, blurRadius: 15),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان القسم
                  Text(
                    'ملخص الطلب',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: Responsive.height(context, 18),
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: Responsive.height(context, 12)),

                  // صورة واسم التبرع
                  Row(
                    children: [
                      // صورة صغيرة للتبرع
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            // لما الصورة بتتحمل
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null)
                                return child; // خلصت التحميل
                              return Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    // نسبة التحميل لو عارفينها
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: AppColors.primary.withValues(alpha: 0.5),
                                  ),
                                ),
                              );
                            },
                            // لو الصورة فشلت
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: AppColors.greyLight,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Responsive.width(context, 12)),

                      // اسم التبرع وكلمة "مجاني"
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.title,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: Responsive.height(context, 14),
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'مجاني', // كل التبرعات مجانية
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: Responsive.height(context, 12),
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.height(context, 24)),

            // ========== حقول بيانات التوصيل ==========
            Text(
              'معلومات التوصيل',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: Responsive.height(context, 18),
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: Responsive.height(context, 16)),

            // حقل الاسم (إجباري)
            CustomTextField(
              hint: 'الاسم الكامل',
              controller: _nameController,
              isRequired: true, // بيضيف * في الـ hint
            ),
            SizedBox(height: Responsive.height(context, 12)),

            // حقل الهاتف (إجباري)
            CustomTextField(
              hint: 'رقم الهاتف',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              isRequired: true,
            ),
            SizedBox(height: Responsive.height(context, 12)),

            // حقل العنوان (إجباري) - متعدد الأسطر
            CustomTextField(
              hint: 'العنوان الكامل',
              controller: _addressController,
              maxLines: 3,
              isRequired: true,
            ),
            SizedBox(height: Responsive.height(context, 12)),

            // حقل الرسالة (اختياري)
            CustomTextField(
              hint: 'رسالة للمتبرع (اختياري)',
              controller: _messageController,
              maxLines: 2,
            ),
            SizedBox(height: Responsive.height(context, 16)),

            // ========== بانر التوصيل المجاني ==========
            Container(
              padding: EdgeInsets.all(Responsive.width(context, 14)),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius:
                    BorderRadius.circular(Responsive.width(context, 12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_shipping_outlined,
                      color: AppColors.primary,
                      size: Responsive.width(context, 22)),
                  SizedBox(width: Responsive.width(context, 10)),
                  Text(
                    'التوصيل مجاني بالكامل',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.height(context, 14),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.height(context, 32)),

            // زر تأكيد الطلب أو دايرة التحميل
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : CustomButton(
                    text: 'تأكيد الطلب',
                    icon: Icons.check_circle,
                    onPressed: _submitRequest,
                  ),
          ],
        ),
      ),
    );
  }
}

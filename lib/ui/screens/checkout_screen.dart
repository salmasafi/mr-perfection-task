import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../logic/cubit/cart_cubit.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../../logic/api/api_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _submitRequest(BuildContext context) async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى ملء جميع الحقول المطلوبة'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final requestsCubit = context.read<RequestsCubit>();
    if (requestsCubit.state.items.isEmpty) return;

    setState(() => _isLoading = true);

    final success = await ApiService().createDonationRequests(
      requests: requestsCubit.state.items,
      fullName: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      message: _messageController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'تم تأكيد الطلب! 🎉',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'سيتم التواصل معك لتنسيق التسليم.\nشكراً لثقتك!',
            style: TextStyle(fontFamily: 'Cairo', 
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  requestsCubit.clearRequests();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'حسناً',
                  style: TextStyle(fontFamily: 'Cairo', 
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('حدث خطأ أثناء الطلب. يرجى المحاولة لاحقاً.'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'تأكيد طلب التبرع',
          style: TextStyle(fontFamily: 'Cairo', 
            color: AppColors.text,
            fontSize: Responsive.height(context, 20),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RequestsCubit, RequestsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(Responsive.width(context, 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order summary
                Container(
                  padding: EdgeInsets.all(Responsive.width(context, 16)),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius:
                        BorderRadius.circular(Responsive.width(context, 16)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        spreadRadius: 0,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ملخص الطلب',
                        style: TextStyle(fontFamily: 'Cairo', 
                          fontSize: Responsive.height(context, 18),
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      SizedBox(height: Responsive.height(context, 12)),
                      ...state.items.map((item) => Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Responsive.height(context, 6),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: Responsive.width(context, 6),
                                  height: Responsive.width(context, 6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: Responsive.width(context, 10)),
                                Expanded(
                                  child: Text(
                                    item.product.title,
                                    style: TextStyle(fontFamily: 'Cairo', 
                                      fontSize:
                                          Responsive.height(context, 14),
                                      color: AppColors.text,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Responsive.width(context, 8),
                                    vertical: Responsive.height(context, 2),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(
                                        Responsive.width(context, 6)),
                                  ),
                                  child: Text(
                                    'مجاني',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          Responsive.height(context, 10),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Divider(
                        color: AppColors.divider,
                        height: Responsive.height(context, 24),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'إجمالي الطلبات:',
                            style: TextStyle(fontFamily: 'Cairo', 
                              fontSize: Responsive.height(context, 15),
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            '${state.totalItems} تبرع',
                            style: TextStyle(fontFamily: 'Cairo', 
                              fontSize: Responsive.height(context, 16),
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.height(context, 24)),

                // Delivery info
                Text(
                  'معلومات التوصيل',
                  style: TextStyle(fontFamily: 'Cairo', 
                    fontSize: Responsive.height(context, 18),
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(height: Responsive.height(context, 16)),
                CustomTextField(
                  hint: 'الاسم الكامل',
                  controller: _nameController,
                  isRequired: true,
                ),
                SizedBox(height: Responsive.height(context, 12)),
                CustomTextField(
                  hint: 'رقم الهاتف',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                ),
                SizedBox(height: Responsive.height(context, 12)),
                CustomTextField(
                  hint: 'العنوان الكامل',
                  controller: _addressController,
                  maxLines: 3,
                  isRequired: true,
                ),
                SizedBox(height: Responsive.height(context, 12)),
                CustomTextField(
                  hint: 'رسالة للمتبرع (اختياري)',
                  controller: _messageController,
                  maxLines: 2,
                ),
                SizedBox(height: Responsive.height(context, 16)),

                // Free delivery info
                Container(
                  padding: EdgeInsets.all(Responsive.width(context, 14)),
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius:
                        BorderRadius.circular(Responsive.width(context, 12)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.primary,
                        size: Responsive.width(context, 22),
                      ),
                      SizedBox(width: Responsive.width(context, 10)),
                      Text(
                        'التوصيل مجاني بالكامل',
                        style: TextStyle(fontFamily: 'Cairo', 
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.height(context, 14),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.height(context, 32)),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary))
                    : CustomButton(
                        text: 'تأكيد الطلب',
                        icon: Icons.check_circle,
                        onPressed: () => _submitRequest(context),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

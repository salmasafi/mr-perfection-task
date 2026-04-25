import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../../logic/api/api_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'إلكترونيات';
  String _selectedCondition = 'مستعمل جيد';

  final List<String> _categories = [
    'إلكترونيات',
    'ملابس',
    'أثاث',
    'كتب',
    'ألعاب',
    'رياضة',
    'إكسسوارات',
    'أخرى',
  ];

  final List<String> _conditions = [
    'جديد',
    'مستعمل جيد',
    'مستعمل',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _publishDonation() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى إدخال اسم التبرع'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final success = await ApiService().createDonation(
      title: _titleController.text,
      description: _descriptionController.text,
      categoryName: _selectedCategory,
      condition: _selectedCondition,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'تم نشر التبرع! 💚',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'شكراً لكرمك!\nتم نشر تبرعك الآن بنجاح وسيظهر للجميع.',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                child: const Text(
                  'حسناً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
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
          content:
              const Text('حدث خطأ أثناء نشر التبرع. يرجى المحاولة لاحقاً.'),
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
            // Motivational message
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Responsive.width(context, 16)),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius:
                    BorderRadius.circular(Responsive.width(context, 16)),
              ),
              child: Row(
                children: [
                  Text(
                    '💚',
                    style: TextStyle(fontSize: Responsive.height(context, 24)),
                  ),
                  SizedBox(width: Responsive.width(context, 12)),
                  Expanded(
                    child: Text(
                      'تبرعك يصنع الفرق في حياة شخص آخر',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: Responsive.height(context, 13),
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Responsive.height(context, 24)),

            CustomTextField(
              hint: 'اسم التبرع',
              controller: _titleController,
              isRequired: true,
            ),
            SizedBox(height: Responsive.height(context, 16)),
            CustomTextField(
              hint: 'وصف التبرع',
              controller: _descriptionController,
              maxLines: 4,
            ),
            SizedBox(height: Responsive.height(context, 16)),

            // Category dropdown
            _buildDropdown(
              value: _selectedCategory,
              items: _categories,
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            SizedBox(height: Responsive.height(context, 16)),

            // Condition dropdown
            _buildDropdown(
              value: _selectedCondition,
              items: _conditions,
              onChanged: (value) => setState(() => _selectedCondition = value!),
            ),
            SizedBox(height: Responsive.height(context, 16)),

            // Image upload area
            Text(
              'الصور',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: Responsive.height(context, 16),
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: Responsive.height(context, 8)),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('اختيار الصور من المعرض (قريباً)'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: Container(
                height: Responsive.width(context, 120),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius:
                      BorderRadius.circular(Responsive.width(context, 16)),
                  border: Border.all(
                    color: AppColors.greyMedium,
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: Responsive.width(context, 40),
                        color: AppColors.grey,
                      ),
                      SizedBox(height: Responsive.height(context, 8)),
                      Text(
                        'إضافة صور',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                          fontSize: Responsive.height(context, 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: Responsive.height(context, 32)),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : CustomButton(
                    text: 'نشر التبرع',
                    icon: Icons.volunteer_activism,
                    onPressed: _publishDonation,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.width(context, 16),
      ),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(Responsive.width(context, 15)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.text,
            fontSize: Responsive.height(context, 14),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

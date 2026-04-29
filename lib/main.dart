// ده أول ملف بيتشغل في التطبيق - زي باب البيت
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // عشان التطبيق يدعم اللغة العربية
import 'package:flutter_bloc/flutter_bloc.dart'; // مكتبة إدارة الحالة
import 'core/theme/app_theme.dart'; // الثيم بتاع التطبيق (الألوان والخطوط)
import 'logic/cubit/products_cubit.dart'; // الكيوبت اللي بيتحكم في المنتجات
import 'logic/api/api_service.dart'; // الكلاس اللي بيتكلم مع السيرفر
import 'ui/screens/products_screen.dart'; // الشاشة الرئيسية

import 'package:supabase_flutter/supabase_flutter.dart'; // مكتبة سوبابيز (قاعدة البيانات)
import 'ui/screens/auth/login_screen.dart'; // شاشة تسجيل الدخول

// main هي أول دالة بتتشغل في أي تطبيق Flutter
Future<void> main() async {
  // لازم تتنادى الأول عشان نقدر نستخدم الـ async قبل ما التطبيق يشتغل
  WidgetsFlutterBinding.ensureInitialized();

  // بنوصل سوبابيز بالـ URL والـ Key بتاعت المشروع
  await Supabase.initialize(
    url: 'https://hgosuedsbgcylxruiaet.supabase.co', // عنوان قاعدة البيانات
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhnb3N1ZWRzYmdjeWx4cnVpYWV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcwNjE4NDMsImV4cCI6MjA5MjYzNzg0M30.A83-0VgEzP4EohwinLcVDRsAtIbUcaiSpZtMnHNiE3M', // المفتاح العام للوصول
  );

  // بنشغل التطبيق
  runApp(const DonationApp());
}

// الكلاس الرئيسي للتطبيق - بيورث StatelessWidget لأنه مش محتاج يتغير
class DonationApp extends StatelessWidget {
  const DonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    // بنعمل instance من الـ ApiService عشان نبعته للـ Cubit
    final apiService = ApiService();

    // MultiBlocProvider بيخلي الـ Cubits متاحة في كل التطبيق
    return MultiBlocProvider(
      providers: [
        // بنعمل ProductsCubit ونبدأ نجيب المنتجات فوراً
        BlocProvider(
          create: (context) => ProductsCubit(apiService)..fetchProducts(),
        ),
      ],
      child: MaterialApp(
        title: 'Nafaa', // اسم التطبيق
        debugShowCheckedModeBanner: false, // بنخفي الـ DEBUG banner الأحمر
        theme: buildAppTheme(context), // بنطبق الثيم بتاعنا
        locale: const Locale('ar'), // اللغة العربية
        supportedLocales: const [Locale('ar')], // اللغات المدعومة
        // المندوبين بتوع الترجمة عشان الأزرار والتواريخ تبقى بالعربي
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // لو المستخدم مسجل دخول روحه الشاشة الرئيسية، لو لأ روحه شاشة الدخول
        home: Supabase.instance.client.auth.currentUser == null
            ? const LoginScreen() // مفيش يوزر مسجل → شاشة الدخول
            : const ProductsScreen(), // في يوزر مسجل → الشاشة الرئيسية
      ),
    );
  }
}

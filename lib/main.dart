import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'logic/cubit/cart_cubit.dart';
import 'logic/cubit/products_cubit.dart';
import 'ui/screens/products_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'ui/screens/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://hgosuedsbgcylxruiaet.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhnb3N1ZWRzYmdjeWx4cnVpYWV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcwNjE4NDMsImV4cCI6MjA5MjYzNzg0M30.A83-0VgEzP4EohwinLcVDRsAtIbUcaiSpZtMnHNiE3M',
  );

  runApp(const DonationApp());
}

class DonationApp extends StatelessWidget {
  const DonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductsCubit()..getAllProducts(),
        ),
        BlocProvider(
          create: (context) => RequestsCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(context),
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Supabase.instance.client.auth.currentUser == null
            ? const LoginScreen()
            : const ProductsScreen(),
      ),
    );
  }
}

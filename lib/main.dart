import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_vault_seller/core/theme/ktheme.dart';
import 'package:game_vault_seller/features/auth/data/repository/imp_auth_repository.dart';
import 'package:game_vault_seller/features/auth/data/service/firebase.dart';
import 'package:game_vault_seller/features/auth/screens/blocs/auth_cupit.dart';
import 'package:game_vault_seller/features/auth/screens/widgets/auth_stream.dart';
import 'package:game_vault_seller/features/dashboard/data/imp_sale_repository.dart';
import 'package:game_vault_seller/features/dashboard/screens/blocs/accounts_cupit.dart';
import 'package:game_vault_seller/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCupit>(
          create: (context) => AuthCupit(
            ImpAuthRepository(FirebaseService(), FirebaseFirestore.instance),
          ),
        ),
        BlocProvider<AccountsCubit>(
          create: (context) => AccountsCubit(ImpSaleRepository()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vault Seller',
      theme: Ktheme.appTheme,
      home: const AuthStream(),
    );
  }
}

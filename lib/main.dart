import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repository/firebase/firebase_food_repository.dart';
import 'data/repository/food_repository.dart';
import 'firebase_options.dart';
import 'ui/providers/food_provider.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 1 - Create repository
  final FoodRepository foodRepository = FirebaseFoodRepository();

  // 2-  Run app
  runApp(
    ChangeNotifierProvider(
      create: (context) => FoodProvider(foodRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page.dart';

void main()async {
  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => HomeProvider(),
        child: const BottomNavigationScreen(),
      ),
      title: 'Flutter Demo',
    );
  }
}

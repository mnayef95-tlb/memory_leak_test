import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_leak_test/first_page.dart';
import 'package:memory_leak_test/second_page.dart';
import 'package:memory_leak_test/third_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const FirstPage(),
      ),
      GoRoute(
        path: '/second',
        builder: (context, state) => const SecondPage(),
      ),
      GoRoute(
        path: '/third',
        builder: (context, state) => const ThirdPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

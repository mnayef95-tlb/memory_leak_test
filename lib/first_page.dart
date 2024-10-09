import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("First Page", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  context.push("/second");
                },
                child: const Text("Go to next page"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

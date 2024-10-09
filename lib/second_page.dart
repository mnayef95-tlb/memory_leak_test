import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Second Page", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Go back"),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  context.push("/third");
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

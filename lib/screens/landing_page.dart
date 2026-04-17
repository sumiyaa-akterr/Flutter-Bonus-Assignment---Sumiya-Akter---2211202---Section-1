import 'package:flutter/material.dart';
import 'ui_page.dart'; // Import your UI page

class LandingPage extends StatelessWidget {
  final String pageName;

  const LandingPage({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.purple[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_alt, size: 100, color: Colors.purpleAccent),
            const SizedBox(height: 20),
            Text(
              "Welcome to $pageName",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UiPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("View Tasks", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
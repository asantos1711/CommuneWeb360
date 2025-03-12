import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
 NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 100),
            const SizedBox(height: 20),
            const Text(
              "404 - Página No Encontrada",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Lo sentimos, la página que buscas no existe.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}

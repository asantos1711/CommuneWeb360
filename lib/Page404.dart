import 'package:flutter/material.dart';

class Page404 extends StatefulWidget {
  const Page404({Key? key}) : super(key: key);

  @override
  State<Page404> createState() => _Page404State();
}

class _Page404State extends State<Page404> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Página no encontrada"),
    );
  }
}

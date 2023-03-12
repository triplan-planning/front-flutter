import 'package:flutter/material.dart';

class GlobalWidthWrapper extends StatelessWidget {
  const GlobalWidthWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 700,
        ),
        child: child,
      ),
    );
  }
}

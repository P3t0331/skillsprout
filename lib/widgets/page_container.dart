import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  PageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          child: child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  PageContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, right: 24.0, left: 24.0),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          child: child,
        ),
      ),
    );
  }
}

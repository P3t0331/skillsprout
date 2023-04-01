import 'package:flutter/material.dart';

class DecoratedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool useGradient;
  final LinearGradient gradient = LinearGradient(
    colors: [Color(0xFF1243BF), Color(0xFF4C6AD4)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  DecoratedContainer(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16.0),
      this.useGradient = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: useGradient ? gradient : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

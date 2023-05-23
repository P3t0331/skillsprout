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
  final bool isDisabled;
  final bool isExpanded;

  DecoratedContainer(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16.0),
      this.useGradient = false,
      this.isDisabled = false,
      this.isExpanded = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExpanded ? double.infinity : null,
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey.shade400 : Colors.white,
        gradient: useGradient ? gradient : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDisabled
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
      ),
      padding: padding,
      child: child,
    );
  }
}

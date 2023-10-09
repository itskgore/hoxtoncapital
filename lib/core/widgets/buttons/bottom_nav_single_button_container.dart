import 'package:flutter/material.dart';

class BottomNavSingleButtonContainer extends StatelessWidget {
  final child;
  const BottomNavSingleButtonContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 87,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(height: 20, child: child),
        ),
      ),
    );
  }
}

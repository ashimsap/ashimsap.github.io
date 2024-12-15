import 'package:flutter/material.dart';

class  MyContainer extends StatelessWidget {
  const MyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(12),
    boxShadow:[
    BoxShadow(
    offset: const Offset(-5, -5),
    color: Colors.grey.shade500,
    blurRadius: 12,
    ),
    BoxShadow(
    offset: const Offset(5, 5),
    color: Colors.grey.shade900,
    blurRadius: 12,
    )],
    ),
    );
  }
}

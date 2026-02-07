import 'package:flutter/material.dart';

class DialogInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final bool isNumber;

  const DialogInput({super.key, required this.controller, required this.label, this.maxLines=1, this.isNumber=false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
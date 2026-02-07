import 'package:flutter/material.dart';
import 'package:nexuscrm/config/theme.dart';

class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Future<void> Function()? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  const ModernTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onTap,
    this.readOnly=false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE2E8F0).withOpacity(0.5),
            offset: Offset(0, 4),
            blurRadius: 10,
          )
        ]
      ),
      child: TextFormField(
        readOnly: readOnly,
        onChanged: onChanged,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        style: TextStyle(
          fontSize: 16,
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.5)),
          prefixIcon: prefixIcon != null 
            ? Icon(prefixIcon, color: AppTheme.primaryColor.withOpacity(0.7)) 
            : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent, // Handled by Container
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

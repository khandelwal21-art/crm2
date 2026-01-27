import 'package:flutter/material.dart';


class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int maxLines;
  final int minLines;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;

  const MyTextField({
    Key? key,
    this.controller,
    this.readOnly=false,
    this.onTap,
    this.maxLines=3,
    this.minLines=1,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      onTap: onTap,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 18.0),
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.black26
          )
        ),
      ),
    );
  }
}

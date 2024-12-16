// lib/views/widgets/auth/custom_text_field.dart

import 'package:flutter/material.dart';
import '../../../utils/theme_constants.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final IconData icon;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.hint,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    required this.icon,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.enabled ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscureText,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        style: TextStyle(
          fontSize: 16,
          color: widget.enabled ? Colors.black87 : Colors.grey.shade600,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
          ),
          prefixIcon: Icon(
            widget.icon,
            color: widget.enabled ? AppTheme.primaryColor : Colors.grey,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: widget.enabled ? AppTheme.primaryColor : Colors.grey,
            ),
            onPressed: widget.enabled
                ? () {
              setState(() {
                _obscureText = !_obscureText;
              });
            }
                : null,
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: widget.enabled ? Colors.white : Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
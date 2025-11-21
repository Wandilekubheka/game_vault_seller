import 'package:flutter/material.dart';
import 'package:game_vault_seller/core/theme/app_colors.dart';

class CustomTextfield extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const CustomTextfield({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: Color(AppColors.border)),
      controller: widget.controller,
      obscureText: _obscureText && widget.isPassword,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  widget.isPassword && _obscureText
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Color(AppColors.border),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        labelText: widget.label,
        hintText: widget.hint,
        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
          color: Color(AppColors.border),
        ),
        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle?.copyWith(
          color: Color(AppColors.border),
        ),
      ),
      validator: widget.validator,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';


class JumTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final FormControl<dynamic>? control;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const JumTextField({
    Key? key,
    required this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
    this.control,
    this.controller,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      prefixIcon: prefix,
      suffixIcon: suffix,
    );

    if (control != null) {
      return ReactiveTextField<dynamic>(
        formControl: control,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: decoration,
      );
    }

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
    );
  }
}

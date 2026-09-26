import 'package:flutter/material.dart';

class LoginTextFieldWidget extends StatefulWidget {
  final String label;
  final bool isPassword;
  final FocusNode focusNode;
  final TextInputAction action;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final void Function(String)? onTextChanged;
  final void Function(String)? onSubmitted;

  const LoginTextFieldWidget({
    super.key,
    required this.label,
    this.isPassword = false,
    required this.action,
    required this.focusNode,
    required this.controller,
    required this.validator,
    required this.onTextChanged,
    required this.onSubmitted,
  });

  @override
  State<StatefulWidget> createState() => _LoginTextFieldWidget();
}

class _LoginTextFieldWidget extends State<LoginTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      textAlignVertical: TextAlignVertical.bottom,
      textInputAction: widget.action,
      keyboardAppearance: Theme.of(context).brightness,
      obscureText: widget.isPassword,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        label: Text(
          widget.label,
          style: const TextStyle(fontFamily: 'Galada'),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        border: Theme.of(context).inputDecorationTheme.border,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        filled: Theme.of(context).inputDecorationTheme.filled,
      ),
      validator: (value) => widget.validator(value),
      onChanged: widget.onTextChanged,
      onFieldSubmitted: widget.onSubmitted,
    );
  }
}

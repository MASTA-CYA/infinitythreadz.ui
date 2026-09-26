import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final int maxLines;
  final String? Function(String?) validator;
  final String label;
  final String text;
  final String initialValue;
  final TextInputAction? inputAction;
  final void Function(String)? onChanged;
  final bool isNumberInput;
  final bool allowDecimal;
  final bool isReadOnly;
  final EdgeInsetsGeometry? contentPadding;

  const TextFieldWidget({
    super.key,
    this.controller,
    this.maxLines = 1,
    required this.validator,
    required this.label,
    required this.text,
    this.initialValue = '',
    this.inputAction = TextInputAction.done,
    required this.onChanged,
    this.isNumberInput = false,
    this.allowDecimal = false,
    this.isReadOnly = false,
    this.contentPadding,
  });

  @override
  State<StatefulWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isNumberInput
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: controller,
                textInputAction: widget.inputAction,
                readOnly: widget.isReadOnly,
                autocorrect: true,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: widget.allowDecimal),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(
                      _getRegexString(),
                    ),
                  ),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => newValue.copyWith(
                      text: newValue.text.replaceAll(',', '.'),
                    ),
                  ),
                ],
                decoration: InputDecoration(
                  contentPadding: widget.contentPadding,
                  labelText: widget.label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                // Handles Form Validation
                validator: widget.validator,
                maxLines: widget.maxLines,
                onChanged: widget.onChanged,
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: controller,
                textInputAction: widget.inputAction,
                readOnly: widget.isReadOnly,
                autocorrect: true,
                decoration: InputDecoration(
                  contentPadding: widget.contentPadding,
                  labelText: widget.label,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                // Handles Form Validation
                validator: widget.validator,
                maxLines: widget.maxLines,
                onChanged: widget.onChanged,
              ),
            ],
          );
  }

  String _getRegexString() {
    return widget.allowDecimal ? r'[0-9]+[,.]{0,1}[0-9]*' : r'[0-9]';
  }
}

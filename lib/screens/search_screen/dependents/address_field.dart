import 'package:flutter/material.dart';
import 'package:ridesense/widgets/input_textfield.dart';

class AddressField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String value) onChange;
  final String errorMessage;

  const AddressField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChange,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return InputTextField(
      onChange: (String value) => onChange(value),
      label: 'Enter address',
      controller: controller,
      focusNode: focusNode,
      errorMessage: errorMessage,
      maxLength: 200,
    );
  }
}

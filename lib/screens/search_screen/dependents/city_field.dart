import 'package:flutter/material.dart';
import 'package:ridesense/widgets/input_textfield.dart';

class CityField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String) onChange;
  final String errorMessage;
  const CityField(
      {super.key,
      required this.focusNode,
      required this.controller,
      required this.onChange,
      required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return InputTextField(
      onChange: (String value) => onChange(value),
      label: 'Enter city',
      errorMessage: errorMessage,
      controller: controller,
      focusNode: focusNode,
      maxLength: 100,
    );
  }
}

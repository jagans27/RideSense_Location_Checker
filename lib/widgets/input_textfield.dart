import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputTextField extends StatelessWidget {
  final Function(String) onChange;
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String errorMessage;
  final int maxLength;
  final bool isDouble;

  const InputTextField(
      {super.key,
      required this.onChange,
      required this.label,
      required this.controller,
      required this.focusNode,
      required this.errorMessage,
      required this.maxLength,
      this.isDouble = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          onChanged: (String value) => onChange(value),
          controller: controller,
          focusNode: focusNode,
          maxLength: maxLength,
          maxLines: 1,
          keyboardType: isDouble ? TextInputType.number : TextInputType.text,
          inputFormatters: [
            if (isDouble)
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          onTapOutside: (event) => focusNode.unfocus(),
          cursorColor: Colors.black,
          decoration: InputDecoration(
              counterText: "",
              error: errorMessage.isEmpty ? null : const SizedBox.shrink(),
              constraints: BoxConstraints(minHeight: 50.h, maxHeight: 50.h),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              labelText: label,
              labelStyle: TextStyle(
                  color: errorMessage.isEmpty ? Colors.black : Colors.red)),
        ),
        if (errorMessage.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 10.sp),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
          )
      ],
    );
  }
}

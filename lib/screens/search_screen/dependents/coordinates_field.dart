import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ridesense/widgets/input_textfield.dart';

class CoordinatesField extends StatelessWidget {
  final TextEditingController longTextEditingController;
  final FocusNode longFocusNode;
  final TextEditingController latiTextEditingController;
  final FocusNode latiFocusNode;
  final Function(String) onChangedLati;
  final Function(String) onChangedLong;
  final String longErrorMessage;
  final String latiErrorMessage;

  const CoordinatesField(
      {super.key,
      required this.longTextEditingController,
      required this.longFocusNode,
      required this.latiTextEditingController,
      required this.latiFocusNode,
      required this.onChangedLati,
      required this.onChangedLong,
      required this.longErrorMessage,
      required this.latiErrorMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InputTextField(
          onChange: (String value) => onChangedLong(value),
          label: 'Enter Longitude',
          controller: longTextEditingController,
          focusNode: longFocusNode,
          errorMessage: longErrorMessage,
          maxLength: 12,
          isDouble: true,
        ),
        SizedBox(
          height: 10.h,
        ),
        InputTextField(
          onChange: (String value) => onChangedLati(value),
          label: 'Enter Latitude',
          controller: latiTextEditingController,
          focusNode: latiFocusNode,
          errorMessage: latiErrorMessage,
          maxLength: 12,
          isDouble: true,
        ),
      ],
    );
  }
}

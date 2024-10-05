import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ridesense/utils/extensions.dart';

class SearchDropdown extends StatelessWidget {
  final List<String> dropDownItems;
  final String selectedItem;
  final Function(String) onSelection;
  const SearchDropdown(
      {super.key,
      required this.dropDownItems,
      required this.selectedItem,
      required this.onSelection});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: 300.w,
      onSelected: (String? value) {
        if (value != null) {
          onSelection(value);
        }
      },
      dropdownMenuEntries: List.generate(
        dropDownItems.length,
        (index) {
          return DropdownMenuEntry(
              value: dropDownItems[index],
              label: dropDownItems[index].capitalizeFirstLetter(),
              leadingIcon: const Icon(Icons.location_on_outlined),
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white)));
        },
      ),
      menuStyle: const MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white)),
      initialSelection: selectedItem,
      inputDecorationTheme: InputDecorationTheme(
          constraints: BoxConstraints(maxHeight: 50.h, minHeight: 50.h),
          border: const OutlineInputBorder()),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final Icon? prefixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final DateTime? selectedDate;
  final TextFormField? validator;
  void Function(String value) onSaveInputValue;
  InputField({
    super.key,
    this.prefixIcon,
    this.hintText,
    this.keyboardType,
    this.selectedDate,
    this.validator,
    this.onTap,
    required this.onSaveInputValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Container(
            constraints: prefixIcon == null
                ? const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  )
                : const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
            child: prefixIcon,
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the required field';
                }
                return null;
              },
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.black38,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onSaved: (value) {
                onSaveInputValue(value!);
              },
            ),
          ),
        ),
      ]),
    );
  }
}

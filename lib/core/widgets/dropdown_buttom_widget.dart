import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:BGP_Retail/core/constants/colors.dart';
import 'package:BGP_Retail/core/constants/typography.dart';

class DropdownButtonWidget<T> extends StatelessWidget {
  const DropdownButtonWidget({
    super.key,
    required this.hintText,
    required this.text,
    required this.onChanged,
    required this.items,
  });

  final String hintText;
  final String? text;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Text(
          text != null ? text! : hintText,
          style: text != null
              ? AppTypography.p5.copyWith(color: AppColors.black)
              : AppTypography.p6.copyWith(color: AppColors.grey_1),
          maxLines: 1,
        ),
        items: items,
        onChanged: onChanged,
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_rounded),
          openMenuIcon: Icon(
            Icons.keyboard_arrow_up_rounded,
          ),
          iconSize: 24,
        ),
        buttonStyleData: ButtonStyleData(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.border_2,
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 1,
          ),
          width: double.infinity,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 45,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          offset: const Offset(0, -2),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
      ),
    );
  }
}

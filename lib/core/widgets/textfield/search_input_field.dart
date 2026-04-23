import 'package:drmom/core/configs/app_style/init_app_style.dart';
import 'package:drmom/core/widgets/base_container.dart';
import 'package:flutter/material.dart';

class SearchInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onTapOutside;
  final Color? color;
  final Color? borderColor;
  const SearchInputField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.color,
    this.borderColor,
  });

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      color: widget.color ?? AppColors.carrot10,
      borderRadius: 100,
      borderColor: widget.borderColor ?? AppColors.carrot20,
      inkWell: true,
      onTap: () {
        _focusNode.requestFocus();
        widget.onTap?.call();
      },
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        onTap: () {
          _focusNode.requestFocus();
        },
        onTapOutside: (event) {
          _focusNode.unfocus();
          widget.onTapOutside?.call();
        },
        onSubmitted: (value) {
          _focusNode.unfocus();
          widget.onSubmitted?.call(value);
        },
        cursorColor: AppColors.main,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Tìm kiếm...',
          hintStyle: AppTypography.p6.copyWith(color: AppColors.search_hint),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.text_secondary,
            size: 24,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

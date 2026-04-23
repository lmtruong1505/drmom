import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:drmom/core/configs/app_style/init_app_style.dart";
import "package:drmom/core/configs/app_style/init_app_style.dart";
import "package:drmom/core/configs/app_style/init_app_style.dart";

class ValidateTextField extends StatefulWidget {
  const ValidateTextField({
    Key? key,
    this.backgroundColor,
    this.radius,
    this.controller,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.padding,
    this.margin,
    this.readOnly = false,
    this.trailingIcon,
    this.cursorColor,
    this.leadingIcon,
    this.focusNode,
    this.onChanged,
    this.obscureText = false,
    this.textInputType,
    this.border = true,
    this.maxLines,
    this.validator,
    this.formKey,
    this.errorStyle,
    this.initialValue,
    this.onTap,
    this.valueChange,
    this.defaultValue,
    this.emptySuffixIcon,
    this.onClear,
    this.isClear = false,
    this.autofocus,
    this.suffixIcon,
    this.inputFormatters,
    this.decoration,
    this.label,
  }) : super(key: key);

  final String? label;

  final Color? backgroundColor;
  final Color? cursorColor;
  final double? radius;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool readOnly;
  final bool? autofocus;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final bool obscureText;
  final TextInputType? textInputType;
  final bool? border;
  final bool? isClear;
  final int? maxLines;
  final String? Function(String?)? validator;
  final GlobalKey<FormState>? formKey;
  final TextStyle? errorStyle;
  final String? initialValue;
  final VoidCallback? onTap;
  final String? valueChange;
  final String? defaultValue;
  final Widget? emptySuffixIcon;
  final VoidCallback? onClear;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;

  @override
  State<ValidateTextField> createState() => _ValidateTextFieldState();
}

class _ValidateTextFieldState extends State<ValidateTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue)
          ..addListener(() {
            if (mounted) {
              setState(() {});
            }
          });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ValidateTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      // if (mounted) {
      //   _controller.text = widget.initialValue ?? '';
      //   setState(() {});
      // }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.initialValue ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.p5.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.text_secondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          autofocus: widget.autofocus ?? false,
          controller: _controller,
          onTap: () => widget.onTap?.call(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: _focusNode,
          scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          obscureText: widget.obscureText,
          maxLines: widget.maxLines ?? 1,
          keyboardType: widget.textInputType,
          validator: widget.validator,
          onChanged: (value) {
            widget.onChanged?.call(value);
          },
          inputFormatters: widget.inputFormatters,
          // scrollPadding: EdgeInsets.zero,
          readOnly: widget.readOnly,
          decoration:
              widget.decoration ??
              InputDecoration(
                errorStyle: AppTypography.p7,
                filled: true,
                fillColor: widget.backgroundColor ?? AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 8),
                  borderSide: BorderSide(
                    color: widget.border == true
                        ? AppColors.border_2
                        : Colors.transparent,
                    width: widget.border == true ? 1 : 0,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 5,
                  minHeight: 5,
                ),
                isDense: true,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 5,
                  minHeight: 5,
                ),
                prefixIcon: Padding(
                  padding: AppSpacing.l12,
                  child: widget.leadingIcon,
                ),
                suffixIcon: widget.suffixIcon != null
                    ? Padding(padding: AppSpacing.r12, child: widget.suffixIcon)
                    : (_controller.text.isNotEmpty
                          ? Padding(
                              padding: AppSpacing.r12,
                              child:
                                  widget.isClear == true &&
                                      _controller.text != widget.defaultValue
                                  ? GestureDetector(
                                      onTap: () {
                                        _controller.clear();
                                        widget.onClear?.call();
                                        setState(() {});
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: AppColors.grey_1,
                                      ),
                                    )
                                  : widget.emptySuffixIcon,
                            )
                          : Padding(
                              padding: AppSpacing.r12,
                              child:
                                  (widget.emptySuffixIcon ??
                                  const SizedBox.shrink()),
                            )),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 12),
                  borderSide: BorderSide(
                    color: widget.border == true
                        ? AppColors.main
                        : Colors.transparent,
                    width: widget.border == true ? 1.5 : 0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 12),
                  borderSide: BorderSide(
                    color: widget.border == true
                        ? const Color(0xFFEAECF0)
                        : Colors.transparent,
                    width: widget.border == true ? 1 : 0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 12),
                  borderSide: BorderSide(
                    color: widget.border == true
                        ? AppColors.red_1
                        : Colors.transparent,
                    width: widget.border == true ? 1 : 0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 12),
                  borderSide: BorderSide(
                    color: widget.border == true
                        ? AppColors.red_1
                        : Colors.transparent,
                    width: widget.border == true ? 1.5 : 0,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 12),
                  borderSide: BorderSide(
                    color: widget.border == true
                        ? const Color(0xFFEAECF0)
                        : Colors.transparent,
                    width: widget.border == true ? 1 : 0,
                  ),
                ),
                contentPadding:
                    widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                isCollapsed: true,
                hintText: widget.hintText ?? '',
                hintStyle:
                    widget.hintStyle ??
                    AppTypography.p6.copyWith(color: const Color(0xFF98A2B3)),
              ),
          cursorColor: widget.cursorColor ?? AppColors.bg_5,
          cursorWidth: 1,
          style: (widget.textStyle ?? AppTypography.p6).copyWith(
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

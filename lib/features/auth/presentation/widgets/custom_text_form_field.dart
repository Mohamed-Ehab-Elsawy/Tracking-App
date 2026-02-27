import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';

class CustomTextFormField extends StatefulWidget {
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final String hint;
  final String label;
  final Widget? suffixIcon;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool? readOnly;
  final Function(String value) onTextChange;
  final TextEditingController? controller;

  const CustomTextFormField({
    super.key,
    this.validator,
    this.hint = "",
    this.label = "",
    this.maxLines = 1,
    this.readOnly,
    this.suffixIcon,
    this.onTap,
    this.controller,
    this.textInputAction = TextInputAction.next,
    required this.keyboardType,
    required this.onTextChange,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool obscureText;

  @override
  void initState() {
    widget.controller;
    super.initState();
    if (widget.keyboardType == TextInputType.visiblePassword) {
      obscureText = true;
    } else {
      obscureText = false;
    }
    controller.addListener(() => widget.onTextChange(controller.text));
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    validator: widget.validator,
    controller: widget.controller,
    readOnly: widget.readOnly ?? false,
    onChanged: widget.onTextChange,
    onTap: widget.onTap,
    keyboardType: widget.keyboardType,
    maxLines: widget.maxLines,

    obscureText: obscureText,
    textInputAction: widget.textInputAction,
    decoration: InputDecoration(
      hint: Text(widget.hint),
      label: Text(widget.label),

      suffixIcon: widget.keyboardType == TextInputType.visiblePassword
          ? InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => setState(() => obscureText = !obscureText),
              child: Icon(
                obscureText
                    ? Icons.remove_red_eye_rounded
                    : Icons.disabled_visible_rounded,
                size: 24,
                color: context.colors.grey,
              ),
            )
          : widget.suffixIcon ?? widget.suffixIcon,
    ),
  );
}

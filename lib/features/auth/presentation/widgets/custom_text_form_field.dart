import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';

class CustomTextFormField extends StatefulWidget {
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final String hint;
  final String label;
  final TextInputType? keyboardType;
  final int maxLines;
  final Function(String value) onTextChange;

  const CustomTextFormField({
    super.key,
    this.validator,
    this.hint = "",
    this.label = "",
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    required this.keyboardType,
    required this.onTextChange,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final TextEditingController controller = TextEditingController();
  late bool obscureText;

  @override
  void initState() {
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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    validator: widget.validator,
    controller: controller,
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
          : null,
    ),
  );
}

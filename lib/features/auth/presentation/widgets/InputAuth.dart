import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';

class InputAuth extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const InputAuth({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<InputAuth> createState() => _InputAuthState();
}

class _InputAuthState extends State<InputAuth> {
  late final FocusNode _focusNode;
  late bool _obsecureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 322.w,
      child: Column(
        spacing: 8.w,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: TextStyle(color: Colors.black87)),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13.w),
              color: Colors.white,
              boxShadow: [
                _focusNode.hasFocus
                    ? BoxShadow(
                        color: AppColors.deepTeal50,
                        spreadRadius: 4.w,
                        blurRadius: 0,
                        offset: const Offset(0, 0),
                      )
                    : const BoxShadow(color: Colors.transparent),
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.isPassword ? _obsecureText : false,
              validator: widget.validator,
              style: AppTextStyles.inputTextStyles,
              decoration: InputDecoration(
                hintText: widget.hintText,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: () => setState(() {
                          _obsecureText = !_obsecureText;
                        }),
                        icon: _obsecureText
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      )
                    : null,
                contentPadding: EdgeInsets.all(8.w),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.w),
                  borderSide: BorderSide(
                    width: 1.5,
                    color: AppColors.inputColorBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.w),
                  borderSide: BorderSide(width: 1.5, color: AppColors.deepTeal),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

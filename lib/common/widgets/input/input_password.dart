import 'package:tunezmusic/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PassInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final Color? fillColor;
  final Color? focusFillColor; // Màu nền khi focus
  final EdgeInsets? contentPadding;
  final String? Function(String?)? validator; // Hàm validate

  const PassInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.fillColor,
    this.focusFillColor,
    this.contentPadding,
    this.validator,
  });

  @override
  _PassInputFieldState createState() => _PassInputFieldState();
}

class _PassInputFieldState extends State<PassInputField> {
  late FocusNode _focusNode;
  late Color _currentFillColor;
  late bool _obscureText; // Điều khiển ẩn/hiện mật khẩu
  String? _errorText; // Lưu trữ lỗi validate

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _currentFillColor = widget.fillColor ?? AppColors.darkGrey;
    _obscureText = true;

    // Gán giá trị ban đầu cho _errorText
    _errorText = widget.validator?.call(widget.controller.text);

    _focusNode.addListener(() {
      setState(() {
        _currentFillColor = _focusNode.hasFocus
            ? widget.focusFillColor ?? AppColors.focusInput // Màu sáng hơn khi focus
            : widget.fillColor ?? AppColors.darkGrey; // Màu gốc khi blur
      });

      // Validate khi mất focus
      if (!_focusNode.hasFocus && widget.validator != null) {
        _validate();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _validate() {
    final error = widget.validator?.call(widget.controller.text);
    setState(() {
      _errorText = error;
    });
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200), // Hiệu ứng chuyển màu
          decoration: BoxDecoration(
            color: _currentFillColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child:
          Padding(padding: EdgeInsets.only(left: 20),
          child:TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _obscureText,
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Colors.white70,
              ),
              border: InputBorder.none, // Không cần viền khi dùng `BoxDecoration`
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: _toggleObscureText,
              ), // Nút ẩn/hiện mật khẩu
            ),
          ) ,) 
        ),
        if (_errorText != null || widget.hintText != null) // Kiểm tra cả hintText
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorText ?? '', // Text hoặc lỗi
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

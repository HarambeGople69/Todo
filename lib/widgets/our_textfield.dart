import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;

  final Function(String) validator;
  final Function(String)? onchange;
  final IconData? icon;
  final TextInputType type;
  final String title;
  final int? length;

  const CustomTextField({
    Key? key,
    this.controller,
    required this.validator,
    this.icon,
    this.onchange,
    required this.title,
    required this.type,
    this.length,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (String? value) => widget.onchange!(value!),
      validator: (String? value) => widget.validator(value!),
      style: TextStyle(fontSize: ScreenUtil().setSp(15)),
      keyboardType: widget.type,
      maxLines: widget.length,
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontSize: ScreenUtil().setSp(
            20,
          ),
        ),
        prefixIcon: Icon(
          widget.icon,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ScreenUtil().setSp(
              30,
            ),
          ),
        ),
        labelText: widget.title,
        // labelStyle: paratext,
        errorStyle: TextStyle(
          fontSize: ScreenUtil().setSp(
            15,
          ),
        ),
      ),
    );
  }
}

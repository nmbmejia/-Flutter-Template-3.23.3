import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  const CustomInput(
      {super.key,
      this.textInputType = TextInputType.text,
      this.prefixIcon,
      this.obscureText = false,
      required this.hintText,
      this.onTextChanged});

  final Widget? prefixIcon;
  final bool obscureText;
  final String hintText;
  final TextInputType textInputType;
  final Function(String text)? onTextChanged;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        onChanged: (text) {
          if (widget.onTextChanged != null) {
            widget.onTextChanged!(text);
          }
        },
        textAlignVertical: TextAlignVertical.center,
        controller: TextEditingController(),
        obscureText: widget.obscureText,
        cursorColor: Colors.black87,
        cursorHeight: 24,
        keyboardType: widget.textInputType,
        cursorRadius: const Radius.elliptical(30, 30),
        style: const TextStyle(
            color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: Colors.black87.withOpacity(0.5),
              fontSize: 24,
              fontWeight: FontWeight.w400),
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10, left: 5),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: widget.prefixIcon,
                  ),
                )
              : null,
          // suffixIcon: GestureDetector(
          //   onTap: () {},
          //   child: const Icon(
          //     Icons.check_outlined,
          //     color: AppColors.monthlyColor,
          //     size: 32,
          //   ),
          // ),
          enabled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide:
                BorderSide(color: Colors.transparent), // No border color
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),

            borderSide: BorderSide(
                color:
                    Colors.transparent), // No border colorr color when focused
          ),
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
        ),
      ),
    );
  }
}

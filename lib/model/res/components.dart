import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText, label;
  final dynamic initialValue;
  final TextEditingController controller;
  final TextInputType keyboard;
  final FormFieldValidator? validator;
  final FormFieldSetter? onSaved;
  const CustomTextField(
      {super.key,
      this.hintText = '',
      this.initialValue,
      required this.controller,
      required this.label,
      required this.validator,
      required this.onSaved,
      this.keyboard = TextInputType.number});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        hintText: hintText,
        label: Text(label),
      ),
    );
  }
}

class CustomDropDownButton<T> extends StatelessWidget {
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged onChanged;
  final T? value;
  const CustomDropDownButton(
      {super.key,
      required this.hintText,
      required this.items,
      required this.onChanged,
      this.value});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        hintText: hintText,
        // border: const OutlineInputBorder()
      ),
      items: items,
      onChanged: onChanged,
      value: value,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPress;

  const CustomButton(
      {super.key,
      required this.title,
      required this.onPress,
      this.color = Colors.pink,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 40,
        width: double.infinity,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.zero, color: color),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

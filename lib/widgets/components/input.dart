import 'package:flutter/material.dart';

Widget getInputStyle(
  String label, String hint, TextEditingController controller, 
  IconData icon, {int maxLines=1, Function(String) validatorCallback,
  TextInputType inputType, bool capitalize}
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      onChanged: (value)=>controller.text = value, 
      maxLines: maxLines,
      initialValue: controller.text ?? "",
      keyboardType: inputType ?? TextInputType.multiline,
      textCapitalization: (capitalize ?? true)?TextCapitalization.sentences:TextCapitalization.none,
      validator: validatorCallback,
      autocorrect: true,
      autofocus: false,
      enableSuggestions: true,
      decoration: InputDecoration(                    
        labelText: label,
        hintText: hint,
        icon: icon != null?Icon(icon):null,
        border: OutlineInputBorder(),
      ),
    ),
  );
}
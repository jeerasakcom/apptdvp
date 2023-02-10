import 'package:flutter/material.dart';
import 'package:tdvp/utility/config_text.dart';

class ConfigEditForm extends StatelessWidget {
  final String label;
  final String? Function(String?) myValidate;
  final Function(String?) mySave;
  final TextEditingController? textEditingController;
  const ConfigEditForm({
    Key? key,
    required this.label,
    required this.myValidate,
    required this.mySave,
    this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        controller: textEditingController ?? TextEditingController(),
        onSaved: mySave,
        validator: myValidate,
        decoration: InputDecoration(
          label: ConfigText(lable: label),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

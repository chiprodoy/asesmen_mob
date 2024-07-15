import 'package:flutter/material.dart';

Widget ComboBoxNilai(dropdownValue, onChangeFunction) {
  print(dropdownValue);
  return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      items: <String>['0', '1', '2', '3', '4'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChangeFunction);
}
